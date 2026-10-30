# Order Management Database

A PostgreSQL database project for managing customers, products, and orders in a small e-commerce system.

The project demonstrates relational database design, data integrity, SQL querying, transactional order processing, and query performance optimization.

## 1. Technologies

- PostgreSQL 16
- SQL
- psql (PostgreSQL command-line client)

## 2. Database Schema

The database consists of five tables:

| Table | Description |
|---|---|
| `categories` | Product categories |
| `products` | Products, prices, stock quantities, and categories |
| `customers` | Customer information |
| `orders` | Orders, statuses, shipping addresses, cities, and delivery dates |
| `order_lines` | Products and quantities associated with each order |

### Relationships

- One category can contain multiple products.
- One customer can place multiple orders.
- One order can contain multiple order lines.
- One product can appear in multiple orders.

The `order_lines` table implements the many-to-many relationship between orders and products.

Product prices at the time of purchase are stored in `order_lines.unit_price_at_order` to preserve historical order values.

## 3. Database Features

### Data integrity

The schema uses:

- Primary keys and foreign keys
- `NOT NULL` constraints
- `UNIQUE` constraints
- `CHECK` constraints
- Identity columns

For example, product prices must be positive, stock quantities cannot be negative, and shipped or completed orders must have a shipping date.

### Indexing

The project includes:

- B-tree index for product category lookups
- Composite index for customer order history
- Partial index for pending orders

### Transactional Order Processing

The project includes a transactional order processing example implemented in `sql/05_order_transaction.sql`.

The operation performs three steps:

1. Reduces product stock if sufficient inventory is available.
2. Creates a new order.
3. Inserts an order line using the product's current price.

The implementation uses data-modifying Common Table Expressions (CTEs) and `RETURNING` clauses to link these operations within a single atomic SQL statement.

If insufficient inventory is available, no order or order line is created.

**Tested scenarios:**

- Successful order: the order and order line are created, and inventory is reduced.
- Insufficient inventory: the statement returns `INSERT 0 0`, and no order is created.

## 4. Project Structure

```text
order-management-db/
├── README.md
├── sql/
│   ├── 01_schema.sql
│   ├── 02_seed_data.sql
│   ├── 03_performance_test.sql
│   ├── 04_indexes.sql
│   └── 05_order_transaction.sql
└── docs/
    └── query_optimization.md
```

## 5. Getting Started

**Prerequisites:** PostgreSQL 16 and the `psql` command-line client.

Clone the repository and navigate to the project directory.

Create the database:

```bash
createdb order_management
```

Create the schema:

```bash
psql -X -v ON_ERROR_STOP=1 -d order_management -f sql/01_schema.sql
```

Insert sample data:

```bash
psql -X -v ON_ERROR_STOP=1 -d order_management -f sql/02_seed_data.sql
```

Create indexes:

```bash
psql -X -v ON_ERROR_STOP=1 -d order_management -f sql/04_indexes.sql
```

**Optional: Create a sample order**

Run the transactional order processing example:

```bash
psql -X -v ON_ERROR_STOP=1 -d order_management -f sql/05_order_transaction.sql
```

The script creates a sample order for two units of product ID 1, provided sufficient stock is available.

**Note:** Running this script modifies the database by creating a new order and reducing inventory. Each successful execution creates another order.

**Optional: Generate performance test data** 

Insert additional test data for query performance experiments:

```bash
psql -X -v ON_ERROR_STOP=1 -d order_management -f sql/03_performance_test.sql
```

The performance test script is intended for a fresh database and should not be rerun without checking for duplicate test data.

## 6. Query Optimization

Query performance was investigated using:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM products
WHERE category_id = 2;
```

In an initial test with 10,006 products, the index scan completed in 0.041 ms compared with 0.784 ms for a forced sequential scan.

These are individual local measurements, not a comprehensive benchmark.

Detailed findings are documented in [Query Optimization](docs/query_optimization.md).

## 7. Project Purpose

This project was created to develop practical PostgreSQL skills through hands-on database design and implementation. It focuses on relational schema design, data integrity, indexing, transactional order processing, and SQL query performance analysis.