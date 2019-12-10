use TSQL2012;

#1
select count(city) as employee_count, city from employees group by city;

#2
select p.category_id, categoryname, count(p.category_id) as product_count
from categories c inner join products p on c.category_id = p.category_id
where unitprice >= 25
group by p.category_id;

#3
select o.cust_id,
       companyname,
       country,
       min(shippeddate) as first_shipment,
       max(shippeddate) as last_shipment
from customers c inner join orders o on c.cust_id = o.cust_id
where country = 'USA'
group by o.cust_id
having min(shippeddate) > 2006;

#4
select country,
       region,
       city,
       round(sum(unitprice * qty * (1 - discount)), 2) as order_sum,
       round(avg(qty), 2) as order_average_quntity
from customers c
    inner join orders o on c.cust_id = o.cust_id
    inner join order_details od on o.order_id = od.order_id
group by country, region, city
having min(o.cust_id) > 10
order by country, region, city;
