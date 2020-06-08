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

-- CHECK CONDITION IF test TABLE
drop table testsal;
CREATE TABLE TestSal
(sex char(1),
salary integer,
  CONSTRAINT check_salary CHECK
    ( CASE WHEN sex = '2'
           THEN CASE WHEN salary <= 200000
                THEN 1 ELSE 0 END
           ELSE 1 END = 1))
;
delete from testsal;
INSERT INTO TestSal VALUES
  (1, 200000)
 ,(1, 300000)
 ,(1, null)
 ,(2, 20000)
 ,(1, 300000)
;
-- error
INSERT INTO TestSal VALUES(2, 300000);
INSERT INTO TestSal VALUES(2, null);

-- update table with complicated condition
DROP TABLE personnel;
CREATE TABLE personnel
(
  name varchar(32),
  salary integer
);
DELETE FROM personnel;
INSERT INTO personnel VALUES
  ('相田', 270000)
 ,('神崎', 324000)
 ,('木村', 220000)
 ,('斉藤', 290000)
;
select * from personnel;
update personnel
set salary = case when salary >= 300000
             then salary * 0.9
             when salary >= 250000 and salary < 280000
             then salary * 1.2
             else salary end
;

-- Update table on complicated condition 2
drop table SomeTable;
CREATE TABLE SomeTable
(p_key CHAR(1) PRIMARY KEY,
 col_1 INTEGER NOT NULL, 
 col_2 CHAR(2) NOT NULL)
;
insert into SomeTable values
  ('a', '1', 'あ')
 ,('b', '2', 'い')
 ,('c', '3', 'う')
;
select * from sometable;
-- do not success on MySQL!
update sometable
  set p_key = case when p_key = 'a' then 'b'
                   when p_key = 'b' then 'a'
                   else p_key end
where p_key in ('a', 'b')
;

-- テーブル同士のマッチング
create table coursemaster
(course_id integer primary key,
 course_name varchar(32) not null
);
insert into coursemaster values
 (1, '経理入門')
,(2, '財務知識')
,(3, '簿記検定')
,(4, '税理士')
;
select * from coursemaster;
create table opencourses
(
  month integer,
  course_id integer,
  primary key(month, course_id)
);
select * from opencourses o2 ;
insert into opencourses values
  (200706, 1)
 ,(200706, 3)
 ,(200706, 4)
 ,(200707, 4)
 ,(200708, 2)
 ,(200708, 4)
;
-- matching table using exists
select cm.course_name,
  case when exists
    (select course_id from opencourses oc
      where month = 200706 and oc.course_id = cm.course_id) then '○'
    else '×' end as "6月",
  case when exists
    (select course_id from opencourses oc
      where month = 200707 and oc.course_id = cm.course_id) then '○'
    else '×' end as "7月",
  case when exists 
    (select course_id from opencourses oc
      where month = 200708 and oc.course_id = cm.course_id) then '○'
    else '×' end as "8月" 
from coursemaster cm
;

-- use case statement in grouping statement
CREATE TABLE StudentClub
(std_id  INTEGER,
 club_id INTEGER,
 club_name VARCHAR(32),
 main_club_flg CHAR(1),
 PRIMARY KEY (std_id, club_id));
INSERT INTO StudentClub VALUES(100, 1, '野球',        'Y');
INSERT INTO StudentClub VALUES(100, 2, '吹奏楽',      'N');
INSERT INTO StudentClub VALUES(200, 2, '吹奏楽',      'N');
INSERT INTO StudentClub VALUES(200, 3, 'バドミントン','Y');
INSERT INTO StudentClub VALUES(200, 4, 'サッカー',    'N');
INSERT INTO StudentClub VALUES(300, 4, 'サッカー',    'N');
INSERT INTO StudentClub VALUES(400, 5, '水泳',        'N');
INSERT INTO StudentClub VALUES(500, 6, '囲碁',        'N');
INSERT INTO StudentClub VALUES(500, 7, '将棋',        'N');
select * from studentclub s ;
-- grouping match in case statement
select std_id,
  case when count(*) = 1 then max(club_id) -- only have primary club
       else max(case when main_club_flg = 'Y' then club_id else null end)
       end as main_club
from studentclub
group by std_id
;

-- training 1-1. max value in multipul column
create table greatests
(id CHAR(1), x integer, y integer, z integer, primary key(id));
insert into greatests values('A', 1, 2, 3);
insert into greatests values('B', 5, 5, 2);
insert into greatests values('C', 4, 7, 1);
insert into greatests values('D', 3, 3, 8);
delete from greatests;
select * from greatests;
-- in 2 columns
select
  id,
  case when x >= y then x else y end as greatest
from greatests
;
-- in 3 columns with between
select
  id,
  case
  when x between y and z then z
  when y between x and z then z
  when z between x and y then y
  when x between z and y then y
  else x end as greatest
from greatests
;
-- in 3 columns with nested case
select
  id,
  case when case when x < y then y else x end < z then z
       else case when x < y then y else x end
  end as greatest
from greatests;
-- using max() with horizonally
select
  id,
  max(col) as greatest
from
  (select id, x as col from greatests
   union all
   select id, y as col from greatests
   union all
   select id, z as col from greatests) tmp
group by
  id
;

-- exercise 1-2. convert row to column to show sum and review on the top
select
    case when sex = '1' then '男' else '女' end as 性別
    ,sum(case when pref_name = '徳島' then population else 0 end) as 徳島
    ,sum(case when pref_name = '香川' then population else 0 end) as 香川
    ,sum(case when pref_name = '愛媛' then population else 0 end) as 愛媛
    ,sum(case when pref_name = '高知' then population else 0 end) as 高知
    ,sum(
        case when pref_name = '徳島' then population
             when pref_name = '香川' then population
             when pref_name = '愛媛' then population
             when pref_name = '高知' then population
             else 0 end) as 四国
    ,sum(population) as すべて
from
    poptbl2
group by
    sex
order by
    sex
;




