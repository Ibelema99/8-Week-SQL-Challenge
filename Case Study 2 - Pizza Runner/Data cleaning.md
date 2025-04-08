## Pizza Runner Data Cleaning 🍕

### Cleaning the customer_orders table 

#### Step 1: Change all empty and null values to NULL

```sql
create table temp_customer_orders as select order_id, customer_id, pizza_id,
  case when exclusions = '' or exclusions like 'null' then null else exclusions end as exclusions, 
case when extras = '' or extras like 'null' then null else extras end as extras, ordertime
from customer_orders;
```

![image](https://github.com/user-attachments/assets/d111d1d8-3e7d-4ace-bf02-a2844f978e0e)

#### Step 2: Split the comma-separated values in the extras and exclusions columns into 2

```sql
create table extras_and_exclusions as 
select order_id, customer_id, pizza_id, extras, SUBSTRING_INDEX(`extras`, ', ', 1) AS `extra1`,
	if(char_length(extras) - char_length(replace(extras, ' ', ''))=1, 
    SUBSTRING_INDEX(`extras`, ', ', -1), null) AS `extra2`, 
    
    exclusions, SUBSTRING_INDEX(`exclusions`, ', ', 1) AS `exclusion1`,
	if(char_length(exclusions) - char_length(replace(exclusions, ' ', ''))=1, 
    SUBSTRING_INDEX(`exclusions`, ', ', -1), null) AS `exclusion2`, 
    ordertime
from temp_customer_orders;
```

![image](https://github.com/user-attachments/assets/1e2d0d45-4cb9-492d-bf0f-5e81ee9bc4aa)

### Cleaning the runner orders table
#### Step 1:  
- Change 'null' to NULL
- Remove km from distance and minutes from duration
  
```sql
create table temp_runner_orders as select order_id, runner_id,
  case when pickup_time like 'null' then null else pickup_time end as pickup_time, 
  case when distance like 'null' then null
    when distance like '%km' then trim('km' from distance) else distance end as distance,
case when duration like 'null' then null 
	when duration like '%mins' then trim('mins' from duration)
  when duration like '%minute' then trim('minute' from duration)
  when duration like '%minutes' then trim('minutes' from duration) else duration end as duration,
case when cancellation like 'null' or cancellation = '' then null else cancellation end as cancellation
from runner_orders; 
``` 

![image](https://github.com/user-attachments/assets/fcbf5e29-21b7-41eb-b265-207b74174899)

#### Step 2: Change datatypes 
  - pickup_time to datetime
  - distance to float
  - duration to integer

```sql
alter table temp_runner_orders
modify column pickup_time datetime,
modify column distance float,
modify column duration int;
```
 
### Cleaning the Pizza recipes table 
#### Split the toppings column in pizza recipes
```sql
create table temp_pizza_recipes as
WITH RECURSIVE SplitValues AS (
    SELECT
        pizza_id,
        SUBSTRING_INDEX(toppings, ',', 1) AS split_toppings,
        IF(LOCATE(',', toppings) > 0, SUBSTRING(toppings, LOCATE(',', toppings) + 1), NULL) AS remaining_values
    FROM pizza_recipes
    UNION ALL
    SELECT
        pizza_id,
        SUBSTRING_INDEX(remaining_values,',', 1) AS split_toppings,
        IF(LOCATE(',', remaining_values) > 0, SUBSTRING(remaining_values, LOCATE(',',remaining_values) + 1), NULL)
    FROM
        SplitValues
    WHERE
        remaining_values IS NOT NULL
)
SELECT
    pizza_id,
    split_toppings
FROM
    SplitValues order by pizza_id;
```

![image](https://github.com/user-attachments/assets/b0cfd972-b8db-46e0-8058-1e8b7de21c96)

#### Remove all leading spaces
```sql
UPDATE temp_pizza_recipes SET split_toppings = REPLACE(split_toppings, ' ', '') 
```

![image](https://github.com/user-attachments/assets/b7fd8cfb-85f7-4bd5-8967-b675079dcf15)

