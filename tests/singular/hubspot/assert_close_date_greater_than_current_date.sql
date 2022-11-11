-- Deals have a project start date if the contract is sent, so the project start date IS NOT NULL if pipeline stage >= contract sent.
-- Therefore return records where this isn't true to make the test fail.
select
    deal_name,
    DEAL_OWNER,
    close_date
from {{ ref('deals_analysis') }}
where pipeline_stage in ('Qualified','Proposal','Contract Sent', 'Negotiation')
having close_date < current_date