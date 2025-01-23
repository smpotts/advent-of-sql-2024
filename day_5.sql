/*
	Compare a date to the date before.

	List each day's production date and the number of toys produced on that day.
	Include the previous day's toy production next to each current day's production.
	Calculate the change in the number of toys produced compared to the previous day.
	Calculate the percentage change in production compared to the previous day.
	The result set should display the following columns:
	
	production_date: The current date.
	toys_produced: Number of toys produced on the current date.
	previous_day_production: Number of toys produced on the previous date.
	production_change: Difference in toys produced between the current date and the previous date.
	production_change_percentage: Percentage change in production compared to the previous day.
	
	Submit the date of the day with the largest daily increase in percentage
*/

select
	previous_date,
	previous_day_production,
	production_date,
	toys_produced,
	toys_produced - previous_day_production as production_change,
	((toys_produced - previous_day_production)::decimal / abs(previous_day_production)::decimal) * 100 as production_change_percentage
from (
	select
		lag(production_date) over (order by production_date) as previous_date,
		lag(toys_produced) over (order by production_date) as previous_day_production,
		production_date as production_date,
		toys_produced as toys_produced
	from toy_production
	order by production_date
) as sub
order by 6 desc
