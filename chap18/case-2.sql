select
  dept_nbr,
  sum(
    case
      when sex_code = 1 then 1
      else 0
    ) as males,
    sum(
      case
        when sex_code = 2 then 1
        else 0
      ) as females
      from
        Personnel
      group by
        dept_nbr;

