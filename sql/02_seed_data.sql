INSERT INTO categories (name)
VALUES 
    ('Electronics'),
    ('Clothing'),
    ('Home');


INSERT INTO products (
    name, unit_price, category_id, stock
)
VALUES
    ('Wireless Mouse', 29.90, 1, 50),
    ('Mechanical Keyboard', 89.90, 1, 25),
    ('USB-C Cable', 12.90, 1, 100),
    ('T-Shirt', 19.90, 2, 60),
    ('Coffee Maker', 79.90, 3, 15),
    ('Desk Lamp', 39.90, 3, 30);


INSERT INTO customers (
    name, address, zip_code, country, email
)
VALUES
    ('Anna Korhonen', 'Koulukatu 12', '80100', 'Finland', 'anna@example.com'),
    ('Matti Virtanen', 'Kauppakatu 5', '80110', 'Finland', 'matti@example.com'),
    ('Laura Nieminen', 'Kirkkokatu 8', '80200', 'Finland', 'laura@example.com'),
    ('Erik Svensson', 'Storgatan 15', '11122', 'Sweden', 'erik@example.com'),
    ('Sofia Müller', 'Hauptstrasse 20', '10115', 'Germany', 'sofia@example.com');


INSERT INTO orders (
    customer_id, order_date, shipping_date, status,
    shipping_address, shipping_zip_code, shipping_country
)
VALUES
    (1, '2026-10-01 10:00:00+03', NULL, 'pending',
     'Koulukatu 12', '80100', 'Finland'),

    (2, '2026-10-02 12:30:00+03', '2026-10-03 09:00:00+03', 'shipped',
     'Kauppakatu 5', '80110', 'Finland'),

    (3, '2026-10-04 14:00:00+03', '2026-10-06 11:00:00+03', 'completed',
     'Kirkkokatu 8', '80200', 'Finland'),

    (4, '2026-10-05 16:15:00+03', NULL, 'processing',
     'Storgatan 15', '11122', 'Sweden'),

    (5, '2026-10-07 08:45:00+03', NULL, 'cancelled',
     'Hauptstrasse 20', '10115', 'Germany');


INSERT INTO order_lines (
    order_id, product_id, quantity, unit_price_at_order
)
VALUES
    (1, 1, 2, 29.90),
    (1, 3, 1, 12.90),
    (2, 2, 1, 89.90),
    (2, 3, 2, 12.90),
    (3, 5, 1, 79.90),
    (3, 6, 2, 39.90),
    (4, 4, 3, 19.90),
    (5, 1, 1, 29.90);