/*
	New tags that weren't in previous_tags (call this added_tags)
	Tags that appear in both previous and new tags (call this unchanged_tags)
	Tags that were removed (call this removed_tags)
	For each toy, return toy_name and these three categories as arrays.
	
	Find the toy with the most added tags, there is only 1, and submit the following:
	
	toy_id
	added_tags length
	unchanged_tags length
	removed_tags length
	Remember to handle cases where the array is empty, their output should be 0.
*/
with previous as (
	select
		toy_id,
		unnest(previous_tags) as tag
	from toy_production
),

changed as (
	select
		toy_id,
		unnest(new_tags) as tag
	from toy_production
),

unchanged_tags as (
	select
		changed.toy_id,
		count(distinct changed.tag) as unchanged_tags
	from changed
	join previous on previous.toy_id = changed.toy_id
		and previous.tag = changed.tag
	group by changed.toy_id
),

added_tags as (
	select
		toy_id,
		count(distinct tag) as added_tags
	from (
		select
			changed.toy_id,
			changed.tag
		from changed
		except
		select 
			previous.toy_id,
			previous.tag
		from previous
	) as sub
	group by toy_id
),

removed_tags as (
	select
		toy_id,
		count(distinct tag) as removed_tags
	from (
		select 
			previous.toy_id,
			previous.tag
		from previous
		except
		select
			changed.toy_id,
			changed.tag
		from changed
	) as sub
	group by toy_id
)

select
	toy_production.toy_id,
	toy_production.toy_name,
	coalesce(added_tags.added_tags, 0) as added_tags,
	coalesce(unchanged_tags.unchanged_tags, 0) as unchanged_tags,
	coalesce(removed_tags.removed_tags, 0) as removed_tags
from toy_production
left join removed_tags 
	on removed_tags.toy_id = toy_production.toy_id
left join added_tags
	on added_tags.toy_id = toy_production.toy_id
left join unchanged_tags
	on unchanged_tags.toy_id = toy_production.toy_id
order by added_tags.added_tags desc nulls last

