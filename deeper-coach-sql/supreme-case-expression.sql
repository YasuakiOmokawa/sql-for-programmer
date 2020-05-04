-- Convert new code detection and summarize
DROP TABLE poptbl;
CREATE TABLE PopTbl (
  pref_name VARCHAR(32) PRIMARY KEY,
  population INTEGER NOT NULL
);

delete from poptbl;
select * from poptbl;
INSERT INTO
  PopTbl
VALUES
  ('徳島', 100)
  ,('香川', 200)
  ,('愛媛', 150)
  ,('高知', 200)
  ,('福岡', 300)
  ,('佐賀', 100)
  ,('長崎', 200)
  ,('東京', 400)
  ,('群馬', 500)
;

-- summarize
select
  case pref_name
    when '徳島' then '四国'
    when '香川' then '四国'
    when '愛媛' then '四国'
    when '高知' then '四国'
    when '福岡' then '九州'
    when '佐賀' then '九州'
    when '長崎' then '九州'
    else 'その他' end as district,
  sum(population)
from poptbl
group by district
;

-- Calculate single query on several condition
DROP TABLE poptbl2;
CREATE TABLE PopTbl2 (
  pref_name VARCHAR(32),
  sex char(1) not null,
  population INTEGER NOT null,
  primary key(pref_name, sex)
);

delete from poptbl2;
select * from poptbl2;
INSERT INTO
  PopTbl2
VALUES
  ('徳島', '1', 60)
  ,('徳島', '2', 40)
  ,('香川', '1', 100)
  ,('香川', '2', 100)
  ,('愛媛', '1', 100)
  ,('愛媛', '2', 50)
  ,('高知', '1', 100)
  ,('高知', '2', 100)
  ,('福岡', '1', 100)
  ,('福岡', '2', 200)
  ,('佐賀', '1', 20)
  ,('佐賀', '2', 80)
  ,('長崎', '1', 150)
  ,('長崎', '2', 50)
  ,('東京', '1', 210)
  ,('東京', '2', 190)
  ,('群馬', '1', 240)
  ,('群馬', '2', 260)
;

-- summarize
select
  pref_name
  -- population of man
  ,sum(case when sex = '1' then population else 0 end) as cnt_m
  -- case of female
  ,sum(case when sex = '2' then population else 0 end) as cnt_f
from
  poptbl2
group by
  pref_name
;
