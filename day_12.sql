/*
Find the toy with the second highest percentile of requests. Submit the name of the toy and the percentile value.

If there are multiple values, choose the first occurrence.

Order by percentile descending, then gift name ascending.
*/
with gift_freq as (
	select
		gifts.gift_id,
		gift_name,
		count(distinct request_id) as req_count
	from gifts
	join gift_requests 
		on gift_requests.gift_id = gifts.gift_id
	group by gifts.gift_id,
		gift_name
),

ranked as (
select
	gift_name,
	-- req_count,
	percent_rank() over(order by req_count)  as percent_rank_req
from gift_freq
)

select 
	gift_name,
	round(percent_rank_req::numeric, 2) as rank_rounded
from ranked
order by percent_rank_req desc, gift_name

