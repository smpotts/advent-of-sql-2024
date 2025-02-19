/*
Mrs. Claus needs to find the receipt for Santa's green suit that was dry cleaned.
She needs to know when it was dropped off, so submit the drop off date.
Order by the latest drop off date

-- Here's the record with the green suit
INSERT INTO SantaRecords (record_id, record_date, cleaning_receipts) VALUES 
(3, '2024-12-10', '[
    {
        "receipt_id": "R124",
        "garment": "suit",
        "color": "green",
        "cost": 29.99,
        "drop_off": "2024-12-10",
        "pickup": "2024-12-12"
    },
    {
        "receipt_id": "R125",
        "garment": "scarf",
        "color": "green",
        "cost": 10.99,
        "drop_off": "2024-12-10",
        "pickup": "2024-12-12"
    }
]')

*/
select 
	*
from (
	select
		record_id,
		record_date,
		receipts->>'color' as color,
		receipts->>'garment' as garment,
		receipts->>'drop_off' as drop_off
	from santarecords,
	lateral jsonb_array_elements(cleaning_receipts) as receipts
) as sub
where garment = 'suit'
	and color = 'green'
order by drop_off desc












