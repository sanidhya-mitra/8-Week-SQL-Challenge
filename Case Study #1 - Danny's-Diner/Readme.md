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
<p> Danny pursues his passion for Japanese cuisine by opening "Danny's Diner," a delightful restaurant that serves sushi, curry, and ramen in early 2021. However, due to a lack of data analysis experience, the restaurant fails to make informed business decisions using the minimal data obtained during its first few months. Danny's Diner wants help using this data to keep the restaurant growing.</p>

<h1><a name="problemstatement">Problem Statement:</a></h1>
<p>Danny intends to use consumer data to obtain useful insights about their visit patterns, purchasing habits, and preferred menu options. By developing a stronger relationship with his consumers, he can create a more personalized experience for his loyal customers.

He intends to use this information to make more informed judgments about expanding the current customer loyalty program. Danny also requests assistance creating simple datasets so his staff can easily inspect the data without SQL experience.

Due to privacy concerns, he has provided a sample of his whole customer data, hoping that it will be sufficient for us to develop completely working SQL queries to answer his inquiries.

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
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_1.png"><br>

<h6>Logic: </h6>
<ul>
  <li>The SQL query retrieves the <code>customer_id</code> and calculates the total amount spent (<code>total_amnt</code>) by each customer at the restaurant.</li>
  <li>It combines data from the <code>sales</code> and <code>menu</code> tables based on matching <code>product_id</code>.</li>
  <li>The results are grouped by <code>customer_id</code>.</li>
  <li>The query then calculates the total sum of <code>price</code> for each group of sales records with the same <code>customer_id</code>.</li>
  <li>Finally, the results are sorted in ascending order based on the <code>customer_id</code>.</li>
</ul>

<li><h5></h5>How many days has each customer visited the restaurant?</li></h5>
<br>

```sql
SELECT customer_id, COUNT(DISTINCT order_date) AS 'No. of Days' FROM sales
GROUP BY customer_id;
```
<h6>Answer: </h6>
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_2.png"><br>

<h6>Logic: </h6>
<ul>
  <li>The SQL query selects the <code>customer_id</code> and counts the number of distinct order dates (<code>No. of Days</code>) for each customer.</li>
  <li>It retrieves data from the <code>sales</code> table.</li>
  <li>The results are grouped by <code>customer_id</code>.</li>
  <li>The <code>COUNT(DISTINCT order_date)</code> function calculates the number of unique order dates for each customer.</li>
  <li>Finally, the query presents the total number of unique order dates as <code>No. of Days</code> for each customer.</li>
</ul>

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
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_3.png"><br>

<h6>Logic: </h6>
<ul>
  <li>The SQL query uses a Common Table Expression (CTE) named <code>CTE</code> to generate a temporary result set.</li>
  <li>Within the CTE, it selects the <code>customer_id</code>, assigns a dense rank to each row based on the order date for each customer, and retrieves the corresponding <code>product_name</code> from the <code>menu</code> table.</li>
  <li>The <code>sales</code> table is joined with the <code>menu</code> table on matching <code>product_id</code>.</li>
  <li>The DENSE_RANK() function assigns a rank to each row within the partition of each <code>customer_id</code> based on the <code>order_date</code> in ascending order.</li>
  <li>Each <code>customer_id</code> has its partition and separate ranks based on the order dates of their purchases.</li>
  <li>Next, the main query selects the <code>customer_id</code> and corresponding <code>product_name</code> from the CTE.</li>
  <li>It filters the results and only includes rows where the rank <code>rn</code> is equal to 1, which means the earliest purchase for each <code>customer_id</code>.</li>
  <li>As a result, the query returns the first purchased product for each customer.</li>
</ul>

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
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_4.png"><br>

<h6>Logic: </h6>
<ul>
  <li>The SQL query selects the <code>product_name</code> from the <code>menu</code> table and counts the number of times each product was ordered (<code>most_ordered</code>).</li>
  <li>It retrieves data from the <code>Sales</code> table and joins it with the <code>menu</code> table based on matching <code>product_id</code>.</li>
  <li>The results are grouped by <code>product_name</code>.</li>
  <li>The <code>COUNT(S.product_id)</code> function calculates the number of occurrences of each <code>product_id</code> in the <code>Sales</code> table.</li>
  <li>The query then presents the <code>product_name</code> and its corresponding count as <code>most_ordered</code> for each product.</li>
  <li>Next, the results are sorted in descending order based on the <code>most_ordered</code> column, so the most ordered product appears first.</li>
  <li>The <code>LIMIT 1</code> clause is used to restrict the result to only one row, effectively showing the most ordered product.</li>
