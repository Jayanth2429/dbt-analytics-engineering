{% macro cms_null(column_name) -%}
nullif(
  nullif(
    nullif(trim(cast({{ column_name }} as varchar)), ''),
    'Not Available'
  ),
  'N/A'
)
{%- endmacro %}

{% macro cms_number(column_name) -%}
try_cast({{ cms_null(column_name) }} as double)
{%- endmacro %}

{% macro cms_integer(column_name) -%}
try_cast({{ cms_null(column_name) }} as bigint)
{%- endmacro %}

{% macro cms_date(column_name) -%}
try_strptime({{ cms_null(column_name) }}, '%m/%d/%Y')::date
{%- endmacro %}
