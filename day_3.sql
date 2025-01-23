/*
	Input the food_item_id of the food item that appears the most often.

	Parse through all different schema versions of menu records
	Find menu entries where the guest count was above 78
	Extract the food_item_ids from those successful big dinners
	From this enormous list of items, determine which dish (by food_item_id) 
	appears most frequently across all of the dinners.
*/

with block_3_clean as (
	select
		id,
		guest_count::integer as guest_count,
		menu_data
	from (
		select 
			trim(both '{}' from xpath('/christmas_feast/organizational_details/attendance_record/total_guests/text()', menu_data)::text) as guest_count,
			id,
			menu_data
		from christmas_menus
	) as raw_data
	where guest_count != ''
),

block_2_clean as (
	select
		id,
		guest_count::integer as guest_count,
		menu_data
	from (
		select 
			trim(both '{}' from xpath('/northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', menu_data)::text) as guest_count,
			id,
			menu_data
		from christmas_menus
	) as raw_data
	where guest_count != ''
),

block_1_clean as (
	select
		id,
		guest_count::integer as guest_count,
		menu_data
	from (
		select 
			trim(both '{}' from xpath('/polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()', menu_data)::text) as guest_count,
			id,
			menu_data
		from christmas_menus
	) as raw_data
	where guest_count != ''
),

joined_clean_blocks as (
select
	trim(both '{}' from regexp_matches(menu_text_data, '<food_item_id>(\d+)</food_item_id>', 'g')::text)::integer as food_item_id,
	count(*) as frequency
from (
	select
		id,
		guest_count,
		xmlserialize(content menu_data AS text) AS menu_text_data
	from block_3_clean
	union 
	select
		id,
		guest_count,
		xmlserialize(content menu_data AS text) AS menu_text_data
	from block_2_clean
	union
	select
		id,
		guest_count,
		xmlserialize(content menu_data AS text) AS menu_text_data
	from block_1_clean
	) as clean_data
	where clean_data.guest_count >= 78
	group by 1
)

select *
from joined_clean_blocks
order by frequency desc
