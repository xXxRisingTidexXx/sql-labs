use TSQL2012;

#1
select companyname, unitprice
from suppliers s inner join products p on p.supplier_id = s.supplier_id
where unitprice < 11;

#2
select distinct companyname, description, categoryname
from products p
    inner join suppliers s on p.supplier_id = s.supplier_id
    inner join categories c on p.category_id = c.category_id
where description like '%pasta%' or categoryname = 'Beverages';

#3
select concat(e.first_name, ' ', e.last_name) as employee_name,
       e.city as employee_city,
       concat(m.first_name, ' ', m.last_name) as manager_name,
       m.city as manager_city
from employees e inner join employees m
where m.title like '%Manager%' and
      m.city = e.city and
      e.first_name != m.first_name and
      e.last_name != m.last_name;

#4
insert into categories (category_id, categoryname, description)
value (9, 'new category', 'new description');

select *
from categories left join products using (category_id)
where product_id is null;

delete from categories where categoryname = 'new category';

#5
select contactname, address, phone, 'supplier' as whois from suppliers
union
select contactname, address, phone, 'customer' as whois from customers;

#6
select distinct city from suppliers inner join customers using (city);

#7
select distinct s1.city
from suppliers s1 left join customers c1 using (city)
where c1.cust_id is null
union
select distinct c2.city
from customers c2 left join suppliers s2 using (city)
where s2.supplier_id is null;

#8
select concat(last_name, first_name) as full_name,
       timestampdiff(year, hiredate, now()) as experience,
       case
           when timestampdiff(year, hiredate, now()) >= 15 then
               'high-level qualification'
           when timestampdiff(year, hiredate, now()) between 13 and 15 then
               'middle-level qualification'
           else 'low-level qualification'
           end as qualification
from employees;
