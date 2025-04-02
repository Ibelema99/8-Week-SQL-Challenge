create schema dannys_diner;
create table sales (
	customer_id varchar(1),
    order_date date, 
    product_id int);
    
insert into sales(customer_id, order_date, product_id)
values 
	('A', '2021-01-01', 1),
	('A', '2021-01-01',	2),
	('A', '2021-01-07',	2),
    ('A', '2021-01-10',	3),
	('A', '2021-01-11',	3),
	('A', '2021-01-11', 3),
	('B', '2021-01-01', 2),
	('B', '2021-01-02',	2),
	('B', '2021-01-04',	1),
	('B', '2021-01-11', 1),
	('B', '2021-01-16',	3),
	('B', '2021-02-01',	3),
	('C', '2021-01-01',	3),
	('C', '2021-01-01',	3),
	('C', '2021-01-07',	3);

select * from sales;

create table menu (
	product_id int, 
    product_name varchar (20), 
    price int);

insert into menu(product_id, product_name, price)
values 
	(1, 'sushi', 10),
	(2, 'curry', 15),
    (3, 'ramen', 12);
    
    
select * from menu;

create table members(
customer_id varchar(1), 
join_date date);

insert into members(customer_id, join_date)
values 
	('A', '2021-01-07'),
	('B', '2021-01-09');
    
 select * from members;  
 
-- Question 1: What is the total amount each customer spent at the restaurant?
create table sales_menu 
as 
(select customer_id, order_date, sales.product_id, product_name, price from sales 
inner join menu 
	on sales.product_id= menu.product_id);
    
select * from sales_menu; 

select customer_id, sum(price) 
	from sales_menu
	group by customer_id;

-- Question 2: How many days has each customer visited the restaurant?
select * from sales_menu; 

select customer_id, count(distinct order_date)
	from sales_menu
	group by customer_id;

-- Question #3: What was the first item from the menu purchased by each customer?
select customer_id, min(order_date), product_name
	from sales_menu
	group by customer_id, product_name, order_date
    order by order_date asc, customer_id 
    limit 5;
  
/*Question 4: What is the most purchased item on the menu and how many 
	times was it purchased by all customers?*/
select * from sales_menu; 

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

-- Solution 2 with already joined table 
With most_pop as 
(select customer_id, product_name, count(product_name) as ordercount,
	rank () over (partition by customer_id order by count(product_name) desc) as prodrank
from sales_menu
group by customer_id, product_name
)
select customer_id, product_name, ordercount
FROM most_pop
where prodrank=1;

-- Question 6: Which item was purchased first by the customer after they became a member?
With first_purchase as 
	(select product_name, s.customer_id, order_date, join_date,
    rank () over (partition by customer_id order by order_date) as order1
from sales_menu as s
join members as mem on s.customer_id=mem.customer_id
where order_date >= join_date
)
select customer_id, product_name, order_date
from first_purchase
where order1 =1;

-- try doing with a 3 table join 
With first_purchase as 
	(select product_name, s.customer_id, order_date, join_date,
    rank () over (partition by s.customer_id order by order_date) as order1
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
    rank () over (partition by customer_id order by order_date desc) as order1
from sales_menu as s
join members as mem on s.customer_id=mem.customer_id
where order_date < join_date
)
select customer_id, product_name, order_date, order1
from purchase_before
where order1 =1;

/*Question 8: What is the total items and amount spent for each member before 
	they became a member?*/
select s.customer_id, count(product_name) as tot_products, concat('$', sum(price)) as tot_price
from sales as s
join members as mem on s.customer_id=mem.customer_id
join menu as m on m.product_id=s.product_id
where order_date < join_date
group by s.customer_id
order by s.customer_id;

/*Question 9: If each $1 spent equates to 10 points and sushi has a 2x points 
	multiplier - how many points would each customer have?*/
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

/*Question 10: In the first week after a customer joins the program (including their 
	join date) they earn 2x points on all items, not just sushi - how many points do 
    customer A and B have at the end of January?*/
-- Find 1 week after joining. 
-- Determine the customer points for each transaction and for members with a membership
-- First week- all price x 20 
-- 2nd wk and above - sushi *20 others x 10
 
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

-- Bonus Question: recreate the table
select s.customer_id, order_date, product_name, price, if (order_date >= join_date, 'Y', 'N') as member
from members as mem
right join sales as s on s.customer_id=mem.customer_id
inner join menu as m on s.product_id=m.product_id;

-- rank the members as 123 and non-members as NULL
with newtable as
	(select s.customer_id, order_date, product_name, price, 
		if (order_date >= join_date, 'Y', 'N') as member
from members as mem
right join sales as s on s.customer_id=mem.customer_id
inner join menu as m on s.product_id=m.product_id)

select *, if (member = 'N', 'NULL', DENSE_RANK() OVER (PARTITION BY customer_id, member
				ORDER BY order_date)) AS ranking
from newtable;
