/*
    Create a list of all the domains that exist in the contacts list emails.
    Submit the domain names with the most emails.

    TODO:
    - need to expand out the array
    - get a distinct email domain list
*/

with expanded_emails as (
        select
            id as contact_id,
            name,
            unnest(email_addresses) as email
        from contact_list
)

select
	split_part(email, '@', 2) AS email_domain,
	count(*) as contact_count
from expanded_emails
group by 1
order by count(*) desc




