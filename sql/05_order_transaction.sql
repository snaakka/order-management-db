BEGIN;

WITH updated_stock AS (
    UPDATE products
    SET stock = stock - 2
    WHERE product_id = 1
        AND stock >= 2
    RETURNING product_id, unit_price
),
new_order AS (
    INSERT INTO orders (
        customer_id, 
        status,
        shipping_address,
        shipping_city,
        shipping_zip_code,
        shipping_country
    )
    SELECT
        1, 'pending', 'Testikatu 1',
        'Joensuu', '80100', 'Finland'
    FROM updated_stock
    RETURNING order_id
)
INSERT INTO order_lines (
    order_id,
    product_id,
    quantity,
    unit_price_at_order
)
SELECT
    new_order.order_id,
    updated_stock.product_id,
    2,
    updated_stock.unit_price
FROM new_order
CROSS JOIN updated_stock
RETURNING order_id, product_id, quantity, unit_price_at_order;

COMMIT;