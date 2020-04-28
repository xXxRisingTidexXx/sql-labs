use "TSQL2012";

create table Department
(
    id int auto_increment not null,
    dept_name varchar(40) unique not null,
    employees_number int not null,
    street varchar(100) not null,
    building_num varchar(10) not null,
    room_num int not null,
    dept_location varchar(120) as (concat(street, ', ', building_num, ', ', cast(room_num as char))),
    primary key (id),
    check (employees_number > 0)
);

create table Employee
(
    id int auto_increment not null,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    birthday date not null,
    salary double not null,
    position varchar(30) not null,
    department int not null ,
    primary key (id),
    foreign key (department) references Department(id) on delete cascade
);
