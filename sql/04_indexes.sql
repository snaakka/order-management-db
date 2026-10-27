-- Speed up product lookups by category
CREATE INDEX IF NOT EXISTS idx_products_category
ON products(category_id);

-- Speed up retrieval of a customer's newest orders
CREATE INDEX IF NOT EXISTS idx_orders_customer_date
ON orders(customer_id, order_date DESC);

-- Speed up retrieval of newest pending orders
CREATE INDEX IF NOT EXISTS idx_orders_pending
ON orders(order_date DESC)
WHERE status = 'pending';