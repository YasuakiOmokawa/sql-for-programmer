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
  ,(3, 'D', 'E', 'C', 'B', 'A')
;
select * from foobar_18_3;
-- Swap(c1, c2) and Swap(c4, c5);
update
  foobar_18_3
set
  c1 = case when c1 <= c2 then c1 else c2 end,
  c2 = case when c1 <= c2 then c2 else c1 end
--   c4 = case when c4 <= c5 then c4 else c5 end,
--   c5 = case when c4 <= c5 then c5 else c4 end
where
  c4 > c5 or c1 > c2
;

-- swap(c1, c2)
update
  foobar_18_3
set
  c1 = c2, c2 = c1
-- where
--   c1 > c2
;