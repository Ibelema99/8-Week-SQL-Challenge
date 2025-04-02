-- Question 1: What is the total amount each customer spent at the restaurant?
select customer_id, concat('$', sum(price)) from sales 
inner join menu 
	on sales.product_id= menu.product_id
	group by customer_id;
    
-- Question 2: How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date)
	from sales
	group by customer_id;

-- Question #3: What was the first item from the menu purchased by each customer?
with first_item_cte as 
(select customer_id, order_date, product_name, 
	RANK() OVER (PARTITION BY customer_id ORDER BY order_date asc) as rank_number from sales
inner join menu on sales.product_id= menu.product_id)

select customer_id, product_name 
from first_item_cte 
where rank_number = 1
group by customer_id, product_name;
   
/*Question 4: What is the most purchased item on the menu and how many times was it purchased by all customers?*/
Select product_name, Count(product_id) as most_purchased
from sales_menu
group by product_id, product_name
order by most_purchased desc
limit 1; 

-- Question 5: Which item was the most popular for each customer?
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

-- Question 6: Which item was purchased first by the customer after they became a member?
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

-- Question 7: Which item was purchased just before the customer became a member?
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

/*Question 8: What is the total items and amount spent for each member before they became a member?*/
select s.customer_id, count(product_name) as tot_products, concat('$', sum(price)) as tot_price
from sales as s
join members as mem on s.customer_id=mem.customer_id
join menu as m on m.product_id=s.product_id
where order_date < join_date
group by s.customer_id
order by s.customer_id;

/*Question 9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each 
	customer have?*/
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

/*Question 10: In the first week after a customer joins the program (including their join date), they earn 2x points 
	on all items, not just sushi - how many points do customers A and B have at the end of January?*/ 
select s.customer_id, sum(if (order_date between join_date and date_add(join_date, interval 6 day), price*20, 
        if(product_name = 'sushi', price*20, price*10))) as points
from sales as s
inner join menu as m on s.product_id=m.product_id
inner join members as mem on s.customer_id=mem.customer_id
where order_date <='2021-01-31' AND order_date >=join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- Bonus Question 1: recreate the table
select s.customer_id, order_date, product_name, price, 
		if (order_date >= join_date, 'Y', 'N') as member
from members as mem
right join sales as s on s.customer_id=mem.customer_id
inner join menu as m on s.product_id=m.product_id;

-- Bonus Question 2: rank the members as 123 and non-members as NULL
with newtable as
	(select s.customer_id, order_date, product_name, price, if (order_date >= join_date, 'Y', 'N') as member
from members as mem
right join sales as s on s.customer_id = mem.customer_id
inner join menu as m on s.product_id = m.product_id)

select *, if (member = 'N', 'NULL', DENSE_RANK() OVER (PARTITION BY customer_id, member ORDER BY order_date)) AS ranking
from newtable;
