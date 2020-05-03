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
