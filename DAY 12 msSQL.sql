-- Day 12: User Consecutive Day Streak Analysis
-- Difficulty: Hard

-- Given a table with event logs, find the top five users with the longest continuous streak 
-- of visiting the platform in 2020.
-- Note: A continuous streak counts if the user visits the platform at least 
-- once per day on consecutive days.

drop table events;
CREATE TABLE events (
user_id INT,
created_at DATETIME,
url VARCHAR(255)
);


INSERT INTO events (user_id, created_at, url) VALUES
(1, '2019-12-30 10:00:00', 'https://site.com/user1-page1'),
(1, '2019-12-31 11:00:00', 'https://site.com/user1-page2'),
(2, '2019-11-15 12:00:00', 'https://site.com/user2-page1'),
(2, '2019-11-16 13:00:00', 'https://site.com/user2-page2'),
(3, '2019-10-20 14:00:00', 'https://site.com/user3-page1'),
(1, '2020-01-28 10:00:00', 'https://site.com/user1-page3'),
(1, '2020-01-29 11:00:00', 'https://site.com/user1-page4'),
(1, '2020-01-30 12:00:00', 'https://site.com/user1-page5'),
(1, '2020-01-31 13:00:00', 'https://site.com/user1-page6'),
(1, '2020-02-01 14:00:00', 'https://site.com/user1-page7'),
(1, '2020-02-02 12:00:00', 'https://site.com/user1-page8'),
(1, '2020-02-03 12:00:00', 'https://site.com/user1-page9'),
(2, '2020-02-10 15:00:00', 'https://site.com/user2-page3'),
(2, '2020-02-11 16:00:00', 'https://site.com/user2-page4'),
(2, '2020-02-12 17:00:00', 'https://site.com/user2-page5'),
(2, '2020-02-29 18:00:00', 'https://site.com/user2-page6'),
(2, '2020-03-01 19:00:00', 'https://site.com/user2-page7'),
(2, '2020-03-02 20:00:00', 'https://site.com/user2-page8'),
(2, '2020-03-03 21:00:00', 'https://site.com/user2-page9'),
(2, '2020-03-18 21:00:00', 'https://site.com/user2-page10'),
(3, '2020-03-15 22:00:00', 'https://site.com/user3-page2'),
(3, '2020-05-20 01:00:00', 'https://site.com/user3-page3'),
(3, '2020-05-22 02:00:00', 'https://site.com/user3-page4'),
(4, '2020-12-28 04:00:00', 'https://site.com/user4-page1'),
(4, '2020-12-30 05:00:00', 'https://site.com/user4-page2'),
(4, '2020-12-31 06:00:00', 'https://site.com/user4-page3'),
(5, '2020-04-01 08:00:00', 'https://site.com/user5-page1'),
(5, '2020-04-02 09:00:00', 'https://site.com/user5-page2'),
(5, '2020-07-15 10:00:00', 'https://site.com/user5-page3'),
(6, '2020-05-31 15:00:00', 'https://site.com/user6-page1'),
(6, '2020-06-01 16:00:00', 'https://site.com/user6-page2'),
(6, '2020-06-02 17:00:00', 'https://site.com/user6-page3'),
(6, '2020-06-03 18:00:00', 'https://site.com/user6-page4'),
(6, '2020-06-04 19:00:00', 'https://site.com/user6-page5'),
(6, '2020-06-05 20:00:00', 'https://site.com/user6-page6'),
(6, '2020-06-06 21:00:00', 'https://site.com/user6-page7'),
(6, '2020-06-07 22:00:00', 'https://site.com/user6-page8'),
(1, '2021-01-01 22:00:00', 'https://site.com/user1-page10'),
(1, '2021-01-02 23:00:00', 'https://site.com/user1-page11'),
(2, '2021-02-10 00:00:00', 'https://site.com/user2-page11'),
(2, '2021-02-11 01:00:00', 'https://site.com/user2-page12'),
(3, '2021-03-15 02:00:00', 'https://site.com/user3-page5'),
(3, '2021-03-16 03:00:00', 'https://site.com/user3-page6'),
(5, '2021-05-25 06:00:00', 'https://site.com/user5-page4'),
(5, '2021-05-26 07:00:00', 'https://site.com/user5-page5'),
(6, '2021-06-30 08:00:00', 'https://site.com/user6-page9'),
(6, '2021-07-01 09:00:00', 'https://site.com/user6-page10'),
(2, '2020-04-11 15:00:00', 'https://site.com/user2-page13'),
(2, '2020-04-13 16:00:00', 'https://site.com/user2-page14'),
(2, '2020-04-14 17:00:00', 'https://site.com/user2-page15');

	WITH events2020 AS (
			SELECT user_id 	,CAST(created_at AS DATE) AS created_at
				, row_number() OVER(PARTITION BY user_id ORDER BY created_at) AS row_num
			FROM events
			WHERE created_at BETWEEN '2020-01-01 00:00:00' AND '2020-12-31 23:59:59')
	, streak_groups AS (
			SELECT user_id, created_at
			, DATEDIFF(DAY, '2020-01-01', created_at) - row_num AS streak_group
			FROM events2020) 
	, streak_lengths as (
			SELECT user_id, streak_group, COUNT(streak_group) as streak_length
			FROM streak_groups
			GROUP BY user_id,streak_group)
	SELECT TOP 3 user_id, MAX(streak_length) as streak_length
	FROM streak_lengths
	GROUP BY user_id
	ORDER BY streak_length DESC;


