use isolation;

#1
set transaction isolation level read uncommitted;
start transaction;
insert into tbl1 values (1, 'first row'), (2, 'second row');
commit;

#2_1
set transaction isolation level read committed;
start transaction;
insert into tbl1 values (3, 'third row');
commit;

#2_2
set transaction isolation level repeatable read;
start transaction;
insert into tbl1 values (3, 'third row');
commit;

#3_1
set transaction isolation level repeatable read;
start transaction;
insert into tbl1 values (3, 'third row');
commit;

#3_2
set transaction isolation level serializable;
start transaction;
insert into tbl1 values (3, 'third row');
commit;

#4_1
set transaction isolation level repeatable read;
start transaction;
update tbl1 set text = 'modified';
commit;

#4_2
set transaction isolation level serializable;
start transaction;
update tbl1 set text = 'modified';
commit;
