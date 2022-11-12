-- Deals have a non-null amount if they are beyond the identified pipeline stage, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail.
select
    deal_name,
    deal_owner,
    sum(amount) as total_amount
from {{ ref('deals_analysis') }}
where pipeline_stage NOT IN ('Identified', 'Closed Lost')
group by 1,2
having not(total_amount is not null)