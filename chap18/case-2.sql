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

create table PersonnelSkills (
  esp_id char(11) not null,
  skill_code char(11) not null,
  primary_skill_flg char(1) not null constraint primary_skill_given check (primary_skill_flg in ('Y', 'N')),
  primary key (esp_id, skill_code)
);