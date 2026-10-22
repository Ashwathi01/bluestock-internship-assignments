USE week1_sales;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT * FROM Products;
SELECT product_name, unit_price FROM products
SELECT product_name, unit_price FROM products WHERE category ='Electronics'
SELECT product_name, unit_price FROM products ORDER BY unit_price DESC limit 3;
SELECT order_id,quantity,discount_pct FROM orders WHERE quantity = 5
SELECT * FROM orders WHERE Payment_Mode = 'UPI' AND discount_pct >= 10
SELECT COUNT(*) AS total_orders, SUM(quantity) AS total_units FROM orders
SELECT payment_mode, COUNT(*) AS orders FROM orders GROUP BY payment_mode;
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 20;
SELECT p.category,
SUM(o.quantity * p.unit_price * (1 - o.discount_pct / 100)) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;
SELECT p.product_name,
SUM(o.quantity * p.unit_price * (1 - o.discount_pct / 100)) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 3;
SELECT
    o.order_id,
    c.customer_id,
    p.product_name,
    o.quantity,
    p.unit_price
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN products p
    ON o.product_id = p.product_id
LIMIT 10;

SELECT product_name, unit_price
FROM products
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM products
);

SELECT order_id, quantity
FROM orders
WHERE quantity > (
    SELECT AVG(quantity)
    FROM orders
);


SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders
        GROUP BY customer_id
    ) AS customer_orders
);


SELECT
    product_name,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM (
    SELECT
        p.product_name,
        SUM(
            o.quantity * p.unit_price *
            (1 - o.discount_pct / 100)
        ) AS revenue
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY p.product_name
) AS product_revenue;


SELECT
    customer_id,
    COUNT(*) AS total_orders,
    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS order_rank
FROM orders
GROUP BY customer_id;


SELECT
    category,
    product_name,
    revenue,
    RANK() OVER (
        PARTITION BY category
        ORDER BY revenue DESC
    ) AS category_rank
FROM (
    SELECT
        p.category,
        p.product_name,
        SUM(
            o.quantity * p.unit_price *
            (1 - o.discount_pct / 100)
        ) AS revenue
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY p.category, p.product_name
) AS category_revenue;




