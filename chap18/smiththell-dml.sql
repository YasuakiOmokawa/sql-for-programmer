create table Foobar_DML
(
  a char(1) check (a in ('T', 'F')),
  b char(1) check (b in ('T', 'F'))
);

insert into foobar_dml
values
  ('T', 'T'),
  ('T', 'F'),
  ('T', NULL),
  ('F', 'T'),
  ('F', 'F'),
  ('F', NULL),
  (null, 'T'),
  (null, 'F'),
  (null, null);

-- 検索条件にスミステルルールを使う
select
  *
from
  foobar_dml
where
  ( not (a = 'T') or (B = 'T') )
;

-- セルコオリジナルバージョンのクエリ
select *
  from foobar_dml
where
  case
    when a = 'T'
    then
      case when b = 'T'
      then 1 else 0 end
    else 1 end = 1
;


