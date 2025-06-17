## 🍕PR B - Runner and Customer Experience - Solutions & Outputs

### 🍕Questions 

<details>

<summary>Please click on the questions in the toggle to go straight to the related solution and output </summary>

1. [How many runners signed up for each 1 week period? (i.e. week starts `2021-01-01`)](#1-how-many-runners-signed-up-for-each-1-week-period
2. [What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?]
3. [Is there any relationship between the number of pizzas and how long the order takes to prepare?]
4. [What was the average distance travelled for each customer?]
5. [What was the difference between the longest and shortest delivery times for all orders?]
6. [What was the average speed for each runner for each delivery and do you notice any trend for these values?]
7. [What is the successful delivery percentage for each runner?]

</details>

### Solutions 

#### 1. How many runners signed up for each 1 week period? (i.e. week starts `2021-01-01`)
```sql
with signup_per_wk as(
	select runner_id, registration_date, 
		registration_date-((registration_date - DATE('2021-01-01')) % 7) as onewk
from runners)
select onewk, count(runner_id) as numberofrunners
from signup_per_wk
group by onewk;
```
Result: 

![image](https://github.com/user-attachments/assets/ed20c206-8183-4342-8414-5b68b920bd18)

- Two runners registered in the first week, followed by one runner in the second week and another in the third week.
  
#### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?
-- Here, we need to find the difference between order time and pickup time

```sql
with arrival_time as 
(select runner_id, timestampdiff(minute, ordertime, pickup_time) as arrive_minutes
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
where pickup_time is not null)

select runner_id, avg(arrive_minutes) from arrival_time 
group by runner_id;

```
Result: 

![image](https://github.com/user-attachments/assets/75b57e93-354b-42ac-bd9e-60a8fb950726)

- Runner 1 took an average of 15.33 minutes to arrive at Runner HQ for pickup, while Runner 2 averaged 23.4 minutes and Runner 3 averaged 10 minutes.

#### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
```sql
with relationship as 
(select c.order_id, count(c.order_id) as numberofpizzas, timestampdiff(minute, ordertime, pickup_time) as order_minutes
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
where pickup_time is not null
group by c.order_id, order_minutes)

select numberofpizzas, avg(order_minutes)
from relationship
group by numberofpizzas;

```
Result:

![image](https://github.com/user-attachments/assets/ec449ec3-fcfd-4481-bdd6-f9681182208c)

- The image illustrates that as the number of pizzas increases, the preparation time also rises.

#### 4. What was the average distance travelled for each customer?

```sql
select runner_id, round(avg(distance),2)
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
group by runner_id;

select customer_id, round(avg(distance),2)
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
group by customer_id;
```

Result: 

![image](https://github.com/user-attachments/assets/4ea1c259-2c5d-4b18-ad05-9125f7f33763)

- The average distance covered was 20 km for Customer 101, 16.73 km for Customer 102, 23.4 km for Customer 103, 10 km for Customer 104, and 25 km for Customer 105.
  
#### 5. What was the difference between the longest and shortest delivery times for all orders?
```sql
select max(duration), min(duration), max(duration) - min(duration) as difference from temp_runner_orders;
```
Result: 

![image](https://github.com/user-attachments/assets/360ed4d9-b60a-48c0-ab13-c9c852e0abcb)

- The difference between the longest and shortest delivery was 30 minutes
  
#### 6. What was the average speed for each runner for each delivery, and do you notice any trend for these values?

```sql
with average_speed as 
(select c.order_id, runner_id, round(avg(distance/duration * 60),2) as avg_speed
from temp_customer_orders as c 
inner join temp_runner_orders as r on c.order_id=r.order_id
where duration is not null 
group by runner_id, order_id) 

select runner_id, round(avg(avg_speed),2)
from average_speed
group by runner_id; 
```
Result: 

![image](https://github.com/user-attachments/assets/045cf2c0-c968-4b0c-a6de-ff2158337b6f)

- Runner 1 had an average speed of 45.54 km/h, Runner 2 averaged 62.9 km/h, and Runner 3 averaged 40 km/h. Despite having the highest speed, Runner 2 takes longer to deliver, indicating they may be an outlier and should be investigated further to understand the cause.
 
#### 7. What is the successful delivery percentage for each runner?
```sql
with delivery as 
(select runner_id, cancellation, 
	case when cancellation is null then 1 else 0 end as success_delivered
from temp_runner_orders)
select runner_id, round(sum(success_delivered)*100/count(*),2) as percent_delivered
from delivery
group by runner_id;
```

Result: 

![image](https://github.com/user-attachments/assets/f82cfa6d-83cd-4e36-8acd-92c1d8bfb5e4)

- Runner 1 achieved a 100% delivery rate, while Runner 2 and Runner 3 recorded 75% and 50%, respectively.
