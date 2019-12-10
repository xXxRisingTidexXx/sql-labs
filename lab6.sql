use tmp;

# 1
create table tmp.employees
select emp_id as empid,
       last_name as employee_name,
       address,
       city,
       coalesce(region, '') as region,
       postalcode,
       country,
       phone
from TSQL2012.employees;

# 2
insert into tmp.employees
select supplier_id as empid,
       left(contactname, 20) as employee_name,
       address,
       city,
       coalesce(region, '') as region,
       postalcode,
       country,
       phone
from TSQL2012.suppliers;

# 3
update tmp.employees set country = 'Urugvay'
where empid in (
    select e.empid
    from tmp.employees e
    where e.country in (select country from TSQL2012.customers where city like 'L%')
);

# 4
create table tmp.orders
select order_id as orderid, cust_id as custid, emp_id as empid, orderdate, 0 as item_cnt
from TSQL2012.orders;

create table tmp.order_details select * from TSQL2012.order_details;

# 5
with details as (
    select order_id, count(order_id) as order_count
    from TSQL2012.order_details group by order_id
)
select orderid, custid, empid, orderdate, d.order_count
from tmp.orders right join details d on d.order_id = orderid;

# 6
delete
from tmp.order_details
where year(
    (select min(orderdate) from tmp.orders where orderid = order_id group by orderid)
) = 2007
