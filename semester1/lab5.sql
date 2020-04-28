use TSQL2012;

#1
select c1.cust_id,
       c1.companyname,
       c1.contactname,
       (
           select count(distinct s.supplier_id)
           from customers c2
               inner join orders o on c2.cust_id = o.cust_id
               inner join order_details od on o.order_id = od.order_id
               inner join products p on od.product_id = p.product_id
               inner join suppliers s on p.supplier_id = s.supplier_id
           where c2.cust_id = c1.cust_id
       ) as supplier_count
from customers c1;

#2
select first_name,
       last_name,
       (
           select first_name from employees e2 where e2.emp_id = e1.mgrid
       ) as manager_first_name,
       ifnull(
           (select last_name from employees e3 where e3.emp_id = e1.mgrid),
           'top manager'
       ) as manager_last_name
from employees e1;

#3
select o1.cust_id, min(o1.orderdate) as order_date
from customers c1 inner join orders o1 on c1.cust_id = o1.cust_id
group by c1.cust_id
having min(o1.orderdate) < (
    select min(o2.orderdate)
    from customers as c2 join orders o2 on c2.cust_id = o2.cust_id
    where c2.companyname = 'Customer LCOUJ'
);

#4
select *
from customers c1
where not exists(
    select c2.cust_id
    from customers c2
    where c1.cust_id != c2.cust_id and c1.city = c2.city
)
order by c1.city;

#5
select distinct city, count(city) as customer_count
from customers c1
where (select count(*) from customers c2 where c1.city = c2.city) > 4
group by c1.city;

#6
select distinct city,
                count(cust_id) as customer_count,
                count(supplier_id) as supplier_count,
                count(cust_id) + count(supplier_id) as participant_count
from (
    select cust_id, null as supplier_id, city from customers
    union
    select null as cust_id, supplier_id, city from suppliers
) p
group by city
having count(city) between 3 and 6
order by participant_count;

#7
select distinct orderdate,
                count(orderdate) as order_count,
                sum((
                    select sum(unitprice * qty * (1 - discount))
                    from order_details od
                    where od.order_id = o.order_id
                )) as order_total_price
from orders o
group by orderdate
order by orderdate;

#8
select *,
       (
           select count(*)
           from products p inner join suppliers s on p.supplier_id = s.supplier_id
           where c.category_id = s.supplier_id
       ) as supplier_count
from categories c
order by supplier_count;
