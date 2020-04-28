# Петраківський Данило
# Білет №15
select count(*) as customer_count from customers as c
where c.country in (
    select s.country from suppliers as s
    where lower(s.contacttitle) = 'owner'
);
