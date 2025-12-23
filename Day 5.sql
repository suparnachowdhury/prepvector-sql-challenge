-- Prepvector SQL Challenge Day 5: 
-- Difficulty: Medium

-- Problem:

-- Write a query to get the post-success rate for each day in the month of January 2020.
-- Post Success Rate is defined as the number of posts submitted (post_submit) 
-- divided by the number of posts entered (post_enter) for each day.
-- Success_rate = Post_submitted/post_entered for each day January 2020

drop table events;

CREATE TABLE events (
post_id INT,
created_at DATETIME,
action VARCHAR(20)
);

INSERT INTO events VALUES
(1, '2020-01-01 10:00:00', 'post_enter'),
(1, '2020-01-01 10:05:00', 'post_submit'),
(2, '2020-01-01 11:00:00', 'post_enter'),
(2, '2020-01-01 11:10:00', 'post_canceled'),
(3, '2020-01-01 15:00:00', 'post_enter'),
(3, '2020-01-01 15:30:00', 'post_submit'),
(4, '2020-01-02 09:00:00', 'post_enter'),
(4, '2020-01-02 09:15:00', 'post_canceled'),
(5, '2020-01-02 10:00:00', 'post_enter'),
(5, '2020-01-02 10:10:00', 'post_canceled'),
(10, '2020-01-15 14:00:00', 'post_enter'),
(10, '2020-01-15 14:30:00', 'post_submit'),
(6, '2019-12-31 23:55:00', 'post_enter'),
(6, '2020-01-01 00:05:00', 'post_submit'),
(7, '2020-02-01 00:00:00', 'post_enter'),
(7, '2020-02-01 00:10:00', 'post_submit'),
(8, '2019-01-15 10:00:00', 'post_enter'),
(8, '2019-01-15 10:30:00', 'post_submit'),
(9, '2021-01-01 09:00:00', 'post_enter'),
(9, '2021-01-01 09:10:00', 'post_canceled');

select * from events;
with jan2020 as (
select post_id,
cast(created_at as date) created_at
, action
from events
where created_at between '2020-01-01 00:00:00' and '2020-01-31 23:00:00')
, jan2020_counts as (
select 
created_at,
count(case when action = 'post_enter' then post_id end) as total_enters
, count( case when action = 'post_submit' and
   post_id in (select post_id from jan2020 where action = 'post_enter') 
then post_id end) as total_submits
from jan2020
group by created_at)
select *,
case when total_enters = 0 then null 
else round(total_submits* 100.0 /total_enters, 2) end as success_rate
from jan2020_counts;