## 🍕Case Study 2 - Pizza Runner
All information about this case study can be found [here](https://8weeksqlchallenge.com/case-study-1/)

<img src="https://github.com/user-attachments/assets/1632c4d0-4cc9-402b-85a5-57e9c3983705" width=40% height=40%>


Please follow the links below if you want to jump straight to my solutions.
1. [Pizza Runner Solution SQL File](https://github.com/Ibelema99/8-Week-SQL-Challenge/blob/ef45a7106ce4596b3e3f42f063cb319d0519518b/Case%20Study%201%20-%20Danny's%20Diner/Danny's%20Diner.sql)
2. [Data Schema and Data cleaning](https://github.com/Ibelema99/8-Week-SQL-Challenge/blob/ef8ce4575278ff9c9c28513835fbe8151219d273/Case%20Study%201%20-%20Danny's%20Diner/Danny's%20Diner%20Schema.sql)
3. [Pizza Runner Solutions with answers](https://github.com/Ibelema99/8-Week-SQL-Challenge/blob/dfd6dee34cc3231d73cd73256fccf67167b0491b/Case%20Study%201%20-%20Danny's%20Diner/Danny's%20Diner%20Solutions%20%26%20Output.md) 

## Table of Contents
- [Introduction](#introduction)
- [Datasets Used](#datasets-used)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Case Study Questions](#case-study-questions)
  - [Bonus Questions](#bonus-questions)


## Introduction
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…) 

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.


## Datasets Used
For this case study, Danny has shared six key datasets: 
1. runners: The `runners` table shows the `registration_date` for each new runner
2. customer_orders: Customer pizza orders are captured in the `customer_orders` table with 1 row for each individual pizza that is part of the order.
   - The `pizza_id` relates to the type of pizza which was ordered, whilst the `exclusions` are the `ingredient_id` values which should be removed from the pizza, and the `extras` are the `ingredient_id` values which need to be added to the pizza.
   - Note that customers can order multiple pizzas in a single order with varying `exclusions` and `extras` values, even if the pizza is the same type!
   - The exclusions and extras columns will need to be cleaned up before using them in your queries (please click [here]() to see how the cleaning was done)
3. runner_orders: After each orders are received through the system - they are assigned to a runner; however, not all orders are fully completed and can be cancelled by the restaurant or the customer.
   - The `pickup_time` is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The `distance` and `duration` fields are related to how far and long the runner had to travel to deliver the order to the respective customer.
   - There are some known data issues with this table, so click [here]() to see the cleaning.
4. pizza_names: At the moment, Pizza Runner only has 2 pizzas available - the Meat Lovers or the Vegetarian!
   - This table contains `pizza_id` and `pizza_names`
5. pizza_recipes: Each `pizza_id` has a standard set of `toppings` which are used as part of the pizza recipe.
6. pizza_toppings: this table contains all of the `topping_name` values with their corresponding `topping_id` value

## Entity Relationship Diagram

<img src="https://github.com/user-attachments/assets/97a98637-bbe4-4f26-8dd4-ebce50704bd0">

## Case Study Questions

This case study has LOTS of questions - they are broken up by area of focus including:

1. Pizza Metrics
2. Runner and Customer Experience
3. Ingredient Optimisation
4. Pricing and Ratings
5. Bonus DML Challenges (DML = Data Manipulation Language)

Click on the areas above to go to the related solutions and outputs. 
Enjoy!

