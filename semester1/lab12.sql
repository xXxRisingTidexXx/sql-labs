# 1
select json_extract('[
  {
    "address": {
      "street": "123 First Street",
      "city": "Oxnard",
      "state": "CA",
      "zip": "90122"
    }
  },
  {
    "address": {
      "street": "4 Main Street",
      "city": "Melborne",
      "state": "California",
      "zip": "90125"
    }
  },
  {
    "address": {
      "street": "173 Caroline Ave",
      "city": "Montrose",
      "state": "Georgia",
      "zip": "31505"
    }
  }
]', '$[1]') as "JSON";

# 2
delimiter //
drop function if exists json_arrayagg //

create aggregate function if not exists json_arrayagg(next_value text) returns text
begin
    declare json text default '[""]';
    declare continue handler for not found return json_remove(json, '$[0]');
    loop
        fetch group next row;
        set json = json_array_append(json, '$', next_value);
    end loop;
end //

delimiter ;

select json_object(
    'country',
    country,
    'employees',
    json_extract(json_arrayagg(last_name), '$')
)
from employees
group by country;

# 3
create table emp (id int primary key auto_increment, country_emp json default null);

insert into emp
values (
    1, '{"country": "USA", "employees": ["Davis", "Funk", "Lew", "Peled", "Camero"]}'
), (
    2, '{"country": "UK", "employees": ["Buck", "Suurs", "King", "Dolgopyatova"]}'
);

select * from emp;

select id,
       json_insert(
           country_emp,
           '$.emp_cnt',
           json_length(json_extract(country_emp, '$.employees'))
       ) as 'JSON'
from emp;

# 4
select country, empl
from emp, json_table(
    country_emp,
    '$' columns (
        country varchar(30) path '$.country',
        nested path '$.employees[*]' columns (empl varchar(30) path '$')
    )
) tble;