</ul>

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

<h6>Logic:</h6>
<ul>
  <li>The SQL query selects the <code>customer_id</code>, <code>product_name</code>, and counts the occurrences of each product for every customer, aliased as <code>product_count</code>.</li>
  <li>It employs a window function <code>DENSE_RANK()</code> partitioned by <code>customer_id</code> to assign ranks to products based on their counts within each customer group.</li>
  <li>The query retrieves data from the <code>sales</code> table and joins it with the <code>menu</code> table based on matching <code>product_id</code>.</li>
  <li>The results are grouped by <code>customer_id</code> and <code>product_name</code>.</li>
  <li>The <code>COUNT(product_name)</code> function calculates the number of occurrences of each product for each customer.</li>
  <li>The window function <code>DENSE_RANK()</code> assigns a rank to each product based on its count within each customer group, ordered by descending count.</li>
  <li>Finally, the outer query filters the results to include only rows where the rank is 1, indicating the most ordered product for each customer.</li>
</ul>


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
<img width="300" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_6.png"><br>

<h6>Logic:</h6>
<ul>
  <li>The SQL query selects <code>customer_id</code>, <code>join_date</code>, <code>order_date</code>, and <code>product_name</code> from the <code>sales</code> table.</li>
  <li>It joins the <code>sales</code> table with the <code>members</code> table based on matching <code>customer_id</code> to retrieve the join date of each customer.</li>
  <li>It further joins the <code>sales</code> table with the <code>menu</code> table based on matching <code>product_id</code> to get the product name associated with each sale.</li>
  <li>The <code>WHERE</code> clause filters the results to include only rows where the order date is after the join date, ensuring that only orders placed after joining are included.</li>
  <li>The results are ordered by <code>customer_id</code> to organize the data in ascending order of customer IDs.</li>
</ul>

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
<img width="300" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_7.png"><br>

<h6>Logic:</h6>
<ul>
  <li>The SQL query selects distinct <code>customer_id</code>, <code>join_date</code>, <code>order_date</code>, and <code>product_name</code> from the sales table.</li>
  <li>It employs a window function <code>DENSE_RANK()</code> partitioned by <code>customer_id</code> to assign ranks to orders based on their order dates within each customer group.</li>
  <li>The query joins the <code>sales</code> table with the <code>members</code> table based on matching <code>customer_id</code> to retrieve the join date of each customer.</li>
  <li>It further joins the <code>sales</code> table with the <code>menu</code> table based on matching <code>product_id</code> to get the product name associated with each sale.</li>
  <li>The <code>WHERE</code> clause filters the results to include only rows where the order date is before the join date, indicating the first order placed by each customer after joining.</li>
  <li>The inner query results are ordered by <code>customer_id</code> to organize the data in ascending order of customer IDs.</li>
  <li>Finally, the outer query filters the results to include only rows where the rank is 1, indicating the first order placed by each customer after joining.</li>
</ul>


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
<img width="300" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_8.png"><br>

<h6>Logic:</h6>
<ul>
  <li>The SQL query selects <code>customer_id</code>, counts the number of distinct <code>product_name</code>s purchased by each customer (<code>total_products</code>), and sums the prices of all purchased products (<code>total_price</code>) from the sales table.</li>
  <li>It joins the <code>sales</code> table with the <code>members</code> table based on matching <code>customer_id</code> to retrieve the join date of each customer.</li>
  <li>Further, it joins the <code>sales</code> table with the <code>menu</code> table based on matching <code>product_id</code> to get the price associated with each product sold.</li>
  <li>The <code>WHERE</code> clause filters the results to include only rows where the order date is before the join date, indicating purchases made before the customer joined.</li>
  <li>The results are grouped by <code>customer_id</code> to calculate aggregate values for each customer.</li>
  <li>Finally, the results are ordered by <code>customer_id</code> to organize the data in ascending order of customer IDs.</li>
</ul>


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
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_9.png"><br>

