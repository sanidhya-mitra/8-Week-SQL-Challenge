-- 1) What is the total amount each customer spent at the restuarant?

SELECT s.customer_id, sum(price) as total_amt FROM sales s
JOIN menu m ON m.product_id = s.product_id
GROUP BY customer_id;

-- 2) How many days has each customer visited the restaurant?

SELECT customer_id, COUNT(order_date) FROM sales
GROUP BY customer_id;

-- 3) What was the first item from the menu purchased by each customer?

WITH CTE AS
(
	SELECT S.customer_id, 
    DENSE_RANK() OVER(PARTITION BY S.customer_id ORDER BY S.order_date) AS rank_num, M.product_name
	FROM sales S
	JOIN menu M ON S.product_id = M.product_id
)
SELECT customer_id, product_name
FROM CTE
WHERE rank_num = 1;

-- 4) What is the most purchased item on the menu and how many times was it purchased by all customer?

SELECT M.product_name,COUNT(S.product_id) AS most_ordered
FROM Sales S
JOIN menu M ON S.product_id = M.product_id
GROUP BY M.product_name
ORDER BY most_ordered DESC
LIMIT 1; 

-- 5) Which item was the most popular for each customer?

SELECT * FROM (
	SELECT customer_id, product_name, count(product_name) as product_count,
	DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY count(product_name) DESC) AS rnk
	FROM sales s
	JOIN menu M ON S.product_id = M.product_id
	GROUP BY customer_id, product_name
	ORDER BY customer_id, product_count DESC) AS popularity
WHERE rnk = 1;

-- 6) Which item was purchased first by the customer after they became a member?

SELECT s.customer_id, join_date, order_date, product_name FROM sales s
JOIN members mbr ON mbr.customer_id = s.customer_id
JOIN menu m on m.product_id = s.product_id
WHERE order_date > join_date
ORDER BY customer_id;

-- 7) Which item was purchased just before the customer became a member?

SELECT * FROM (
	SELECT DISTINCT (s.customer_id), join_date, order_date, product_name,
	DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) as rnk
	FROM sales s
	JOIN members mbr ON mbr.customer_id = s.customer_id
	JOIN menu m on m.product_id = s.product_id
	WHERE order_date < join_date
	ORDER BY customer_id
) AS first_order
WHERE rnk = 1;

-- 8) What is the total items and amount spent for each member before they became a member?

SELECT s.customer_id, COUNT(m.product_name) AS total_products	, SUM(price) AS total_price
FROM sales s
JOIN members mbr ON mbr.customer_id = s.customer_id
JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date < mbr.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 9) If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT customer_id, sum(points) as total_points FROM (
	SELECT s.customer_id, product_name, price AS total_price,
		CASE 
			WHEN product_name = "sushi" THEN price*20
			ELSE price*10
			END AS points
	FROM sales s
	JOIN menu m ON m.product_id = s.product_id
    ) AS total_points
    GROUP BY customer_id
    ORDER BY customer_id;
    
-- 10) In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi
	-- how many points do customer A and B have at the end of January?

WITH dates_cte AS (
  SELECT 
    customer_id, 
    join_date, 
    DATE_ADD(join_date, INTERVAL 6 DAY) AS valid_date,
    LAST_DAY(join_date) AS last_date
  FROM members
)

SELECT s.customer_id, SUM(CASE
    WHEN m.product_name = 'sushi' OR (s.order_date BETWEEN dates.join_date AND dates.valid_date) THEN 2 * 10 * m.price
    ELSE 10 * m.price 
  END) AS points
FROM sales s
INNER JOIN dates_cte AS dates ON s.customer_id = dates.customer_id
AND s.order_date BETWEEN dates.join_date AND dates.last_date
INNER JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- BONUS QUESTIONS --

-- 11)

SELECT s.customer_id, order_date, product_name, price, 
	CASE 
	WHEN mbr.join_date <= s.order_date THEN 'Y'
      ELSE 'N'
		END AS members 
	FROM sales s
	LEFT JOIN members mbr ON mbr.customer_id = s.customer_id
	JOIN menu m on m.product_id = s.product_id
	ORDER BY customer_id;
    
    -- 12) 

WITH customers_data AS (
    SELECT sales.customer_id, sales.order_date,  menu.product_name, menu.price,
        CASE
            WHEN members.join_date <= sales.order_date THEN 'Y'
            ELSE 'N' 
        END AS member_status
    FROM sales
    LEFT JOIN members ON sales.customer_id = members.customer_id
    INNER JOIN menu ON sales.product_id = menu.product_id)
SELECT customer_id,order_date, product_name, price,member_status AS member,
    CASE
        WHEN member_status = 'N' THEN NULL
        ELSE RANK() OVER (PARTITION BY customer_id, member_status ORDER BY order_date)
    END AS ranking
FROM customers_data;