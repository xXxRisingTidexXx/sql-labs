use "TSQL2012";

#1
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
    foreign key fk_employee_department (department) references Department(id) on delete cascade
);

#2
insert into Department (dept_name, employees_number, street, building_num, room_num) values
('Sales', 28, 'Karpenka Karogo, St.', '12/bis, letter A', 41),
('Marketing', 17, 'Karpenka Karogo, St.', '12/bis, letter B', 36),
('Support', 9, 'Karpenka Karogo, St.', '12/bis, letter F', 12),
('Infrastructure', 4, 'Ve Val, St.', '256', 7),
('Development', 10, 'Ve Val, St.', '256', 5);

insert into Employee (first_name, last_name, birthday, salary, position, department) values
('Joseph', 'Stalin', '1878-12-18', 3540.1, 'Senior System Administrator', (
    select id from Department where dept_name = 'Infrastructure'
)),
('Adolf', 'Hitler', '1889-04-20', 2567.2, 'Team Lead', (
    select id from Department where dept_name = 'Development'
));

#3
create table Position
(
    id int auto_increment not null,
    name varchar(30) not null,
    primary key (id)
);

insert into Position (name) values ('Team Lead'), ('Senior System Administrator');

alter table Employee add column position_id int not null after position;
alter table Employee add foreign key fk_employee_position (position_id) references Position(id) on delete cascade;

update Employee set position_id = (select id from Position where name = 'Senior System Administrator')
where position = 'Senior System Administrator';
update Employee set position_id = (select id from Position where name = 'Team Lead')
where position = 'Team Lead';

alter table Employee drop column position;

#4
alter table Employee drop foreign key fk_employee_department;
alter table Department change column id department_id int auto_increment not null;
alter table Employee add foreign key fk_employee_department (department)
    references Department(department_id) on delete cascade;
