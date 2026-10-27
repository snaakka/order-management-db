# Query Optimization and Indexing

## Overview

This document demonstrates PostgreSQL query optimization using `EXPLAIN (ANALYZE, BUFFERS)` and B-tree indexes.

## 1. Index Scan vs. Sequential Scan

**Dataset:** 10,006 products

**Query:**

```sql
SELECT *
FROM products
WHERE category_id = 2;
```

An index was created on `products(category_id)`.

| Metric | Index Scan | Sequential Scan |
|---|---:|---:|
| Execution time | 0.041 ms | 0.784 ms |
| Shared buffer hits | 3 | 84 |
| Rows returned | 1 | 1 |

The sequential scan was forced by temporarily disabling index scans and bitmap scans.

### Findings

The index scan was approximately 19 times faster in this particular measurement. It accessed substantially fewer buffer pages because only one product matched the condition.

This result illustrates the benefit of indexing selective columns. However, the measurements are from individual executions and should not be interpreted as a general performance benchmark.

## 2. Partial Index

**Query:**

```sql
SELECT *
FROM orders
WHERE status = 'pending'
ORDER BY order_date DESC
LIMIT 20;
```

**Index:**

```sql
CREATE INDEX idx_orders_pending
ON orders(order_date DESC)
WHERE status = 'pending';
```

The query planner selected a sequential scan followed by a sort.

- Table size: 5 orders
- Matching rows: 1
- Execution time: 0.088 ms

### Findings

For very small tables, a sequential scan can be more efficient than an index scan. PostgreSQL chooses execution plans based on estimated costs rather than automatically using available indexes.

## 3. Key Takeaways

- Indexes are especially useful for selective queries.
- Composite index column order matters.
- Partial indexes can reduce index size and maintenance overhead.
- Indexes introduce additional storage and write costs.
- Query performance should be evaluated using execution plans and repeated measurements.