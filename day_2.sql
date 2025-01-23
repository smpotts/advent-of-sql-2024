with clean_letters as (
	select
		*,
		chr(value) as ascii_value
	from letters_b
	where value not in (
		select distinct value
		from letters_a
	)
)

select *
from clean_letters;