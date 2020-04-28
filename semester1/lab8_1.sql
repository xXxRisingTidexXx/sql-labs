use isolation;

#1
set transaction isolation level read uncommitted;
select @@transaction_isolation;
start transaction;
select * from tbl1;
--
select * from tbl1;
commit;
select * from tbl1;

#2_1
set transaction isolation level read committed;
start transaction;
select * from tbl1;
--
select * from tbl1;
commit;
delete from tbl1 where id = 3;

#2_2
set transaction isolation level repeatable read;
start transaction;
select * from tbl1;
--
select * from tbl1;
commit;
delete from tbl1 where id = 3;

#3_1
set transaction isolation level repeatable read;
start transaction;
select * from tbl1 where id >= 1 and id <=5 ;
--
select * from tbl1 where id >= 1 and id <=5 ;
update tbl1 set text = 'modified' where id = 3;
select * from tbl1 where id >= 1 and id <=5 ;
commit;
delete from tbl1 where id = 3;

#3_2
set transaction isolation level serializable;
start transaction;
select * from tbl1 where id >= 1 and id <=5 ;
--
select * from tbl1 where id >= 1 and id <=5 ;
update tbl1 set text = 'modified' where id = 3;
select * from tbl1 where id >= 1 and id <=5 ;
commit;
delete from tbl1 where id = 3;

#4_1
set transaction isolation level repeatable read;
select * from tbl1;
start transaction;
select * from tbl1;
--
insert into tbl2 select * from tbl1;
select * from tbl1;
select * from tbl2;
commit;
select * from tbl1;
truncate table tbl2;
update tbl1 set text = 'first row' where id = 1;
update tbl1 set text = 'second row' where id = 2;

#4_2
set transaction isolation level serializable;
select * from tbl1;
start transaction;
select * from tbl1;
--
insert into tbl2 select * from tbl1;
select * from tbl1;
select * from tbl2;
commit;
select * from tbl1;
truncate table tbl2;
update tbl1 set text = 'first row' where id = 1;
update tbl1 set text = 'second row' where id = 2;
