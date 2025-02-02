/*
	Submit the date where the following total quantity of drinks were consumed:
	
	HotCocoa: 38
	PeppermintSchnapps: 298
	Eggnog: 198
*/

select *
from (
	select
		date,
		sum(case when drink_name = 'Peppermint Schnapps' then quantity end) as peppermint_schnapps_count,
		sum(case when drink_name = 'Hot Cocoa' then quantity end) as hot_cocoa_count,
		sum(case when drink_name = 'Eggnog' then quantity end) eggnog_count
	from drinks
	group by date
	order by date
) as sub
where peppermint_schnapps_count = 298
	and hot_cocoa_count = 38
	and eggnog_count = 198

