create schema dannys_diner;
create table sales (
	customer_id varchar(1),
    	order_date date, 
    	product_id int);
    
insert into sales(customer_id, order_date, product_id)
values 
	('A', '2021-01-01', '1'),
	('A', '2021-01-01', '2'),
	('A', '2021-01-07', '2'),
	('A', '2021-01-10', '3'),
	('A', '2021-01-11', '3'),
	('A', '2021-01-11', '3'),
	('B', '2021-01-01', '2'),
	('B', '2021-01-02', '2'),
	('B', '2021-01-04', '1'),
	('B', '2021-01-11', '1'),
	('B', '2021-01-16', '3'),
	('B', '2021-02-01', '3'),
	('C', '2021-01-01', '3'),
	('C', '2021-01-01', '3'),
	('C', '2021-01-07', '3');

create table menu (
	product_id int, 
    	product_name varchar (20), 
    	price int);

insert into menu(product_id, product_name, price)
values 
	('1', 'sushi', '10'),
	('2', 'curry', '15'),
	('3', 'ramen', '12');
    
create table members(
	customer_id varchar(1), 
	join_date date);

insert into members(customer_id, join_date)
values 
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

-- Data Cleaning was not necessary as there were no data type changes needed and no null values to remove 
