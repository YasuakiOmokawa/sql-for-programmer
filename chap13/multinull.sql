create table MultiNull
(
  groupcol integer not null,
  keycol INTEGER not null,
  valcol INTEGER not null check(valcol >= 0),
  valcol_null INTEGER not null DEFAULT 0
    check(valcol_null in
    (
      0, -- 既知の値
      1, -- 適用不能
      2, -- 失われているが適用可能
      3, -- 1%以内の近似
      4, -- 5%以内の近似
      5, -- 25%以内の近似
      6  -- 25%を超える近似
    )),
  PRIMARY KEY (groupcol, keycol),
  check(valcol = 0 or valcol_null not in (1,2))
);

CREATE view Group_MultiNull
(
  groupcol,
  valcol_sum,
  valcol_avg,
  valcol_max,
  valcol_min,
  row_cnt,
  notnull_cnt,
  na_cnt,
  missing_cnt,
  -- 近似値の数
  approximate_cnt,
  approx_1_cnt,
  approx_5_cnt,
  approx_25_cnt,
  approx_big_cnt
)
as
  select
    groupcol,
    sum(valcol),
    avg(valcol),
    max(valcol),
    min(valcol),
    count(*),
    sum(case when valcol_null = 0 then 1 else 0 end) as notnull_cnt,
    sum(case when valcol_null = 1 then 1 else 0 end) as na_cnt,
    sum(case when valcol_null = 2 then 1 else 0 end) as missing_cnt,
    sum(case when valcol_null in (3,4,5,6) then 1 else 0 end) as approximate_cnt,
    sum(case when valcol_null = 3 then 1 else 0 end) as approx_1_cnt,
    sum(case when valcol_null = 4 then 1 else 0 end) as approx_5_cnt,
    sum(case when valcol_null = 5 then 1 else 0 end) as approx_25_cnt,
    sum(case when valcol_null = 6 then 1 else 0 end) as approx_big_cnt
  from MultiNull
  group by groupcol;


SELECT
  groupcol,
  valcol_sum,
  valcol_avg,
  valcol_max,
  valcol_min,
  (case when row_cnt = notnull_cnt
        then 'All are known'
        else 'Not all are known'
        end) as warning_message,
  row_cnt,
  notnull_cnt,
  na_cnt,
  missing_cnt,
  approximate_cnt,
  approx_1_cnt,
  approx_5_cnt,
  approx_25_cnt,
  approx_big_cnt
from Group_MultiNull;
