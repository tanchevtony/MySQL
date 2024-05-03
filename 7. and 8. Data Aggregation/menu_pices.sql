USE restaurant;

SELECT 
    category_id,
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS cheapest_product,
    MAX(price) AS most_expensive_product
FROM
    products
GROUP BY category_id
ORDER BY category_id;
