{%- set state_list = ['CA', 'NJ', 'WA', 'AZ', 'CT', 'NY', 'MI', 'ME'] -%}

with dummy_states_data as (
    {% for state_abbrv in state_list -%}
    select '{{ state_abbrv }}' as state_abbrv
    {%- if loop.last -%}
    
    {% else %}
    UNION
    {% endif -%}
    {%- endfor %}
)
select * from dummy_states_data
