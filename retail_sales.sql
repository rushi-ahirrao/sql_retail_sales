--SQL Retail Sale Analysis--

--create table 
CREATE TABLE retail_sales_t(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
);

select * from retail_sales_t
limit 10;

--count total rows--
select count(*) from retail_sales_t;

--Data cleaning--- 
select * from retail_sales_t
where transactions_id is null
   or sale_date is null
   or sale_time is null
   or customer_id is null
   or gender is null
   or age is null
   or category is null
   or quantiy is null
   or cogs is null
   or total_sale is null;

--

delete from retail_sales_t
where transactions_id is null
   or sale_date is null
   or sale_time is null
   or customer_id is null
   or gender is null
   or age is null
   or category is null
   or quantiy is null
   or cogs is null
   or total_sale is null;


--Data exploration--

--how many sales we have??
select count (*) as total_sales from retail_sales_t;

--how many unique customers we have??
select count(distinct customer_id) as total_customers from retail_sales_t;

--which category we have??
select distinct category as total_category from retail_sales_t;


--Data analysis && bussiness problems

--1. SQL query to retrive all cloumns for sales made on '2022-11-05'

select * 
from retail_sales_t
where sale_date = '2022-11-05';

--2. write SQL query to calculate the total sales for each category.

SELECT 
	category,
	sum(total_sale) as net_sale
FROM retail_sales_t
GROUP BY 1;

--3. write a sql query to find the avreage age of the customesrs who purchesed items from the 'beauty' category.
SELECT  (AVG(age),2) AS avg_age
FROM retail_sales_t
WHERE category = 'Beauty'

--4. Write sql query to find all transaction where the total _sale is greater then 1000
select * from retail_sales_t
where total_sale > 1000;

--5. write a SQL query to find the total number of transaction nmade by each gender in each category.
select category,
		gender,
		count(*) as total_trans
from retail_sales_t
group by category,gender
order by 1

--6. SQL query to calculate the average sale for each month. find out best selling month in each year
select year, month, avg_sale from(
select
		extract(year from sale_date)as year,
		extract(month from sale_date)as month,
		(avg(total_sale),2) as avg_sale,
		rank() over (partition by extract(year from sale_date) ORDER BY AVG (total_sale)desc )
from retail_sales_t
group by 1,2) as t1
where rank = 1

--7. SQL query to find the top 5 customers based on the highest toatal sales
select 
		customer_id,
		sum(total_sale) as total_sales
from retail_sales_t
group by 1
order by 2 desc
limit 5;

--8. SQL query for find the number of unique customers who purchesed items from each category

select 
		category,
		count(distinct customer_id) as unique_customers
from retail_sales_t
group by category

--9. SQL query to ctrate each shift and number of orders 

with hourly_sale
as(
select *, 
	CASE
		when extract (hour from sale_time) < 12 then 'morning'
		when extract( hour from sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
from  retail_sales_t
)
select
	shift,
	count(*) as total_orders
from hourly_sale 
group by shift


--10. SQL query to retrive all transaction where the category is 'clothing'and the quantity sold is more than in the month of nov- 
select 
	*
from retail_sales_t
where category = 'Clothing'
	and 
	TO_CHAR (sale_date, 'yyyy-mm')= '2022-11'
	and 
	quantity>= 4;

--------END------------