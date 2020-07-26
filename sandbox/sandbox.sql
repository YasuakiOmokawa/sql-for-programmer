select version ();

-- Sandbox in exercise-db

-- Calc diff set using left join and is null
-- no diff
select
  with_alias.district
  , with_alias.total
from (
  select
    case pref_name
      when '徳島' then '四国'
      when '香川' then '四国'
      when '愛媛' then '四国'
      when '高知' then '四国'
      when '福岡' then '九州'
      when '佐賀' then '九州'
      when '長崎' then '九州'
      else 'その他' end as district,
    sum(population) as total
  from poptbl
  group by district ) as with_alias
  left join (
    select
      case pref_name
        when '徳島' then '四国'
        when '香川' then '四国'
        when '愛媛' then '四国'
        when '高知' then '四国'
        when '福岡' then '九州'
        when '佐賀' then '九州'
        when '長崎' then '九州'
        else 'その他' end as district,
      sum(population) as total
    from poptbl
    group by
      case pref_name
        when '徳島' then '四国'
        when '香川' then '四国'
        when '愛媛' then '四国'
        when '高知' then '四国'
        when '福岡' then '九州'
        when '佐賀' then '九州'
        when '長崎' then '九州'
        else 'その他' end ) as no_alias
  on with_alias.district = no_alias.district
where
  no_alias.district is null
;