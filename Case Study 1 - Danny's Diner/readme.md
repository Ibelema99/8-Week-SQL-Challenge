## Case Study 1 - Danny's Diner :sushi::curry::ramen:
All information about this case study can be found [here](https://8weeksqlchallenge.com/case-study-1/)

<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" width=30% height=30%>


Please follow the links below if you want to jump straight to my solutions.
1. [Danny's Diner Solution SQL File](https://github.com/Ibelema99/8-Week-SQL-Challenge/blob/ef45a7106ce4596b3e3f42f063cb319d0519518b/Case%20Study%201%20-%20Danny's%20Diner/Danny's%20Diner.sql)
2. [Data Schema and Data cleaning](https://github.com/Ibelema99/8-Week-SQL-Challenge/blob/ef8ce4575278ff9c9c28513835fbe8151219d273/Case%20Study%201%20-%20Danny's%20Diner/Danny's%20Diner%20Schema.sql)
3. Danny's Diner Solutions with answers 

## Table of Contents
- [Introduction](#introduction)
- [Problem Statement](#problem-statement)
- [Datasets Used](#datasets-used)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Case Study Questions](#case-study-questions)
  - [Bonus Questions](#bonus-questions)


## Introduction
Danny has a deep passion for Japanese cuisine, so at the start of 2021, he took a bold step and opened a charming little restaurant specializing in his three favorite dishes: sushi, curry, and ramen. While the restaurant has gathered some basic data from its first few months of operation, he isn’t sure how to leverage it to improve and sustain the business.

## Problem Statement
Danny wants to analyze the data to answer key questions about his customers, particularly their visit patterns, spending habits, and favorite menu items. By gaining these insights, he hopes to build a stronger connection with his customers and provide a more personalized dining experience for his loyal patrons.

He plans to use these findings to determine whether to expand the existing customer loyalty program. Additionally, he needs assistance in generating basic datasets so his team can easily explore the data without relying on SQL. Due to privacy concerns, Danny has provided a sample of his overall customer data. 

## Datasets Used
For this case study, Danny has shared three key datasets: 
1. sales: The sales table captures all `customer_id` level purchases with corresponding `order_date` and `product_id` information for when and what menu items were ordered.
2. menu: The menu table maps the `product_id` to the actual `product_name` and `price` of each menu item.
3. members: The members table captures the `join_date` when a `customer_id` joined the beta version of Danny’s Diner loyalty program.

## Entity Relationship Diagram
<img src="https://github.com/user-attachments/assets/c52f7157-0da2-4275-b304-404626dfaa8b" width=40% height=50%>

## Case Study Questions
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
    
### Bonus Questions: 
1. Recreate the following table output using the available data:
   
    <img src="https://github.com/user-attachments/assets/87af2576-0d11-4f1c-a856-4f9689481069" width=30% height=20%>
    
2. Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
Example below:

    <img src="https://github.com/user-attachments/assets/6287c01f-4a72-4369-9d53-087ac34a9d57" width=30% height=20%>

