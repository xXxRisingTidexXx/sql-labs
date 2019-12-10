# 1
drop table if exists credits_details;
drop table if exists credits;
create table credits
(
    id int not null,
    last_name nvarchar(20) not null,
    first_name nvarchar(10) not null,
    title nvarchar(30) not null
);

create table credits_details
(
    id int not null,
    credit_id int not null ,
    payment_date date not null ,
    amount int
);

insert into credits
values (1, 'A', 'B', 'credit');
insert into credits_details
values (1, 1, '2001-01-10', 200),
       (2, 1, '2002-02-20', 200),
       (3, 1, '2003-03-30', 200);

select *
from credits;

select *
from credits_details;

select d.credit_id,
       c.last_name,
       c.first_name,
       d.payment_date,
       d.amount,
       sum(d.amount) over (order by d.payment_date) as total_amount,
       sum(d.amount) over (order by d.payment_date rows between 1 preceding and unbounded following) as full_amount
from credits as c
         left join credits_details as d
                   on d.credit_id = c.id;

# 2
drop table if exists students;
create table students
(
    id int not null ,
    last_name nvarchar(20) not null,
    first_name nvarchar(10) not null,
    group_name nvarchar(10) not null -- група, в якій навчається студент ІПЗ11, ІПЗ12...
);

insert into students
values (1, 'L 1272', 'F 144432', 'IPZ-21'),
       (2, 'L 4526', 'F 523', 'IPZ-21'),
       (3, 'L 6123', 'F 6415', 'IPZ-21'),
       (4, 'L 347', 'F 3123', 'IPZ-21'),
       (5, 'LLLEXA', 'F 5121', 'IPZ-22'),
       (6, 'L 23', 'F 62351', 'IPZ-22'),
       (7, 'L 17624', 'F 7234', 'IPZ-22');

select id,
       last_name,
       first_name,
       group_name,
       row_number() over (partition by group_name order by last_name) as 'student number'
from students;

# 3
drop table if exists exchange_rate;
create table exchange_rate
(
    id int not null ,
    currency nchar(3), -- USD, EUR, RUB
    `date` date not null ,
    rate float not null
);

insert into exchange_rate
values (1, 'USD', '2010-01-25', 43.2),
       (2, 'USD', '2010-02-25', 45.2),
       (3, 'USD', '2010-03-25', 47.2),
       (4, 'USD', '2010-04-25', 49.2),
       (5, 'EUR', '2010-05-25', 51.2),
       (6, 'EUR', '2010-06-25', 53.2),
       (7, 'EUR', '2010-07-25', 55.2);

select id,
       currency,
       `date`,
       rate,
       lag(rate) over (partition by currency order by `date`) prev_rate,
       lead(rate) over (partition by currency order by `date`) next_rate
from exchange_rate;

# 4
select id,
       currency,
       `date`,
       rate,
       (select rate
        from exchange_rate
        where `date` < er.date and er.currency = currency
        order by `date` desc
        limit 1) as prev_rate,
       (select rate
        from exchange_rate
        where `date` > er.date and er.currency = currency
        order by `date`
        limit 1) as next_rate
from exchange_rate er;