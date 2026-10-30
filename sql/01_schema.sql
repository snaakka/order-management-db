CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(150) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    category_id INTEGER NOT NULL REFERENCES categories(category_id),
    stock INTEGER NOT NULL CHECK (stock >= 0)
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(200) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipping_date TIMESTAMPTZ,
    status VARCHAR(20) NOT NULL 
        CONSTRAINT valid_status 
        CHECK (status IN ('pending', 'processing', 'shipped', 'completed', 'cancelled')),
    shipping_address VARCHAR(200) NOT NULL,
    shipping_city VARCHAR(100) NOT NULL,
    shipping_zip_code VARCHAR(20) NOT NULL,
    shipping_country VARCHAR(100) NOT NULL,

    CONSTRAINT valid_shipping_date
        CHECK (shipping_date >= order_date),

    CONSTRAINT shipping_date_required
        CHECK (
            status NOT IN ('shipped', 'completed')
            OR shipping_date IS NOT NULL
        )
);

CREATE TABLE order_lines (
    order_line_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL
        CONSTRAINT positive_quantity
        CHECK (quantity > 0),
    unit_price_at_order NUMERIC(10,2) NOT NULL
        CONSTRAINT positive_unit_price_at_order
        CHECK (unit_price_at_order > 0),

    CONSTRAINT not_duplicate_product_lines_within_order
        UNIQUE (order_id, product_id)
);