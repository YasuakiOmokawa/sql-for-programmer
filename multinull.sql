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
  approximate_cnt, -- 近似値の数
  approx_1_cnt,
  approx_5_cnt,
  approx_25_cnt,
  approx_big_cnt
)
as
