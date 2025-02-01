/*
	We want to find out how many managers the most over-managed employee has (levels deep).
	
	To do this, you're going to need to go through all the employees and find out who their manager is, 
	and who their manger is, and who their manger is... you see where this is going
	
	You need to produce a report that calculates this management depth for all employees
	
	Order it by the number of levels in descending order.
*/
with recursive employee_hierarchy as (
    -- base case: where manager id is null
	select
		staff_id,
		staff_name,
		manager_id,
		1 as hierarchy_level -- top level starts at 1
	from staff
	where manager_id is null

	union all
	
	-- recursive query:
	select
		emp.staff_id,
		emp.staff_name,
		emp.manager_id,
		mngr.hierarchy_level + 1 as hierarchy_level
	from staff as emp
	join employee_hierarchy as mngr
		on mngr.staff_id = emp.manager_id
)

select
	staff_id,
	staff_name,
	staff_id,
	hierarchy_level
from employee_hierarchy
order by hierarchy_level desc
