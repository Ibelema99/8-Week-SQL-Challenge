## 🍕PR C. Ingredient Optimization - Solutions & Output

### 🍕Questions 

<details>

<summary>Please click on the questions in the toggle to go straight to the related solution and output </summary>

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the `customers_orders` table in the format of one of the following:
   - `Meat Lovers`
   - `Meat Lovers - Exclude Beef`
   - `Meat Lovers - Extra Bacon`
   - `Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers`
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the `customer_orders` table and add a `2x` in front of any relevant ingredients
  - For example: `"Meat Lovers: 2xBacon, Beef, ... , Salami"`
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

</details>

### Solutions 

#### 1. What are the standard ingredients for each pizza?
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
  
#### 2. What was the most commonly added extra?

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

#### 3. What was the most common exclusion?
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

#### 4. Generate an order item for each record in the `customers_orders` table in the format of one of the following:
   - `Meat Lovers`
   - `Meat Lovers - Exclude Beef`
   - `Meat Lovers - Extra Bacon`
   - `Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers`

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
  
#### 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the `customer_orders` table and add a `2x` in front of any relevant ingredients
  - For example: `"Meat Lovers: 2xBacon, Beef, ... , Salami"`
    
```sql
select max(duration), min(duration), max(duration) - min(duration) as difference from temp_runner_orders;
```
Result: 

![image](https://github.com/user-attachments/assets/360ed4d9-b60a-48c0-ab13-c9c852e0abcb)

- The difference between the longest and shortest delivery was 30 minutes
  
#### 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

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
 
