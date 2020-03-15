-- correct
case
  when 1 = 1 then NULL
  else cast (null as integer)
end -- same as correct
case
  when 1 = 1 then cast (null as integer)
  else NULL
END -- incorrect, not defined data type
case
  when 1 = 1 then NULL
  else NULL
end -- depends on database implementation
cast (
  case
    when 1 = 1 then null
    else null
  end as integer
) case
  iso_sex_code
  when 0 then 'Unknown'
  when 1 then 'Male'
  when 2 then 'Female'
  when 9 then 'N/A'
  else null
end case
  foo
  when 1 then 'bar'
  when null then 'no bar'
end case
  when foo = 1 then 'bar'
  when foo = null then 'no_bar' -- it's just a problem!
  else null
end;

-- evaluate only once
begin pick_a_number integer;

pick_a_number := cast((5.0 + random()) + 1 as integer);

pick_one: = cast pick_a_number
when 1 then 'one'
when 2 then 'two'
when 3 then 'three'
when 4 then 'four'
when 5 then 'five'
else 'This should not happen'
end;

end;