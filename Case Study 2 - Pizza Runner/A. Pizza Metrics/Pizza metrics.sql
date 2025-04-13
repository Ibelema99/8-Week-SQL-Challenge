/*A. Pizza Metrics
1. How many pizzas were ordered?*/
select count(pizza_id) as numberofpizzas
from temp_customer_orders;

-- 2. How many unique customer orders were made?
select count(distinct order_id) as numberoforders
from temp_customer_orders;

-- 3. How many successful orders were delivered by each runner?
select runner_id, count(distinct order_id) as orders_delivered
from temp_runner_orders
where cancellation is null
group by runner_id;

-- 4. How many of each type of pizza was delivered?
-- Remember 2 were cancelled, so we need to join temp_runner_orders
-- to get the actual names, we will join temp_customer_orders with pizza_names
select c.pizza_id, pizza_name, count(c.pizza_id) as number_of_pizzas from temp_customer_orders as c
inner join pizza_names as p on c.pizza_id=p.pizza_id
inner join temp_runner_orders as r on c.order_id=r.order_id
where distance is not null
group by pizza_id, pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id, pizza_name, count(c.pizza_id) from temp_customer_orders as c
inner join pizza_names as p on c.pizza_id=p.pizza_id
group by customer_id, c.pizza_id, pizza_name
order by customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order? 
with pizza_orders as 
(select c.order_id, count(c.pizza_id) as pizza_delivered from temp_customer_orders as c
join temp_runner_orders as r on c.order_id=r.order_id
where distance is not null
group by order_id)
select max(pizza_delivered) from pizza_orders; 

/*7. For each customer, how many delivered pizzas had at least 1 change and how many had 
no changes?*/
select c.customer_id, 
sum(case when c.exclusions is not null OR c.extras is not null then 1 else 0 end) as atleast1change,
sum(case when c.exclusions is null and c.extras is null then 1 else 0 end) as no_changes
from temp_customer_orders as c
join temp_runner_orders as r on c.order_id=r.order_id
where distance is not null
group by customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
select
sum(case when c.exclusions is not null and c.extras is not null then 1 else 0 end) as both_exs
from temp_customer_orders as c
join temp_runner_orders as r on c.order_id=r.order_id
where distance is not null;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
select hour (ordertime) as hour_of_day, count(order_id) as pizza_volume
from temp_customer_orders
group by hour_of_day
order by hour_of_day;

-- 10. What was the volume of orders for each day of the week?
select dayname (ordertime) as day_of_week, count(order_id) as pizza_volume
from temp_customer_orders
group by day_of_week;
