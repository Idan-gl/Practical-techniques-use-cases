
--1. Detecting Empty Columns

CREATE TABLE customers
(customer_id int,
customer_name varchar(250),
customer_address varchar(250),
customer_age int)
GO
select * from customers

select * 
from ( 
select (case when max(customer_id) is null then 'customer_id' else null end ) AS 'Name' from customers 
union all
select (case when max(customer_name) is null then 'customer_name' else null end ) from customers 
union all
select (case when max(customer_address) is null then 'customer_address' else null end ) from customers 
union all
select (case when max(customer_age) is null then 'customer_age' else null end ) from customers 
) tbl 
where tbl.name is not null
 
--2. Locating Empty Rows

CREATE TABLE customerss  
       (customer_id int,   
        customer_name varchar(250),   
        customer_address varchar(250),  
        customer_age int)  
GO  
   
INSERT INTO customerss VALUES  
   (1, 'Christopher' , 'New York', 43),  
   (NULL,NULL,NULL,NULL),  
   (3, 'Kenneth' , 'Los Angeles', 29),  
   (NULL, NULL , NULL, NULL)  
GO 
select * from customerss

--3.  Locating Duplicate Rows

CREATE TABLE customers1  
        (customer_id int,   
         customer_name varchar(250),   
         customer_address varchar(250),  
         customer_age int)  
GO

INSERT INTO customers1 VALUES  
   (1, 'Michael' , 'New York', 43),  
   (2, 'Charles','Los Angeles' ,34),  
   (2, 'Charles','Los Angeles' ,34),  
   (3, 'Kenneth' , 'Chicago', 29),  
   (3, 'Kenneth' , 'Chicago' , 29),  
   (4, 'Mark' , 'Phoenix' , 30)  
GO  
  

--. Displaying Duplicate Rows (Version A)
--1.A

select customer_id, customer_name, customer_address, customer_age  
from customers1
group by customer_id, customer_name, customer_address, customer_age
having count (*) > 1

--1.B
with "cte" as 
(
SELECT *, 
ROW_NUMBER () over(partition by customer_id order by customer_id) RN
FROM customers1
) select * from "cte"
where rn > 1

--2. Duplicate rows in a manner (Version B)

select c1.* 
from customers1 c1 
join(
    select customer_id, count (*) as 'Duplicate'
    from customers1
    group by customer_id
    having count(*) > 1
	) c2
on c1.customer_id = c2.customer_id


--3. Unique rows (Version C)

select customer_id, customer_name, customer_address, customer_age 
from customers1
group by customer_id, customer_name, customer_address, customer_age
having count (*) = 1


--4. Three different SQL techniques to delete the duplicate rows
--A

select distinct customer_id, customer_name, customer_address, customer_age
from customers1

--B.

select customer_id, customer_name, customer_address, customer_age 
from customers1
group by customer_id, customer_name, customer_address, customer_age

--C. 

select *
from customers1
group by customer_id, customer_name, customer_address, customer_age
having count (*) = 1
union
select *
from customers1
group by customer_id, customer_name, customer_address, customer_age
having count (*) = 2

--4. Handling Percent (%) Values

CREATE TABLE products (product_name varchar(25))    
GO    
     
INSERT INTO products VALUES      ('4% Cottage Cheese'),    
                                 ('Chips Ahoy!'),    
                                 ('1% Cottage Cheese'),    
                                 ('General Mills Cereals'),    
                                 ('Pampers'),    
                                 ('Mr. Clean')   

--Displays all rows containing the tag “%”
--A.
select * from products
where product_name like '%[%]%'

--B.
select * from products
where product_name like '%!%%' ESCAPE '!'

--C.  
select *
from products
where CHARINDEX('%',[product_name])>0

--5. Possible Combinations

CREATE TABLE basketball_teams   
(team_name_1 varchar(25),   
team_name_2 varchar(25))  
GO  
   
INSERT INTO basketball_teams  
VALUES ('Boston Celtics', 'Brooklyn Nets'),   
      ('New York Knicks' , 'Philadelphia 76ers'),  
      ('Toronto Raptors' , 'Golden State Warriors')  
GO  
          
with "cte1" as
  (
   select team_name_1 as 'TeamName' from basketball_teams  
   union
   select team_name_2 as 'TeamName' from basketball_teams  
  ), "cte2" as
(   
  select ROW_NUMBER() over(order by (SELECT NULL)) AS 'TeamID',
  TeamName
  from cte1
)
select c1.TeamName, c2.TeamName 
from cte2 c1 cross join cte2 c2
where c2.TeamID < c1.TeamID
order by 1


with "cte1" as
  (
   select team_name_1 as 'TeamName' from basketball_teams  
   union
   select team_name_2 as 'TeamName' from basketball_teams  
  )
select TeamName,
      ROW_NUMBER() over(order by (SELECT NULL)) AS 'TeamID'
from cte1
