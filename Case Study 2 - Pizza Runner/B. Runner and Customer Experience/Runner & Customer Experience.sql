-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
with signup_per_wk as(
	select runner_id, registration_date, 
		registration_date-((registration_date - DATE('2021-01-01')) % 7) as onewk
from runners)
select onewk, count(runner_id) as numberofrunners
from signup_per_wk
group by onewk;

/*2. What was the average time in minutes it took for each runner to arrive at the Pizza 
Runner HQ to pickup the order? */
-- order time - pickup time 
with arrival_time as 
(select runner_id, timestampdiff(minute, ordertime, pickup_time) as arrive_minutes
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
where pickup_time is not null)

select runner_id, avg(arrive_minutes) from arrival_time 
group by runner_id;

/* 3. Is there any relationship between the number of pizzas and how long the order 
	takes to prepare?*/
with relationship as 
(select c.order_id, count(c.order_id) as numberofpizzas, timestampdiff(minute, ordertime, pickup_time) as order_minutes
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
where pickup_time is not null
group by c.order_id, order_minutes)

select numberofpizzas, avg(order_minutes)
from relationship
group by numberofpizzas;

-- 4. What was the average distance travelled for each customer?
select runner_id, round(avg(distance),2)
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
group by runner_id;

select customer_id, round(avg(distance),2)
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
group by customer_id;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
select max(duration), min(duration), max(duration) - min(duration) as difference from temp_runner_orders;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend
	-- for these values?
with average_speed as 
(select c.order_id, runner_id, round(avg(distance/duration * 60),2) as avg_speed
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
where duration is not null 
group by runner_id, order_id) 

select runner_id, round(avg(avg_speed),2)
from average_speed
group by runner_id;

-- 7. What is the successful delivery percentage for each runner?
with delivery as 
(select runner_id, cancellation, 
	case when cancellation is null then 1 else 0 end as success_delivered
from temp_runner_orders)
select runner_id, round(sum(success_delivered)*100/count(*),2) as percent_delivered
from delivery
group by runner_id;
