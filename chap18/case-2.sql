select
	dept_nbr,
	sum( case when sex_code = 1 then 1 else 0 ) as males,
	sum( case when sex_code = 2 then 1 else 0 ) as females
from
	Personnel
group by
	dept_nbr;

create table
	PersonnelSkills ( esp_id char(11) not null,
	skill_code char(11) not null,
	primary_skill_flg char(1) not null constraint primary_skill_given check (primary_skill_flg in ('Y',
	'N')),
	primary key (esp_id,
	skill_code) );

-- Show personSkill
 select
	esp_id,
	case
		when count(*) = 1 then max(skill_code)
		else max( case when primary_skill_flg = 'Y' then skill_code end )
	end as main_skill
from
	PersonnelSkills
group by
	esp_id;

-- Convert True or False
 constraint implication_example check(
case
	when dept_nbr = 'D1' then
	case
		when salary < 44000.00 then 'T'
		else 'F'
	end
	else 'F'
end = 'T' );


-- スミステルルール
 create table
	Foobar_DDL_1 ( a char(1) check (a in ('T',
	'F')),
	b char(1) check (b in ('T',
	'F')),
	constraint implication_example check (not (A = 'T')
	or (B = 'T')) );
