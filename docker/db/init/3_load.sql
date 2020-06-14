-- customer
COPY customer FROM '/tmp/data/customer.csv'
WITH CSV HEADER
;

-- category
COPY category FROM '/tmp/data/category.csv'
WITH CSV HEADER
;

-- product
COPY product FROM '/tmp/data/product.csv'
WITH CSV HEADER
;

-- receipt
COPY receipt FROM '/tmp/data/receipt.csv'
WITH CSV HEADER
;

-- store
COPY store FROM '/tmp/data/store.csv'
WITH CSV HEADER
;

-- geocode
COPY geocode FROM '/tmp/data/geocode.csv'
WITH CSV HEADER
;
