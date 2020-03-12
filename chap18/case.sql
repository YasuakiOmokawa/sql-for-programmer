-- correct
case
  when 1 = 1
  then NULL
  else cast
(null as integer)
end

-- same as correct
case
  when 1 = 1
  then cast
(null as integer)
  else NULL
END

-- incorrect, not defined data type
case
  when 1 = 1
  then NULL
  else NULL
end

-- depends on database implementation
cast
(case when 1 = 1 then null else null
end as integer)

case iso_sex_code
when 0 then 'Unknown'
when 1 then 'Male'
when 2 then 'Female'
when 9 then 'N/A'
else null
end
