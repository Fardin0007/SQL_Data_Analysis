-- Task 3: SQL for Data Analysis

CREATE DATABASE ecommerce;
USE ecommerce;

SHOW TABLES;
DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE products;
DESCRIBE categories;

SELECT * FROM customers LIMIT 20;

SELECT customer_id, customer_name, city
FROM customers
WHERE city = 'Mumbai';

SELECT order_id, customer_id, total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 10;

SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

SELECT p.product_id, p.product_name, c.category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;

SELECT c.customer_id, c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

SELECT *
FROM customers
WHERE customer_id IN (
      SELECT customer_id
      FROM orders
      GROUP BY customer_id
      HAVING SUM(total_amount) > (SELECT AVG(total_amount) FROM orders)
);

SELECT product_id, product_name, price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

SELECT SUM(total_amount) AS total_revenue
FROM orders;

SELECT AVG(total_amount) AS avg_order_value
FROM orders;

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

CREATE VIEW best_selling_products AS
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

SELECT * FROM best_selling_products ORDER BY total_sold DESC;

CREATE INDEX idx_orders_customerid ON orders(customer_id);
CREATE INDEX idx_orderitems_productid ON order_items(product_id);

SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    p.product_name,
    oi.quantity,
    (oi.quantity * p.price) AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_date DESC;