<h6>Logic:</h6>
<ul>
  <li>The SQL query calculates the total points earned by each customer based on their purchases.</li>
  <li>It first selects <code>customer_id</code> and the sum of points earned (<code>total_points</code>).</li>
  <li>It employs a subquery to calculate the points earned for each purchase. Inside the subquery, it selects <code>customer_id</code>, <code>product_name</code>, <code>price</code>, and calculates the points based on the product's name:
    <ul>
      <li>If the product is 'sushi', the points are calculated by multiplying the price by 20.</li>
      <li>For all other products, the points are calculated by multiplying the price by 10.</li>
    </ul>
  </li>
  <li>The results of the subquery are then grouped by <code>customer_id</code>.</li>
  <li>Finally, the outer query calculates the sum of points for each customer by summing up the points earned from all their purchases.</li>
  <li>The results are then ordered by <code>customer_id</code> to organize the data in ascending order of customer IDs.</li>
</ul>


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
<img width="200" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_10.png"><br>

<h6>Logic:</h6>
<ul>
  <li>The SQL query calculates the total points earned by each customer based on their purchases, considering different conditions for point calculation.</li>
  <li>It first creates a common table expression (CTE) named <code>dates_cte</code> to calculate some date-related values for each customer, including their join date, a valid date 6 days after joining, and the last day of the month of joining.</li>
  <li>The main query selects <code>customer_id</code> and calculates the total points earned (<code>points</code>) for each customer.</li>
  <li>It uses a <code>CASE</code> statement to determine the points earned for each purchase, considering the following conditions:
    <ul>
      <li>If the product purchased is 'sushi' or the order date is within 6 days of joining, the points are calculated by multiplying the price by 20.</li>
      <li>For all other products or purchases made beyond the first 6 days after joining, the points are calculated by multiplying the price by 10.</li>
    </ul>
  </li>
  <li>The results are grouped by <code>customer_id</code> to calculate the total points earned by each customer.</li>
  <li>Finally, the results are ordered by <code>customer_id</code> to organize the data in ascending order of customer IDs.</li>
</ul>


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
<img width="400" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_11.png"><br>

<h6>Logic:</h6>
<ul>
  <li>The SQL query retrieves details about sales transactions, including customer ID, order date, product name, price, and a flag indicating whether the customer was a member at the time of purchase.</li>
  <li>It utilizes a <code>CASE</code> statement to determine whether the customer was a member (<code>'Y'</code>) or not (<code>'N'</code>) at the time of the purchase, based on the comparison between the customer's join date and the order date.</li>
  <li>The <code>LEFT JOIN</code> with the <code>members</code> table ensures that all sales transactions are included in the result set, even if there is no corresponding entry in the <code>members</code> table for a particular customer.</li>
  <li>It then joins the <code>sales</code> table with the <code>menu</code> table based on matching <code>product_id</code> to retrieve details about the purchased products.</li>
  <li>The results are ordered by <code>customer_id</code> to organize the data in ascending order of customer IDs.</li>
</ul>



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
<img width="400" alt="Coding" src="https://github.com/sanidhya-mitra/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's-Diner/Assets/Answer_12.png"><br>

<h6>Logic:</h6>
<ul>
  <li>The SQL query utilizes a common table expression (CTE) named <code>customers_data</code> to gather information about sales transactions, including customer ID, order date, product name, price, and a flag indicating the membership status at the time of purchase.</li>
  <li>Inside the CTE, a <code>CASE</code> statement is used to determine the membership status (<code>'Y'</code> for a member, <code>'N'</code> otherwise) based on the comparison between the customer's join date and the order date.</li>
  <li>The <code>LEFT JOIN</code> with the <code>members</code> table ensures that all sales transactions are included in the result set, even if there is no corresponding entry in the <code>members</code> table for a particular customer.</li>
  <li>The <code>INNER JOIN</code> with the <code>menu</code> table retrieves details about the purchased products based on matching <code>product_id</code>.</li>
  <li>The main query selects <code>customer_id</code>, <code>order_date</code>, <code>product_name</code>, <code>price</code>, <code>member_status</code> as <code>member</code>, and assigns a ranking to each transaction for members only using the <code>RANK()</code> window function partitioned by <code>customer_id</code> and <code>member_status</code>.</li>
  <li>For non-members, the ranking is set to <code>NULL</code>.</li>
</ul>


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
