-- 特性関数とは、trueの場合に1、falseの場合に0を返す関数
create table Foobar_18_3
(key_col integer not null primary key,
c1 varchar(20) not null,
c2 varchar(20) not null,
c3 varchar(20) not null,
c4 varchar(20) not null,
c5 varchar(20) not null
);

-- Swap(c1, c2) and Swap(c4, c5);
update foobar_18_3
  set c1 = case when c1 <= c2 then c1 else c2 end,
  