-- Combined SQL Queries

-- Create Table Queries

CREATE TABLE IF NOT EXISTS authors (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS books (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    author_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    stock_quantity INT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL UNIQUE,
    account_type VARCHAR(10) CHECK (account_type IN ('ADMIN', 'USER')) NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL,
    book_id BIGINT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    quantity INT NOT NULL,
    total_amount INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- Generic Queries

-- Authors Table Queries
INSERT INTO authors (name) VALUES (?);
SELECT * FROM authors;
SELECT * FROM authors WHERE id = ?;
UPDATE authors SET name = ? WHERE id = ?;
DELETE FROM authors WHERE id = ?;

-- Books Table Queries
INSERT INTO books (author_id, title, description, price, stock_quantity) VALUES (?, ?, ?, ?, ?);
SELECT * FROM books;
SELECT * FROM books WHERE id = ?;
UPDATE books SET author_id = ?, title = ?, description = ?, price = ?, stock_quantity = ? WHERE id = ?;
DELETE FROM books WHERE id = ?;

-- Users Table Queries
INSERT INTO users (name, email, password, account_type) VALUES (?, ?, ?, ?);
SELECT * FROM users;
SELECT * FROM users WHERE id = ?;
UPDATE users SET name = ?, email = ?, password = ?, account_type = ? WHERE id = ?;
DELETE FROM users WHERE id = ?;

-- Orders Table Queries
INSERT INTO orders (user_id, book_id, order_date, quantity, total_amount) VALUES (?, ?, ?, ?, ?);
SELECT * FROM orders;
SELECT * FROM orders WHERE id = ?;
UPDATE orders SET user_id = ?, book_id = ?, order_date = ?, quantity = ?, total_amount = ? WHERE id = ?;
DELETE FROM orders WHERE id = ?;

-- Specific Queries

-- Get Books' And Their Quantity Owned By User
SELECT book_id, user_id, SUM(quantity) AS owned_books_count 
FROM orders 
WHERE user_id = ? 
GROUP BY book_id, user_id;

-- Get Book's Quantity Owned By User
SELECT SUM(quantity) AS total_quantity 
FROM orders 
WHERE user_id = ? AND book_id = ?;

-- Update Book's Quantity
UPDATE books 
SET stock_quantity = ? 
WHERE id = ?;

-- Get Top Worst Selling Books
SELECT 
    b.id,
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
    orders o ON b.id = o.book_id
GROUP BY 
    b.id, b.title, b.description, b.price, b.stock_quantity
ORDER BY 
    total_quantity_sold ASC
LIMIT ?;

-- Get Top Best Selling Books
SELECT 
    b.id,
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
    orders o ON b.id = o.book_id
GROUP BY 
    b.id, b.title, b.description, b.price, b.stock_quantity
ORDER BY 
    total_quantity_sold DESC
LIMIT ?;

-- Get Books Count
SELECT COUNT(*) AS total_books 
FROM books;

-- Get Available Books Count
SELECT COUNT(*) AS total_books 
FROM books 
WHERE stock_quantity > 0;

-- Get Total Books Revenue
SELECT COALESCE(SUM(o.total_amount), 0) AS total_revenue 
FROM orders o;

-- Find Author By Name
SELECT * 
FROM authors
WHERE name = ?;

-- Count Authors
SELECT COUNT(*) AS total_authors 
FROM authors;

-- Find User By Username And Password
SELECT * 
FROM users
WHERE email = ? AND password = ?;
