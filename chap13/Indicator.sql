create table Bob
(
  keycol INTEGER not null PRIMARY KEY,
  varcol INTEGER NOT NULL,
  multi_indicator INTEGER NOT NULL
    CHECK(multi_indicator in (
    0, -- 既知の値
    1, -- 適用不能
    2, -- 失われた値
    3))-- 近似値
);

-- 取り出しクエリ
SELECT
  SUM(varcol),
  (CASE when not exists (select multi_indicator
  from Bob
  where multi_indicator > 0)
  then 0
  when exists (select *
  from Bob
  where multi_indicator = 1)
  then 1
  when exists (select *
  from Bob
  where multi_indicator = 2)
  then 2
  when exists (select *
  from Bob
  where multi_indicator = 3)
  then 3
  else null end) as totals_multi_indicator
from Bob;
