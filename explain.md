# Execution plan review

- Ran `EXPLAIN (ANALYZE, FORMAT JSON)` against the 129 executable answer statements from `ans_preprocess_knock_SQL.ipynb` via the Postgres container to capture every plan; `COPY` statements (S-094–S-100) were skipped because they are server-side file operations without meaningful scan plans.
- `Seq Scan` nodes in the plans indicate the ALL scans requested in the brief; the bullets below isolate the statements where those scans are avoidable by indexing.

## ALL-scan statements that can use indexes

- **S-004** – 顧客ID1件を抽出するフィルタ付き売上参照
  ```sql
  SELECT
      sales_ymd,
      customer_id,
      product_cd,
      amount
  FROM
      receipt
  WHERE
      customer_id = 'CS018205000001'
  ```
  - Plan: `Seq Scan` on `receipt` (~1.67M rows) to return just 64 rows for a single customer.
  - Fix: add a btree index such as `CREATE INDEX idx_receipt_customer ON receipt (customer_id);` so equality probes use an index-only or index scan instead of reading the whole table.

- **S-005** – 顧客ID + amount>=1000 の抽出
  ```sql
  SELECT
      sales_ymd,
      customer_id,
      product_cd,
      amount
  FROM
      receipt
  WHERE
      customer_id = 'CS018205000001'
      AND amount >= 1000
  ```
  - Plan: same `Seq Scan` on `receipt` for 16 qualifying rows, even though the predicate narrows down one customer.
  - Fix: the `receipt(customer_id)` index above (optionally extended to `(customer_id, amount)`) lets Postgres seek to that customer's rows before applying the amount filter.

- **S-006** – 顧客ID + (amount>=1000 OR quantity>=5)
  ```sql
  SELECT
      sales_ymd,
      customer_id,
      product_cd,
      quantity,
      amount
  FROM
      receipt
  WHERE
      customer_id = 'CS018205000001'
      AND
      (
          amount >= 1000
          OR quantity >= 5
      )
  ```
  - Plan: `Seq Scan` on `receipt` to evaluate the disjunctive predicate, returning only 27 rows.
  - Fix: reuse `idx_receipt_customer`; the index constrains the scan to the customer's partition and the residual OR filter is evaluated on that tiny subset instead of the entire fact table.

- **S-007** – 顧客ID + amount BETWEEN 1000 AND 2000
  ```sql
  SELECT
      sales_ymd,
      customer_id,
      product_cd,
      amount
  FROM
      receipt
  WHERE
      customer_id = 'CS018205000001'
      AND amount BETWEEN 1000 AND 2000
  ```
  - Plan: another full-table `Seq Scan` on `receipt` to fetch five rows within a range for one customer.
  - Fix: `receipt(customer_id, amount)` (customer leading column) enables an index scan that can both isolate the customer and apply the range constraint.

- **S-008** – 顧客ID + 商品コード除外
  ```sql
  SELECT
      sales_ymd,
      customer_id,
      product_cd, amount
  FROM
      receipt
  WHERE
      customer_id = 'CS018205000001'
      AND product_cd != 'P071401019'
  ```
  - Plan: `Seq Scan` on `receipt` (~1.67M rows) despite returning 64 rows once the customer filter is applied.
  - Fix: the same `receipt(customer_id)` index eliminates the ALL scan; the `product_cd != ...` predicate is cheap to evaluate once the customer rows are found.

- **S-069** – 商品カテゴリ07の売上比率計算
  ```sql
  WITH amount_all AS(
      SELECT
          customer_id,
          SUM(amount) AS sum_all
      FROM
          receipt
      GROUP BY
          customer_id
  ),
  amount_07 AS (
      SELECT
          r.customer_id,
          SUM(r.amount) AS sum_07
      FROM
          receipt r
      JOIN
          product p
      ON
          r.product_cd = p.product_cd
      WHERE
          p.category_major_cd = '07'
      GROUP BY
          customer_id
  )
  SELECT
      amount_all.customer_id,
      sum_all,
      sum_07,
      sum_07 * 1.0 / sum_all AS sales_rate
  FROM
      amount_all
  JOIN
      amount_07
  ON
      amount_all.customer_id = amount_07.customer_id
  LIMIT 10
  ```
  - Plan: `Seq Scan` on `product` (~10K rows) with filter `category_major_cd = '07'`, pulling ~4K rows before the join.
  - Fix: create `CREATE INDEX idx_product_category_major ON product (category_major_cd);` so the join only touches the needed category range instead of reading the full product dimension.

- **S-084** – 2019年売上比率データ作成 (CTAS 内)
  ```sql
  CREATE TABLE sales_rate AS(
      WITH sales_amount_2019 AS (
          SELECT
              customer_id,
              SUM(amount) AS sum_amount_2019
          FROM
              receipt
          WHERE
              sales_ymd BETWEEN 20190101 AND 20191231
          GROUP BY
              customer_id
      ),
      sales_amount_all AS (
          SELECT
              customer_id,
              SUM(amount) AS sum_amount_all
          FROM
              receipt
          GROUP BY
              customer_id
      )
      SELECT
          a.customer_id,
          COALESCE(b.sum_amount_2019, 0) AS sales_amount_2019,
          COALESCE(c.sum_amount_all, 0)  AS sales_amount_all,
          CASE COALESCE(c.sum_amount_all, 0)
              WHEN 0 THEN 0 
              ELSE COALESCE(b.sum_amount_2019, 0) * 1.0 / c.sum_amount_all
          END AS sales_rate
      FROM
          customer a
      LEFT JOIN
          sales_amount_2019 b
      ON a.customer_id = b.customer_id
      LEFT JOIN
          sales_amount_all c
      ON a.customer_id = c.customer_id)
  ```
  - Plan: inside this CTAS, the `sales_amount_2019` CTE performs a `Seq Scan` on `receipt` with a `sales_ymd BETWEEN 20190101 AND 20191231` filter, reading ~180K rows out of 1.67M.
  - Fix: add a date index such as `CREATE INDEX idx_receipt_sales_ymd ON receipt (sales_ymd);` (or `(sales_ymd, customer_id)` if range-by-customer queries are common) so time-slice aggregations avoid scanning the full receipt fact table.
