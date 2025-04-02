## Danny's Diner Case Study Solutions 🍣🍛🍜

### 1. What is the total amount each customer spent at the restaurant?

```sql
select customer_id, concat('$', sum(price)) as total_price from sales 
inner join menu 
	on sales.product_id= menu.product_id
	group by customer_id;
```
Result: 

![image](https://github.com/user-attachments/assets/9a770160-5814-4d07-912f-e45013d88049)


2. How many days has each customer visited the restaurant?
```sql
select customer_id, count(distinct order_date) as number_of_visits
	from sales
	group by customer_id;
```
Result: 

![image](https://github.com/user-attachments/assets/70d02f3a-3901-459f-8eb6-a838184acd40)


3. What was the first item from the menu purchased by each customer?
```sql
with first_item_cte as
	(select customer_id, order_date, product_name,
		RANK() OVER (PARTITION BY customer_id ORDER BY order_date asc) as rank_number from sales
inner join menu on sales.product_id= menu.product_id)

select customer_id, product_name, order_date
from first_item_cte 
where rank_number = 1
group by customer_id, product_name;
 ```
Result: 

![image](https://github.com/user-attachments/assets/3e8fbff4-2318-4e77-b286-2825d91cd35c)

- For Customer A, sushi and curry were ordered on the same day. There are no time stamps to tell which was ordered first.
- For Customer B, the first item ordered was curry
- For Customer C, it was ramen.
  

4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
Select product_name, Count(product_id) as most_purchased
from sales_menu
group by product_id, product_name
order by most_purchased desc
limit 1; 
```
Result: Ramen was the most purchased item on the menu

![image](https://github.com/user-attachments/assets/329c572c-067b-4b3a-a40a-7e977990d8e3)


5. Which item was the most popular for each customer?
```sql
With most_pop as 
(select customer_id, product_name, count(product_name) as ordercount,
	rank () over (partition by customer_id order by count(product_name) desc) as prodrank
from sales
inner join menu on sales.product_id=menu.product_id
group by customer_id, product_name
)
select customer_id, product_name, ordercount
FROM most_pop
where prodrank=1;
```
Result:

![image](https://github.com/user-attachments/assets/4a6c31e7-2165-4e02-825d-051995e8a8e8)

-  the most popular items for Cusomer A and C were ramen but customer B liked and ordered all 3 dishes equally. 

6. Which item was purchased first by the customer after they became a member?
```sql
With first_purchase as 
	(select product_name, s.customer_id, order_date, join_date,
    rank () over (partition by s.customer_id order by order_date) as rank_number
from sales as s
join members as mem on s.customer_id=mem.customer_id
join menu as m on m.product_id=s.product_id
where order_date >= join_date
)
select customer_id, product_name, order_date
from first_purchase
where order1 =1;
```
7.  Which item was purchased just before the customer became a member?
```sql
With purchase_before as 
	(select product_name, s.customer_id, order_date, join_date,
    rank () over (partition by customer_id order by order_date desc) as rank_number
from sales_menu as s
join members as mem on s.customer_id=mem.customer_id
where order_date < join_date
)
select customer_id, product_name, order_date, rank_number
from purchase_before
where rank_number =1;
```
8. What is the total items and amount spent for each member before they became a member?
```sql
select s.customer_id, count(product_name) as tot_products, concat('$', sum(price)) as tot_price
from sales as s
join members as mem on s.customer_id=mem.customer_id
join menu as m on m.product_id=s.product_id
where order_date < join_date
group by s.customer_id
order by s.customer_id;
```
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
```sql
with newpoints as 
	(select customer_id, product_name, price, 
	case when product_name = 'sushi' then price*20
		else price*10
	end as points 
from sales_menu
)
select customer_id, sum(points)
from newpoints
group by customer_id;
```
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
```sql 
select s.customer_id, sum(if (order_date between join_date and
		date_add(join_date, interval 6 day), price*20, 
        if(product_name = 'sushi', price*20, price*10))) as points
from sales as s
inner join menu as m on s.product_id=m.product_id
inner join members as mem on s.customer_id=mem.customer_id
where order_date <='2021-01-31'
  AND order_date >=join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
```
Bonus Question 1. Recreate the table
```sql
select s.customer_id, order_date, product_name, price, 
		if (order_date >= join_date, 'Y', 'N') as member
from members as mem
right join sales as s on s.customer_id=mem.customer_id
inner join menu as m on s.product_id=m.product_id;
```
Bonus Question 2. Rank the members as 123 and non-members as NULL
```sql
with newtable as
	(select s.customer_id, order_date, product_name, price, 
		if (order_date >= join_date, 'Y', 'N') as member
from members as mem
right join sales as s on s.customer_id=mem.customer_id
inner join menu as m on s.product_id=m.product_id)

select *, if (member = 'N', 'NULL', DENSE_RANK() OVER (PARTITION BY customer_id, member
				ORDER BY order_date)) AS ranking
from newtable;
```
