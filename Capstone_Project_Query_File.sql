-- The Capstone Project SQL Query file 

-- Problem Statement:
-- A small company Axon, which is a retailer selling classic cars, is facing issues in managing and analysing their sales data. 
-- To address this issue, we have decided to implement a Business Intelligence (BI) tool 
-- That will help them manage and analyse their sales data effectively. 
-- We have shortlisted Microsoft PowerBI and SQL as the BI tools for this project.

-- All these queries are to extract useful insights from sales data of Axon Retails Company
-- These queries can be cross checked with Power BI report to verify both the SQL and PowerBI results
  
-- Kindly upload the Axon_Car_Sales_database files provided in the project folder 

use classicmodels;              -- to use the database classicmodels containing data tables

-- to get the sales insights from the database we will check the tables associated with sales data from schemas

select * from orderdetails;
select * from products;

-- Profit percentage%
select sum((ord.priceEach - pro.buyPrice) * ord.quantityOrdered)/sum(pro.buyPrice*ord.quantityOrdered) * 100 as total_profit_percent
from
orderdetails ord 
join
products pro on ord.productCode = pro.productCode;

-- Gross Profit Margin
select sum((ord.priceEach - pro.buyPrice) * ord.quantityOrdered)/sum(ord.priceEach*ord.quantityOrdered) * 100 as Gross_Profit_Margin
from
orderdetails ord 
join
products pro on ord.productCode = pro.productCode;

-- To find the total number of orders
select count(distinct orderNumber) as Total_Orders from orderdetails;

-- To find the average value of an order
select sum(quantityOrdered*priceEach)/ count(distinct orderNumber) as average_order_value from orderdetails;

-- To find the average quantity per order
select sum(quantityOrdered)/count(distinct orderNumber) as Avg_Qty_PerOrder from orderdetails;

-- Total quantity ordered
select sum(quantityOrdered) as Sum_of_Quantity_Ordered from orderdetails;

-- Total customers
select count(distinct customerNumber) as Total_Customers from customers;

-- Total number of countries where the company sells its products
select count(distinct country) as Total_Countries from customers;

-- Total number of cities across various countries where the company sells its products
select count(distinct city) as Total_Cities from customers;

-- Total value(selling price) of the orders received by the company
select sum(quantityOrdered*priceEach) as Total_Selling_Price from orderdetails; 

-- Total payment made by the customers
select sum(amount) from payments;

-- Total number of products the company offers
select count(distinct productName) as Total_Products from products;

-- 21- Total sales representatives in the company
select count(distinct employeeNumber) as Total_Sales_Representatives from employees where jobTitle = 'Sales Rep';

-- product shimpment status
select status, count(status) as Count_Of_Orders from orders group by status;

-- top 5 products based on quantity ordered
select productName, sum(quantityOrdered) as Quantity_Ordered from products inner join orderdetails on 
products.productCode = orderdetails.productCode group by productName order by sum(quantityOrdered) desc limit 5;

-- top 5 least ordered products based on quantity ordererd
select productName, sum(quantityOrdered) as Quantity_Ordered from products inner join orderdetails on 
products.productCode = orderdetails.productCode group by productName order by sum(quantityOrdered) asc limit 5;

-- top 5 products generating high sales
select productName, sum(quantityOrdered * priceEach) as Sales_Value from products inner join orderdetails on 
products.productCode = orderdetails.productCode group by productName order by sum(quantityOrdered * priceEach) desc limit 5;

-- top 5 countries in terms of sales and their share% in total sale
select country, sum(quantityOrdered*priceEach) as Sale, 
(sum(quantityOrdered*priceEach)/(select sum(quantityOrdered*priceEach) from orderdetails)) * 100 as Percent_Share_In_Total_Sale 
from customers inner join orders on customers.customerNumber = orders.customerNumber
inner join orderdetails on orders.orderNumber = orderdetails.orderNumber 
group by country order by Sale desc limit 5;

-- Last 5 countries in terms of sales
select country, sum(quantityOrdered*priceEach) as Sale 
from customers inner join orders on customers.customerNumber = orders.customerNumber
inner join orderdetails on orders.orderNumber = orderdetails.orderNumber 
group by country order by Sale asc limit 5;


-- Sales order quantity distribution, Sales value distribution and percentage share in total Sales value of each product categpry
select productline as Product_Category, sum(quantityOrdered) as Quantity_Ordered, sum(quantityOrdered*priceEach) as Sales_Value,
(sum(quantityOrdered*priceEach)/(select sum(quantityOrdered*priceEach) from orderdetails)) * 100 as Percent_Share  
from products inner join orderdetails on products.productCode = orderdetails.productCode
group by productline order by sum(quantityOrdered) desc;

-- Top 5 customers of the company placing high value orders
select customerName, sum(quantityOrdered*priceEach) as Sale 
from customers inner join orders on customers.customerNumber = orders.customerNumber
inner join orderdetails on orders.orderNumber = orderdetails.orderNumber 
group by customerName order by Sale desc limit 5;

-- Monthly distribution of sales orders to identify most and least busy months
select monthname(orderDate) as Month, count(distinct orderNumber) as Total_Orders from orders 
group by monthname(orderDate) order by count(distinct orderNumber) desc;

-- Sales representatives' performance ranking based on the selling they have done 
select concat(firstName,' ',lastName) as Employee_Name, sum(quantityOrdered*priceEach) as Sale 
from employees inner join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
inner join orders on customers.customerNumber = orders.customerNumber
inner join orderdetails on orders.orderNumber = orderdetails.orderNumber 
group by Employee_Name order by Sale desc;


-- Thank You --
