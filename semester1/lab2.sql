use TSQL2012;

#1
select * from employees where birthdate < cast('1950-00-00' as date);

#2
select (year(now()) - year(hiredate)) as "experience" from employees;

#3
select concat(substr(first_name, 1, 1), '. ', last_name) as name_and_surname
from employees;

#4
select *
from customers
where contacttitle like '%Manager%' and (region in ('BC', 'OR', 'SP') or region is null);

#5
select *
from orders
where orderdate between cast('2006-08-01' as date) and cast('2007-01-14' as date) and
      freight not between 15 and 55 and
      not (shipcountry in ('USA') and shippostalcode > 10250);
