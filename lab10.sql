use TSQL2012;

select * from suppliers;

# 1
with avarage_hj as (
    select avg(unitprice)
    from suppliers s left join products p on s.supplier_id = p.supplier_id
    where s.contactname = 'Hance, Jim'
)
     select contactname, address, (select * from avarage_hj) as 'avg_jim'
     from suppliers as s
     where (
         select avg(unitprice)
         from products as p
         where p.supplier_id = s.supplier_id
     ) > (select * from avarage_hj)
     group by s.supplier_id;



# 2
with total_2006 as (select count(*) from orders where year(orderdate) = 2006),
     total_2007 as (select count(*) from orders where year(orderdate) = 2007),
     total_2008 as (select count(*) from orders where year(orderdate) = 2008)
select contactname,
       address,
       (select * from total_2006) as 'total_2006',
       (select * from total_2007) as 'total_2007',
       (select * from total_2008) as 'total_2008'
from suppliers;

# 3
with recursive hierarchy (emp_id, last_name, first_name, title, mgrid) as (
    select emp_id, last_name, first_name, title, mgrid
    from employees
    where last_name = 'Peled'
    union all
    select e.emp_id, e.last_name, e.first_name, e.title, e.mgrid
    from employees e inner join hierarchy on e.emp_id = hierarchy.mgrid
)
select * from hierarchy;
