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
