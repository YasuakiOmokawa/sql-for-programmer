-- 特性関数とは、trueの場合に1、falseの場合に0を返す関数
create table Foobar_18_3
(key_col integer not null primary key,
c1 varchar(20) not null,
c2 varchar(20) not null,
c3 varchar(20) not null,
c4 varchar(20) not null,
c5 varchar(20) not null
);

delete from foobar_18_3;
insert into
  foobar_18_3
values
  (1, 'A', 'B', 'C', 'D', 'E')
  ,(2, 'E', 'D', 'C', 'B', 'A')
  ,(3, 'D', 'E', 'C', 'A', 'B')
;
select * from foobar_18_3;

-- Swap(c1, c2) and Swap(c4, c5) order by asc;
update
  foobar_18_3 f1,
  foobar_18_3 f2
set
  f1.c1 = case when f1.c1 <= f1.c2 then f1.c1 else f1.c2 end,
  f2.c2 = case when f2.c1 <= f2.c2 then f2.c2 else f2.c1 end,
  f1.c4 = case when f1.c4 <= f1.c5 then f1.c4 else f1.c5 end,
  f2.c5 = case when f2.c4 <= f2.c5 then f2.c5 else f2.c4 end
where
  f1.c4 > f1.c5 or f1.c1 > f1.c2
;

-- In PostgreSQL
select 
  case when c1 <= c2 then c1 else c2 end as c1
--  f2.c2 = case when f2.c1 <= f2.c2 then f2.c2 else f2.c1 end,
--  f1.c4 = case when f1.c4 <= f1.c5 then f1.c4 else f1.c5 end,
--  f2.c5 = case when f2.c4 <= f2.c5 then f2.c5 else f2.c4 end
from
  foobar_18_3
where
  c4 > c5 or c1 > c2
;


-- swap(c1, c2)
update
  foobar_18_3
set
  c1 = c2, c2 = c1
 where
   c1 > c2
;

-- swap(x, y) and swap(x, z)
create table Foobar_18_3_xyz
(key_col integer not null primary key,
x varchar(20) not null,
y varchar(20) not null,
z varchar(20) not null
);

delete from foobar_18_3_xyz;
insert into
  foobar_18_3_xyz
values
  (1, 'A', 'B', 'C')
  ,(2, 'E', 'D', 'C')
  ,(3, 'D', 'E', 'C')
  ,(4, 'A', 'C', 'B')
;

select * from foobar_18_3_xyz;

-- Success in PostgreSQL
select
  key_col 
  , case when x between y and z then y
    when z between y and x then y
    when y between z and x then z
    when x between z and y then z
    else x end as x
  , case
    when x between y and z then x
    when x between z and y then x
    when z between x and y then z
    else y end as y
  , case
    when x between z and y then y
    when z between x and y then y
    when y between z and x then x
    when z between y and x then x
    else z end as z
from 
  foobar_18_3_xyz
order by 1
;

-- Success in MySQL
update
  foobar_18_3_xyz f1,
  foobar_18_3_xyz f2,
  foobar_18_3_xyz f3
set
  f1.x  = case
          when f1.x between f1.y and f1.z then f1.y
          when f1.z between f1.y and f1.x then f1.y
          when f1.y between f1.z and f1.x then f1.z
          when f1.x between f1.z and f1.y then f1.z
          else f1.x end,
  f2.y = case
          when f2.x between f2.y and f2.z then f2.x
          when f2.x between f2.z and f2.y then f2.x
          when f2.z between f2.x and f2.y then f2.z
          else f2.y end,
  f3.z = case
          when f3.x between f3.z and f3.y then f3.y
          when f3.z between f3.x and f3.y then f3.y
          when f3.y between f3.z and f3.x then f3.x
          when f3.z between f3.y and f3.x then f3.x
          else f3.z end
;
