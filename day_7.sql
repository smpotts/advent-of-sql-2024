/*
	Create a query that returns pairs of elves who share the same primary_skill. 
	The pairs should be comprised of the elf with the most (max) and least (min) years of experience in the primary_skill.
	
	When you have multiple elves with the same years_experience, order the elves by elf_id in ascending order.
	
	Your query should return:
	The ID of the first elf with the Max years experience
	The ID of the first elf with the Min years experience
	Their shared skill
*/

with exp_by_skill as (
	-- gets min and max experience level per skill
	select
		primary_skill,
		min(years_experience) as min_experience,
		max(years_experience) as max_experience
	from workshop_elves
	group by primary_skill
),

-- find the elves with those matching min experience level
min_elfs as (
	select 
		min(elf_id) as min_elf,
		workshop_elves.primary_skill,
		workshop_elves.years_experience
	from workshop_elves
	join exp_by_skill
		on exp_by_skill.min_experience = workshop_elves.years_experience
			and exp_by_skill.primary_skill = workshop_elves.primary_skill
	group by workshop_elves.primary_skill, years_experience
),

-- find the elves with those matching max experience level
max_elfs as (
	select
		max(elf_id) as max_elf,
		workshop_elves.primary_skill,
		years_experience
	from workshop_elves
	join exp_by_skill
		on exp_by_skill.max_experience = workshop_elves.years_experience
			and exp_by_skill.primary_skill = workshop_elves.primary_skill
	group by workshop_elves.primary_skill, years_experience
)

select distinct
	max_elfs.max_elf,
	min_elfs.min_elf,
	workshop_elves.primary_skill
from workshop_elves
join max_elfs 
	on max_elfs.primary_skill = workshop_elves.primary_skill
join min_elfs
	on min_elfs.primary_skill = workshop_elves.primary_skill
order by workshop_elves.primary_skill
