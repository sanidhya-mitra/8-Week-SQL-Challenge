# Case Study #1 - Danny's Diner👨🏻‍🍳

![Coding](https://github.com/Mariyajoseph24/8_Week_SQL_challenge/assets/91487663/c69d49a0-ffd6-4cf1-b66f-1d1eb14f8549)

# Contents:
<ul>
  <li><a href="#introduction">Introduction</a></li>
  <li><a href="#problemstatement">Problem Statement</a></li>
  <li><a href="#entityrelationshipdiagram">Entity Relationship Diagram</a></li>
  <li><a href="#casestudyquestionsandsolutions">Case Study Questions & Solutions</a></li>
  <li><a href="#bonusquestionsandsolutions">Bonus Questions & Solutions</a></li>
  <li><a href="#keyinsights">Key Insights</a></li>
</ul>


<h1><a name="introduction">Introduction:</a></h1>
<p> Danny pursues his passion for Japanese cuisine by opening "Danny's Diner," a delightful restaurant that serves sushi, curry, and ramen in early 2021. However, due to a lack of data analysis experience, the restaurant fails to make informed business decisions using the minimal data obtained during its first few months. Danny's Diner wants help using this data successfully to keep the restaurant growing.</p>

<h1><a name="problemstatement">Problem Statement:</a></h1>
<p>Danny intends to use consumer data to obtain useful insights about their visit patterns, purchasing habits, and preferred menu options. By developing a stronger relationship with his consumers, he can create a more personalized experience for his loyal customers.

He intends to use this information to make more informed judgments about expanding the current customer loyalty program. Danny also requests assistance creating simple datasets so that his staff can easily inspect the data without SQL experience.

Due to privacy concerns, he has provided a sample of his whole customer data, hoping that it will be sufficient for you to develop completely working SQL queries to answer his inquiries.

The case study revolves around three key datasets:
- Sales
- Menu
- Members</p>


<h1><a name="entityrelationshipdiagram">Entity Relationship Diagram:</a></h1>
<img width="500" alt="Coding" src="https://github.com/Mariyajoseph24/8_Week_SQL_challenge/assets/91487663/4bc1a02f-6fac-47f5-82c7-d9be65de1700">


<h1><a name="casestudyquestionsandsolutions">Case Study Questions & Solutions:</a></h1>

<ol>

<li><h5>What is the total amount each customer spent at the restaurant?</li></h5>
  
```sql
SELECT S.customer_id, SUM(M.price) AS total_amnt
FROM sales S
JOIN menu M ON S.product_id = M.product_id
GROUP BY S.customer_id
ORDER BY customer_id
```
<h6>Answer:</h6>
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_1.png">

<li><h5></h5>How many days has each customer visited the restaurant?</li></h5>
<br>

```sql
SELECT customer_id, COUNT(DISTINCT order_date) AS 'No. of Days' FROM sales
GROUP BY customer_id;
```
<h6>Answer: </h6>
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_2.png">

<li><h5>What was the first item from the menu purchased by each customer?</li></h5>
  
```sql
WITH CTE AS (
    SELECT s.customer_id, 
           DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank_num, 
           m.product_name
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
)
SELECT customer_id, product_name
FROM CTE
WHERE rank_num = 1;
```
<h6>Answer: </h6>
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_3.png">

<li><h5>What is the most purchased item on the menu and how many times was it purchased by all customers?</h5></li>

```sql
SELECT m.product_name, COUNT(s.product_id) AS most_ordered
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY most_ordered DESC
LIMIT 1; 
```
<h6>Answer: </h6>
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_4.png">

<li><h5>Which item was the most popular for each customer?</h5></li>

```sql
SELECT * FROM (
    SELECT customer_id, 
           product_name, 
           COUNT(product_name) AS product_count,
           DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(product_name) DESC) AS rnk
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY customer_id, product_name
    ORDER BY customer_id, product_count DESC
) AS popularity
WHERE rnk = 1;
```
<h6>Answer: </h6>
<img width="300" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_5.png">

<li><h5></h5>Which item was purchased first by the customer after they became a member?</h5></li>

```sql
SELECT s.customer_id, join_date, order_date, product_name 
FROM sales s
JOIN members mbr ON mbr.customer_id = s.customer_id
JOIN menu m ON m.product_id = s.product_id
WHERE order_date > join_date
ORDER BY customer_id;
```
<h6>Answer: </h6>
<img width="300" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_6.png">

<li><h5>Which item was purchased just before the customer became a member?</h5></li>

```sql
SELECT * FROM (
    SELECT DISTINCT s.customer_id, join_date, order_date, product_name,
           DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rnk
    FROM sales s
    JOIN members mbr ON mbr.customer_id = s.customer_id
    JOIN menu m ON m.product_id = s.product_id
    WHERE order_date < join_date
    ORDER BY customer_id
) AS first_order
WHERE rnk = 1;
```
<h6>Answer: </h6>
<img width="300" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_7.png">

<li><h5>What is the total items and amount spent for each member before they became a member?</h5></li>

```sql
SELECT s.customer_id, 
       COUNT(m.product_name) AS total_products,
       SUM(price) AS total_price
FROM sales s
JOIN members mbr ON mbr.customer_id = s.customer_id
JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date < mbr.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
```
<h6>Answer: </h6>
<img width="300" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_8.png">

<li><h5>If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?</h5></li>

```sql
SELECT customer_id, 
       SUM(points) AS total_points 
FROM (
    SELECT s.customer_id, 
           product_name, 
           price AS total_price,
           CASE 
               WHEN product_name = 'sushi' THEN price * 20
               ELSE price * 10
           END AS points
    FROM sales s
    JOIN menu m ON m.product_id = s.product_id
) AS total_points
GROUP BY customer_id
ORDER BY customer_id;
```
<h6>Answer: </h6>
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_9.png">

<li><h5>In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customers A and B have at the end of January?</h5></li>

```sql
WITH dates_cte AS (
    SELECT customer_id, 
           join_date, 
           DATE_ADD(join_date, INTERVAL 6 DAY) AS valid_date,
           LAST_DAY(join_date) AS last_date
    FROM members
)

SELECT s.customer_id, 
       SUM(
           CASE
               WHEN m.product_name = 'sushi' OR (s.order_date BETWEEN dates.join_date AND dates.valid_date) THEN 2 * 10 * m.price
               ELSE 10 * m.price 
           END
       ) AS points
FROM sales s
INNER JOIN dates_cte AS dates ON s.customer_id = dates.customer_id
AND s.order_date BETWEEN dates.join_date AND dates.last_date
INNER JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
```
<h6>Answer: </h6>
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_10.png">

</ol>

<h1><a name="bonusquestionsandsolutions">Bonus Questions & Solutions:</a></h1>

<ol>
<li><h5>Join All The Things</li></h5>

```sql
SELECT s.customer_id, order_date, product_name, price, 
	CASE 
	WHEN mbr.join_date <= s.order_date THEN 'Y'
      ELSE 'N'
		END AS members 
	FROM sales s
	LEFT JOIN members mbr ON mbr.customer_id = s.customer_id
	JOIN menu m on m.product_id = s.product_id
	ORDER BY customer_id;
```

<h6>Answer:</h6>
<img width="400" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_11.png">


<li><h5>Rank All The Things</li></h5>
<p>Danny needs additional information about the ranking of customer products. However, he specifically requires null ranking values for non-member purchases, as he is not interested in ranking customers who are not yet part of the loyalty program.</p>

```sql
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
```

<h6>Answer:</h6>
<img width="400" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_12.png">

</ol>

  <h1><a name="keyinsights">Key Insights:</a></h1>

- **Customer Spending:** The amount spent by each customer at Danny's Diner fluctuates greatly. Some customers paid substantially more than others, indicating that they may be high-value customers or loyal clients.

- **Customer Visits:** The number of days each client spends at the restaurant varies, indicating varied patterns of consumer engagement. Some consumers visit frequently, while others may visit infrequently.

- **First Purchases:** Understanding each customer's first purchases might help Danny identify popular entrance goods and potentially attract new customers.

- **Most Popular Item:** Danny can gain significant information from the menu's most popular item. He can utilize this knowledge to improve inventory management and take advantage of the item's popularity.

- **Personalized Recommendations:** Knowing which items are most popular with each customer allows Danny to give personalized menu choices, boosting his customers' eating experiences.

- **Customer Loyalty:** Danny uses the data on purchases made before and after joining the loyalty program to assess the loyalty program's effectiveness and impact on consumer behavior.

- **Bonus Points for New Members:** Danny incentivizes increased spending by giving new members 2x points within their first week, pushing them to participate more actively in the program.

- **Member Points:** The points gained by each member can be used to determine their loyalty and potentially give targeted rewards and promotions.

- **Data Visualization:** Creating data and insight-based visuals can help Danny better identify patterns and make data-driven decisions.

- **Customer Segmentation:** Danny is able to segment his clientele and adjust his marketing tactics by examining their purchasing patterns.

- **Expanding Membership:** Danny may leverage the program's success by using the data's insights to improve his loyalty program and draw in new participants.

- **Inventory Management:** Danny can maximize income, minimize waste, and manage his inventory by understanding which things are the most and least popular.

- **Menu Optimization:** Using the data, Danny may assess how well-performing menu items are doing and think about launching new meals that cater to specific consumer tastes.

- **Customer Engagement:** Danny may learn more about what attracts repeat business and improve client experiences by analyzing consumer behavior.

- **Long-Term Growth:** Danny may use data analysis to make informed decisions that will help Danny's Diner expand and succeed in the long run.
