-- Create the database
CREATE DATABASE ecommerce;

-- Use the created database
USE ecommerce;
-- Create the 'customers' table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Create the 'orders' table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Create the 'products' table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);
-- Insert sample data into the 'customers' table
INSERT INTO customers (name, email, address) VALUES
('Alice Johnson', 'alice@example.com', '123 Maple St'),
('Bob Smith', 'bob@example.com', '456 Oak Ave'),
('Charlie Brown', 'charlie@example.com', '789 Pine Rd');

-- Insert sample data into the 'orders' table
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-10-15', 120.50),
(2, '2024-10-16', 200.00),
(3, '2024-10-10', 75.30);

-- Insert sample data into the 'products' table
INSERT INTO products (name, price, description) VALUES
('Product A', 25.00, 'Description for Product A'),
('Product B', 35.00, 'Description for Product B'),
('Product C', 40.00, 'Description for Product C');
-- Retrieve customers who placed an order in the last 30 days
SELECT DISTINCT c.name, c.email
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;
-- Get total amount of orders placed by each customer
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id;
-- Update the price of Product C to 45.00
UPDATE products
SET price = 45.00
WHERE name = 'Product C';
-- Add a 'discount' column to the 'products' table
ALTER TABLE products
ADD COLUMN discount DECIMAL(5, 2) DEFAULT 0.00;
-- Retrieve top 3 products with the highest price
SELECT name, price
FROM products
ORDER BY price DESC
LIMIT 3;
-- Get the names of customers who have ordered Product A
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';
-- Join 'orders' and 'customers' to get customer's name and order date
SELECT c.name AS customer_name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.id;
-- Retrieve orders with a total amount greater than 150.00
SELECT o.id, o.order_date, o.total_amount
FROM orders o
WHERE o.total_amount > 150.00;
-- Create the 'order_items' table to normalize the database
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Retrieve the average total of all orders
SELECT AVG(total_amount) AS avg_order_total
FROM orders;
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
SELECT 
    o.id AS order_id,
    c.name AS customer_name,
    o.order_date,
    p.name AS product_name,
    oi.quantity,
    p.price AS product_price,
    (oi.quantity * p.price) AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;
