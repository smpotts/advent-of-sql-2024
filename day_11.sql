/*
Mrs. Claus needs a comprehensive analysis of the tree farms. Using window functions, create a query that will shed some light on the field perfomance.

Show the 3-season moving average per field per season per year

Write a single SQL query using window functions that will reveal these vital patterns. Your analysis will help ensure that every child who wishes for a Christmas tree will have one for years to come.

Order them by three_season_moving_avg descending to make it easier to find the largest figure.

Seasons are ordered as follows:

Spring THEN 1
Summer THEN 2
Fall THEN 3
Winter THEN 4
*/

select
	field_name,
	harvest_year,
	season,
	round(avg(trees_harvested) over(
		partition by field_name, harvest_year 
		-- if you want a three-season moving average, the window function should consider previous seasons rather than just previous rows ordered by harvest_year
		order by season_order
		rows between 2 preceding and current row
	) ,2) as three_season_moving_avg
from (
	select
		field_name,
		harvest_year,
		season,
		case when season = 'Spring' then 1
			when season = 'Summer' then 2
			when season = 'Fall' then 3
			when season = 'Winter' then 4
		end as season_order,
		trees_harvested
	from treeharvests
) as sub
order by three_season_moving_avg desc
