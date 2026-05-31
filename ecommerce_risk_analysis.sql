create database ecommerce;
use ecommerce;
select * from synthetic_ecommerce_order_risk_dataset;
rename table synthetic_ecommerce_order_risk_dataset to orders;
select * from  orders;

-- check null values
SELECT *
FROM orders
WHERE order_id IS NULL;

-- check duplicates
select order_id, count(*)
from orders
group by order_id
having count(*)>1;

-- total orders
select count(*) as total_orders
from orders;

-- total revenue
SELECT ROUND(SUM(order_value_eur),2) AS revenue
from orders;

-- orders by country
select country, count(*) as orders
from orders
group by country
order by orders desc;

-- avg order values
select round(avg(order_value_eur),2) as average_order
from orders;

-- segmentation
SELECT
CASE
WHEN previous_orders >= 5 THEN 'Loyal'
WHEN previous_orders >= 2 THEN 'Regular'
ELSE 'New'
END customer_segment, COUNT(*) total_orders,
ROUND(AVG(order_value_eur),2) avg_order_value
FROM orders
GROUP BY customer_segment;

-- spending segmantatiopn
SELECT
CASE
    WHEN avg_order_value_eur >= 75 THEN 'High Value'
    WHEN avg_order_value_eur >= 40 THEN 'Medium Value'
    ELSE 'Low Value'
END spending_segment, COUNT(*) orders,
ROUND(AVG(order_value_eur),2) avg_purchase
FROM orders
GROUP BY spending_segment;

-- fraud rate by product category
SELECT product_category,
    COUNT(*) total_orders,
    SUM(is_fraud) fraud_orders,
    ROUND(100.0 * SUM(is_fraud)/COUNT(*),2) fraud_rate
FROM orders
GROUP BY product_category
ORDER BY fraud_rate DESC;

-- fraud by device type & payment method
SELECT device_type,
    payment_method,
    SUM(is_fraud) fraud_cases
FROM orders
GROUP BY device_type, payment_method
ORDER BY fraud_cases DESC;
