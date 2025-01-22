/*
Create a report showing what gifts children want, with difficulty ratings and categorization.

The primary wish will be the first choice

The secondary wish will be the second choice

You can presume the favorite color is the first color in the wish list

Gift complexity can be mapped from the toy difficulty to make. Assume the following:
	Simple Gift = 1
    Moderate Gift = 2
    Complex Gift >= 3

We assign the workshop based on the primary wish's toy category. Assume the following:

  outdoor = Outside Workshop
  educational = Learning Workshop
  all other types = General Workshop

Order the list by name in ascending order.

Your answer should limit its return to only 5 rows

In the inputs below provide one row per input in the format, with no spaces and comma separation:

name,primary_wish,backup_wish,favorite_color,color_count,gift_complexity,workshop_assignment
*/


with child_wish_list as (
	select
		child_id,
		wishes->>'first_choice' as primary_wish,
		wishes->>'second_choice' as backup_wish,
		wishes->'colors'->>0 as favorite_color,
		json_array_length(wishes->'colors') as color_count
	from wish_lists
)

select 
	name,
	child_wish_list.primary_wish,
	child_wish_list.backup_wish,
	child_wish_list.favorite_color,
	child_wish_list.color_count,
	case when primary_toy_catalogue.difficulty_to_make = 1 then 'Simple Gift' 
		when primary_toy_catalogue.difficulty_to_make = 2 then 'Moderate Gift' 
		when primary_toy_catalogue.difficulty_to_make >= 3 then 'Complex Gift' 
	end as gift_complexity,
	case when primary_toy_catalogue.category = 'outdoor' then 'Outside Workshop'
		when primary_toy_catalogue.category = 'educational' then 'Learning Workshop'
		else 'General Workshop'
	end as workshop_assignment
from children
join child_wish_list 
	on child_wish_list.child_id = children.child_id
join toy_catalogue as primary_toy_catalogue
	on primary_toy_catalogue.toy_name = child_wish_list.primary_wish
order by children.name asc
limit 5
