-- Deals have a project start date if the contract is sent, so the project start date IS NOT NULL if pipeline stage >= contract sent.
-- Therefore return records where this isn't true to make the test fail.
select
    deal_name,
    deal_owner,
    pipeline_stage,
    project_start_date
from {{ ref('deals_analysis') }}
where pipeline_stage in ('Contract Sent', 'Negotiation', 'Closed Won')
and project_start_date is null