use TSQL2012;

drop procedure if exists swap_categories_names;
drop procedure if exists make_contacts;
drop procedure if exists order_contact_names;
drop procedure if exists make_localities;
drop procedure if exists make_territories;

delimiter //

# 1
create procedure swap_categories_names()
begin
    declare id int default 1;
    declare length int default (select count(*) from categories);
    declare buffer1, buffer2 varchar(15);
    while id <= length do
        set buffer1 = (select categoryname from categories where category_id = id + 1);
        set buffer2 = (select categoryname from categories where category_id = id);
        update categories set categoryname = buffer1 where category_id = id;
        update categories set categoryname = buffer2 where category_id = id + 1;
        set id = id + 2;
    end while;
end //

# 2
create procedure make_contacts()
begin
    declare contacttitle varchar(30) default '';
    declare finished integer default 0;
    declare contacttitle_cursor cursor for select distinct contacttitle from customers;
    declare continue handler for not found set finished = 1;
    drop table if exists contacts;
    create table contacts (
        cust_id integer,
        contactname varchar(30) not null,
        contacttitle varchar(30) not null
    );
    open contacttitle_cursor;
    fetch_contacttitles: loop
        fetch contacttitle_cursor into contacttitle;
        if finished = 1 then
            leave fetch_contacttitles;
        end if;
        insert into contacts
        select cust_id, contactname, contacttitle from customers
        where contacttitle = contacttitle
        order by cust_id
        limit 2;
    end loop fetch_contacttitles;
    close contacttitle_cursor;
    select * from contacts;
end //

# 3
create procedure order_contact_names()
begin
    declare id integer default 1;
    declare name varchar(30) default '';
    declare finished integer default 0;
    declare contactname_cursor cursor for
        select contactname from customers order by contactname;
    declare continue handler for not found set finished = 1;
    drop table if exists ordered_contacts;
    create table ordered_contacts (
        `#` integer,
        contactname varchar(30) not null
    );
    open contactname_cursor;
    fetch_contactnames: loop
        fetch contactname_cursor into name;
        if finished = 1 then
            leave fetch_contactnames;
        end if;
        insert into ordered_contacts values (id, name);
        set id = id + 1;
    end loop fetch_contactnames;
    close contactname_cursor;
    select * from ordered_contacts;
end //

# 4_1
create procedure make_localities(
    in i integer,
    in territory varchar(15)
)
begin
    declare j integer default 1;
    declare locality varchar(15) default '';
    declare finished integer default 0;
    declare city_cursor cursor for
        select distinct city from customers where country = territory order by city;
    declare continue handler for not found set finished = 1;
    open city_cursor;
    fetch_cities: loop
        fetch city_cursor into locality;
        if finished = 1 then
            leave fetch_cities;
        end if;
        insert into territories
        values (concat(cast(i as char), '.', cast(j as char)), locality);
        set j = j + 1;
    end loop fetch_cities;
    close city_cursor;
end //

# 4_2
create procedure make_territories()
begin
    declare i integer default 1;
    declare territory varchar(15) default '';
    declare finished integer default 0;
    declare country_cursor cursor for
        select distinct country from customers order by country;
    declare continue handler for not found set finished = 1;
    drop table if exists territories;
    create table territories (
        `#` varchar(10),
        `country/city` varchar(15) not null
    );
    open country_cursor;
    fetch_countries: loop
        fetch country_cursor into territory;
        if finished = 1 then
            leave fetch_countries;
        end if;
        insert into territories values (cast(i as char), territory);
        call make_localities(i, territory);
        set i = i + 1;
    end loop fetch_countries;
    close country_cursor;
    select * from territories;
end //

delimiter ;
