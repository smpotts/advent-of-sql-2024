/*
	Calculate the average speed for each reindeer in each exercise type, excluding Rudolf.
	Find the highest average speed for each reindeer amongst those average speeds.
	Select the top 3 reindeer based on their highest average speed. Round the score to 2 decimal places.
*/

select
	reindeer_name,
	exercise_name,
	round(avg(speed_record), 2) as avg_speed_record
from reindeers
join training_sessions
	on training_sessions.reindeer_id = reindeers.reindeer_id
where reindeer_name != 'Rudolph'
group by reindeer_name,
	exercise_name
order by avg_speed_record desc

