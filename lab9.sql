use TSQL2012;

# 1
drop procedure if exists insert_order_detail;

delimiter //

create procedure insert_order_detail(
    in customer_id int,
    in employee_id int,
    in product_name varchar(30),
    in unit_price float,
    in quantity smallint,
    in adjustment decimal
)
begin
    declare oid int default (
        select order_id from orders where cust_id = customer_id and emp_id = employee_id
    );
    declare pid int default (
        select product_id from products where productname = product_name
    );
    if (adjustment is null) then
        set adjustment = 2;
    end if;
    if ((
        select count(*) from orders where cust_id = customer_id and emp_id = employee_id
    ) > 1) then
        select 'orders already exist' as error;
    elseif ((
        select count(*) from orders where cust_id = customer_id and emp_id = employee_id
    ) = 0) then
        select 'order not found' as error;
    elseif ((select count(*) from products where productname = product_name) = 0) then
        select 'product not found' as error;
    else
        insert into order_details (order_id, product_id, unitprice, qty, discount)
        values (oid, pid, unit_price, quantity, adjustment);
    end if;
end //

call insert_order_detail(12, 32, 'Product awd', 505, 404, 3);
call insert_order_detail(-85, -5, 'Product RECZE', 505, 404, 3);
call insert_order_detail(85, 5, 'Product RECZE', 505, 404, 3);

# 2
drop table if exists tree;
create table if not exists tree
(
    id       int,
    parent_id int,
    num      int
);

insert into tree values (0, 0, 1), (1, 0, 2), (2, 1, 3);

select * from tree;

drop procedure if exists delete_node;

delimiter //
set @@SESSION.max_sp_recursion_depth = 25//
create procedure delete_node(in node_id int)
begin
    declare row_not_found tinyint default false;
    declare child_id int;
    declare children cursor for select id from tree where parent_id = node_id;
    declare continue handler for not found set row_not_found = true;
    if ((select count(*) from tree where id = node_id) = 0) then
        select 'no nodes' as message;
    else
        open children;
        while row_not_found = false
            do
                fetch children into child_id;
                call delete_node(child_id);
            end while;
        close children;
        delete from tree where id = node_id;
    end if;
end //

call delete_node(1);

# 3
drop function if exists longest_suffix;
set global log_bin_trust_function_creators = 1;

delimiter //

create function longest_suffix(s varchar(500)) returns varchar(100)
begin
    declare i int default 1;
    declare word varchar(100) default '';
    declare suffix varchar(100) default '';
    while (i <= length(s))
        do
            if (substring(s, i, 1) = ' ') then
                if (length(word) > length(suffix)) then
                    set suffix = word;
                end if;
                set word = '';
            else
                set word = concat(word, substring(s, i, 1));
            end if;
            set i = i + 1;
        end while;
    return suffix;
end //

create function arithmetic_sum(n int) returns int
begin
    declare s int default 0;
    declare i int default 1;
    while (i <= n)
        do
            set s = s + i;
            set i = i + 1;
        end while;
    return s;
end //

delimiter ;

select arithmetic_sum(5);

select longest_suffix('hello world 1 2  qwa awd     wiefuawilefudaw dawe waedd  d d d');
select longest_suffix('d d');
select longest_suffix('');

# 4
drop function if exists longest_substring;
set global log_bin_trust_function_creators = 1;

delimiter //

create function longest_substring(w1 varchar(500), w2 varchar(500)) returns varchar(100)
begin
    declare i int default 1;
    declare j int default 1;
    declare k int default 0;
    declare match_index int default -1;
    declare match_length int default 0;
    declare match_index_max int default -1;
    declare match_length_max int default 0;
    while (i < length(w1))
        do
            set j = 0;
            while (j < length(w2))
                do
                    set k = 0;
                    while (k < length(w2) - j)
                        do
                            if (substring(w1, i + k + 1, 1) = substring(w2, j + k + 1, 1)) then
                                if (match_index = -1) then
                                    set match_index = i + k;
                                end if;
                                set match_length = match_length + 1;
                            else
                                if (match_length > match_length_max) then
                                    set match_index_max = match_index;
                                    set match_length_max = match_length;
                                end if;
                                set match_index = -1;
                                set match_length = 0;
                            end if;
                            set k = k + 1;
                        end while;
                    set j = j + 1;
                end while;
            set i = i + 1;
        end while;
    return substring(w1, match_index_max + 1, match_length_max);
end //

delimiter ;

select longest_substring('world', 'sssssldssorldssrldss');
select longest_substring('world', '');

# 5
drop procedure if exists select_customers;

delimiter //

create procedure select_customers(year1 int, year2 int)
begin
#     select o.cust_id,
#            (select count(*)
#             from orders as ord
#             where year(ord.orderdate) = year1
#               and ord.cust_id = customers.cust_id) as year1,
#            (select count(*)
#             from orders as ord
#             where year(ord.orderdate) = year2
#               and ord.cust_id = customers.cust_id) as year2
#     from customers
#              right join orders o on customers.cust_id = o.cust_id
#     group by cust_id;

    set @query = concat(
            "SELECT cust_id AS customer, (SELECT COUNT(o1.orderdate) FROM orders AS o1 WHERE YEAR(o1.orderdate) = ",
            year1, " AND o1.cust_id = orders.cust_id) AS "" ", year1,
            " "",(SELECT COUNT(o2.orderdate) FROM orders AS o2 WHERE YEAR(o2.orderdate) = ", year2,
            " AND o2.cust_id = orders.cust_id) AS "" ", year2, " "" FROM orders GROUP BY cust_id ORDER BY cust_id"
    );
    prepare stmt from @query;
    execute stmt;
    deallocate prepare stmt;
end //

delimiter ;

call select_customers(2007, 2009);