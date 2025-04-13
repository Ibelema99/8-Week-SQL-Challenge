## 🍕PR A - Pizza Metrics Solutions & Outputs

### 🍕Questions 

<details>

<summary>Please click on the questions in the toggle to go straight to the related solution and output </summary>

1. [How many pizzas were ordered?](#1-how-many-pizzas-were-ordered")
2. [How many unique customer orders were made?](#2-how-many-unique-customer-orders-were-made")
3. [How many successful orders were delivered by each runner?](#3-how-many-successful-orders-were-delivered-by-each-runner")
4. [How many of each type of pizza was delivered?](#4-how-many-of-each-type-of-pizza-was-delivered")
5. [How many Vegetarian and Meatlovers were ordered by each customer?]("#5-how-many-vegetarian-and-meatlovers-were-ordered-by-each-customer")
6. [What was the maximum number of pizzas delivered in a single order?]("#6-what-was-the-maximum-number-of-pizzas-delivered-in-a-single-order")
7. [For each customer, how many delivered pizzas had at least 1 change and how many had no changes?]("#7-for-each-customer-how-many-delivered-pizzas-had-at-least-1-change-and-how-many-had-no-changes")
8. [How many pizzas were delivered that had both exclusions and extras?]("#8-how-many-pizzas-were-delivered-that-had-both-exclusions-and-extras")
9. [What was the total volume of pizzas ordered for each hour of the day?]("#9-what-was-the-total-volume-of-pizzas-ordered-for-each-hour-of-the-day")
10. [What was the volume of orders for each day of the week?](#10-what-was-the-volume-of-orders-for-each-day-of-the-week")

</details>

### Solutions 

#### 1. How many pizzas were ordered?
```sql
select count(pizza_id) as numberofpizzas
from temp_customer_orders;
```
Result: 

![image](https://github.com/user-attachments/assets/a7abbe0c-96bf-4505-ae84-b42b2ab6a9a7)

- A total of 14 pizzas were ordered.
  
#### 2. How many unique customer orders were made?
```sql
select count(distinct order_id) as numberoforders
from temp_customer_orders;
```
Result: 

![image](https://github.com/user-attachments/assets/f2490f33-13cf-49ac-ac84-3a0455369f5e)
- 10 unique customer orders were made 

#### 3. How many successful orders were delivered by each runner?
```sql
select runner_id, count(distinct order_id) as orders_delivered
from temp_runner_orders
where cancellation is null
group by runner_id;
```
Result:

![image](https://github.com/user-attachments/assets/30a7be8a-a7cc-47f2-9613-4a071580bbc3)

- Runner 1 delivered 4 orders
- Runner 2 delivered 3 orders
- Runner 3 delivered 1 order

#### 4. How many of each type of pizza was delivered?
- For this question, we will join the `temp_runner_orders` and `pizza_names` tables with the `temp_customer_orders` table to account for cancelled orders and show the pizza name in the output.

```sql
select c.pizza_id, pizza_name, count(c.pizza_id) as number_of_pizzas from temp_customer_orders as c
inner join pizza_names as p on c.pizza_id=p.pizza_id
inner join temp_runner_orders as r on c.order_id=r.order_id
where distance is not null
group by pizza_id, pizza_name;
```

Result: 

![image](https://github.com/user-attachments/assets/8aa56343-ac78-49df-9118-7ad267280a23)

- 9 Meatlovers and 3 Vegetarian pizzas were ordered.
  
#### 5. How many Vegetarian and Meatlovers were ordered by each customer?
```sql
select customer_id, pizza_name, count(c.pizza_id) from temp_customer_orders as c
inner join pizza_names as p on c.pizza_id=p.pizza_id
group by customer_id, c.pizza_id, pizza_name
order by customer_id;
```
Result: 

![image](https://github.com/user-attachments/assets/8c6d6ad0-13da-4e77-8393-4b66cb52bb84)

- Customer 101 ordered 2 Meatlovers and 1 Vegetarian pizza
- Customer 102 ordered 2 Meatlovers and 1 Vegetarian pizza
- Customer 103 ordered 3 Meatlovers and 1 Vegetarian pizza
- Customer 104 ordered 3 Meatlovers
- Customer 105 ordered 1 Vegetarian pizza
  
#### 6. What was the maximum number of pizzas delivered in a single order?
```sql
with pizza_orders as 
(select c.order_id, count(c.pizza_id) as pizza_delivered from temp_customer_orders as c
join temp_runner_orders as r on c.order_id=r.order_id
where distance is not null
group by order_id)
select max(pizza_delivered) from pizza_orders; 
```
Result: 

![image](https://github.com/user-attachments/assets/ccf9b3ec-8ccd-4d05-bcc7-1e653507319a)

- The maximunm nuber of pizzas delivered in a single order is 3
  
#### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```sql
select c.customer_id, 
sum(case when c.exclusions is not null OR c.extras is not null then 1 else 0 end) as atleast1change,
sum(case when c.exclusions is null and c.extras is null then 1 else 0 end) as no_changes
from temp_customer_orders as c
join temp_runner_orders as r on c.order_id=r.order_id
where distance is not null
group by customer_id;
```

Result: 

![image](https://github.com/user-attachments/assets/1db9f539-2f79-4c34-a2de-0e4f85164cda)

- Customers 101 and 102 made no changes to their orders
- Customers 103 and 105 had at least 1 change in every order
- Customer 104 made 2 orders with at least 1 change and 1 order with no changes
  
#### 8. How many pizzas were delivered that had both exclusions and extras?
```sql
select
sum(case when c.exclusions is not null and c.extras is not null then 1 else 0 end) as both_exs
from temp_customer_orders as c
join temp_runner_orders as r on c.order_id=r.order_id
where distance is not null;
```
Result: 

![image](https://github.com/user-attachments/assets/4b19bc93-9a5c-4032-b49c-71338ff30eb6)

- Only 1 delivered pizza had both extras and exclusions

#### 9. What was the total volume of pizzas ordered for each hour of the day?
```sql
select hour (ordertime) as hour_of_day, count(order_id) as pizza_volume
from temp_customer_orders
group by hour_of_day
order by hour_of_day;
```
Result: 

![image](https://github.com/user-attachments/assets/d537da95-01af-4c5e-a5ef-8a8b7939d0d4)

- The total volume of pizzas ordered at 11 a.m. and 7 p.m. was 1. These were the hours with the least orders. 
- The total volume of pizzas ordered at 1 p.m., 6 p.m., 9 p.m. and 11 p.m. was 3. These were the hours with the highest volume of orders. 

#### 10. What was the volume of orders for each day of the week?
```sql
select dayname (ordertime) as day_of_week, count(order_id) as pizza_volume
from temp_customer_orders
group by day_of_week;
```
Result: 

![image](https://github.com/user-attachments/assets/f2b0e39e-81df-462b-ba84-56b8b4fe4317)

- The volume of orders for Wednesday and Saturday is 5, Thursday is 3 and Friday is 1
  
