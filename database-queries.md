# SQL Queries Documentation

## Overview

This document provides a collection of SQL queries to perform common database operations such as inserting, updating, deleting, and retrieving data from the database. Each query is tailored to match the schema provided in the database documentation.

---

## Create Table Queries

### Create Author
```sql
CREATE TABLE IF NOT EXISTS authors (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL
);
```

### Create Book
```sql
CREATE TABLE IF NOT EXISTS books (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    author_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    stock_quantity INT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
);
```

### Create Users
```sql
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL UNIQUE,
    account_type VARCHAR(10) CHECK (account_type IN ('ADMIN', 'USER')) NOT NULL
);
```

### Create Orders
```sql
CREATE TABLE IF NOT EXISTS orders (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL,
    book_id BIGINT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    quantity INT NOT NULL,
    total_amount INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES "users"(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);
```

---

## Generic Queries

For all tables we created a class Generic DAO that does basic generic queries

### Insert New Relation
```sql
INSERT INTO table_name (field_name1, field_name2, ... field_nameX) VALUES (?, ?, ... ?)
```

### Select All Relations
```sql
SELECT * FROM table_name;
```

### Select Relation By ID
```sql
SELECT * FROM table_name WHERE id = ?;
```

### Update Relation By ID
```sql
UPDATE table_name SET field_name1 = ?, field_name2 = ?, ... field_namex = ? WHERE id = ?
```

### Delete Relation By ID
```sql
DELETE FROM table_name WHERE id = ?;
```

---

## Table Specific Queries

Of course there are non generic situations such as getting top N selling books, for these cases we have specific queries

### Get Books' And Their Quantity Owned By User
```sql
SELECT book_id, user_id, SUM(quantity) AS owned_books_count 
FROM orders 
WHERE user_id = ? group by book_id, user_id;
```

### Get Book's Quantity Owned By User
```sql
SELECT SUM(quantity) AS total_quantity 
FROM orders 
WHERE user_id = ? and book_id = ?;
```

### Update Book's Quantity
```sql
UPDATE books 
SET stock_quantity = ? 
WHERE id = ?
```

### Get Top Worst Selling Books
```
SELECT 
    b.id ,
    b.author_id,
    b.title,
    b.description,
    b.price,
    b.stock_quantity,
    COALESCE(SUM(o.quantity), 0) AS total_quantity_sold,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM
    books b
LEFT JOIN 
    "orders" o ON b.id = o.book_id
GROUP BY 
    b.id, b.title, b.description, b.price, b.stock_quantity
ORDER BY 
    total_quantity_sold ASC
LIMIT ?;
```

### Get Top Best Selling Books
```
SELECT 
    b.id ,
    b.author_id,
    b.title,
    b.description,
    b.price,
    b.stock_quantity,
    COALESCE(SUM(o.quantity), 0) AS total_quantity_sold,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM
    books b
LEFT JOIN 
    "orders" o ON b.id = o.book_id
GROUP BY 
    b.id, b.title, b.description, b.price, b.stock_quantity
ORDER BY 
    total_quantity_sold DESC
LIMIT ?;
```

### Get Books Count
```sql
SELECT COUNT(*) AS total_books 
FROM books
```

### Get Available Books Count
```sql
SELECT COUNT(*) AS total_books 
FROM books 
WHERE is_available = true
```

### Get Total Books Revenue 
```sql
SELECT COALESCE(SUM(o.total_amount), 0) AS total_revenue 
FROM orders AS o;
```

### Find Author By Name
```sql 
SELECT * 
FROM authors
WHERE name = ?
```

### Count Authors
```sql
SELECT COUNT(*) AS total_authors 
FROM authors
```
### Find User By Username And Password
```sql
SELECT * 
FROM users
WHERE email = ? AND password = ?;
```