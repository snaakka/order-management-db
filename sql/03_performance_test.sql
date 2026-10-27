INSERT INTO products (
    name, unit_price, category_id, stock
)
SELECT 
    'Test Product' || n,
    19.90,
    1,
    100
FROM generate_series(1, 10000) AS n;