# Extra Problem Answers

## EP-001 (S-004)
```sql
CREATE INDEX IF NOT EXISTS idx_receipt_customer ON receipt (customer_id);

EXPLAIN
SELECT
    sales_ymd,
    customer_id,
    product_cd,
    amount
FROM
    receipt
WHERE
    customer_id = 'CS018205000001';
```

## EP-002 (S-005)
```sql
CREATE INDEX IF NOT EXISTS idx_receipt_customer_amount ON receipt (customer_id, amount);

EXPLAIN
SELECT
    sales_ymd,
    customer_id,
    product_cd,
    amount
FROM
    receipt
WHERE
    customer_id = 'CS018205000001'
    AND amount >= 1000;
```

## EP-003 (S-006)
```sql
CREATE INDEX IF NOT EXISTS idx_receipt_customer_amt_qty ON receipt (customer_id, amount, quantity);

EXPLAIN
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
    AND (
        amount >= 1000
        OR quantity >= 5
    );
```

## EP-004 (S-007)
```sql
CREATE INDEX IF NOT EXISTS idx_receipt_customer_amount_range ON receipt (customer_id, amount);

EXPLAIN
SELECT
    sales_ymd,
    customer_id,
    product_cd,
    amount
FROM
    receipt
WHERE
    customer_id = 'CS018205000001'
    AND amount BETWEEN 1000 AND 2000;
```

## EP-005 (S-008)
```sql
CREATE INDEX IF NOT EXISTS idx_receipt_customer_product ON receipt (customer_id, product_cd);

EXPLAIN
SELECT
    sales_ymd,
    customer_id,
    product_cd,
    amount
FROM
    receipt
WHERE
    customer_id = 'CS018205000001'
    AND product_cd != 'P071401019';
```

## EP-006 (S-069)
```sql
CREATE INDEX IF NOT EXISTS idx_product_category_major ON product (category_major_cd);

EXPLAIN
WITH amount_all AS (
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
        ON r.product_cd = p.product_cd
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
    ON amount_all.customer_id = amount_07.customer_id
LIMIT 10;
```

## EP-007 (S-084)
```sql
CREATE INDEX IF NOT EXISTS idx_receipt_sales_ymd ON receipt (sales_ymd);

EXPLAIN
CREATE TABLE sales_rate AS (
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
        ON a.customer_id = c.customer_id
);

CREATE INDEX IF NOT EXISTS idx_sales_rate ON sales_rate (sales_rate);

EXPLAIN
SELECT * FROM sales_rate
WHERE sales_rate > 0
LIMIT 10;

EXPLAIN
SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS unit_price,
    SUM(CASE WHEN sales_amount_2019 IS NULL THEN 1 ELSE 0 END) AS unit_price,
    SUM(CASE WHEN sales_amount_all IS NULL THEN 1 ELSE 0 END) AS unit_cost,
    SUM(CASE WHEN sales_rate IS NULL THEN 1 ELSE 0 END) AS unit_cost
FROM sales_rate;
```
