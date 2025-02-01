/*
	Write a query that returns the name of each child and the name and price of their gift, 
	but only for children who received gifts more expensive than the average gift price.
	The results should be ordered by the gift price in ascending order.
	
	Give the name of the child with the first gift thats higher than the average.
*/

-- if averaged by city
select *
from (
	select
		children.child_id,
		gifts.gift_id,
		children.name,
		children.age,
		children.city,
		gifts.price,
		round(avg(price) over(partition by city), 2) as avg_price_per_city
	from children 
	join gifts 
		on gifts.child_id = children.child_id
) as childrens_gifts
where price > avg_price_per_city
order by price

-- if just a general average
select 
	*
from children
join gifts
	on gifts.child_id = children.child_id
where price > (
	select 
		avg(price)
	from gifts
)
order by price

-- doing this as a join instead
select 
	*
from children
join gifts
	on gifts.child_id = children.child_id
join (
	select 
		avg(price) as avg_price
	from gifts
) as agg
on gifts.price > agg.avg_price
order by price




