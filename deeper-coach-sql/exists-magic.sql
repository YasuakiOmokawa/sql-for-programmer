-- Search not exists record in table
CREATE TABLE Meetings
(meeting CHAR(32) NOT NULL,
 person  CHAR(32) NOT NULL,
 PRIMARY KEY (meeting, person));

INSERT INTO Meetings VALUES('第１回', '伊藤');
INSERT INTO Meetings VALUES('第１回', '水島');
INSERT INTO Meetings VALUES('第１回', '坂東');
INSERT INTO Meetings VALUES('第２回', '伊藤');
INSERT INTO Meetings VALUES('第２回', '宮田');
INSERT INTO Meetings VALUES('第３回', '坂東');
INSERT INTO Meetings VALUES('第３回', '水島');
INSERT INTO Meetings VALUES('第３回', '宮田');

select count(*) from meetings m ;
select * from meetings m ;

-- all people presences meetings
select distinct m1.meeting, m2.person
from meetings m1 cross join meetings m2;

-- search absences meetings
select
  distinct m1.meeting
  , m2.person
from
  meetings m1 cross join meetings m2
where 
  not exists 
    (
      select
        *
      from 
        meetings m3 
      where
        m1.meeting = m3.meeting
        and m2.person = m3.person 
    )
;

-- search absences in meetings ptn.2: use diff group
-- Enable for PostgreSQL, Oracle
select 
  m1.meeting,
  m2.person
from 
  meetings m1,
  meetings m2
except
  select meeting, person 
  from meetings
;

-- Get used about conversion con <-> nothing doing
CREATE TABLE TestScores
(student_id INTEGER,
 subject    VARCHAR(32) ,
 score      INTEGER,
  PRIMARY KEY(student_id, subject));

INSERT INTO TestScores VALUES(100, '算数',100);
INSERT INTO TestScores VALUES(100, '国語',80);
INSERT INTO TestScores VALUES(100, '理科',80);
INSERT INTO TestScores VALUES(200, '算数',80);
INSERT INTO TestScores VALUES(200, '国語',95);
INSERT INTO TestScores VALUES(300, '算数',40);
INSERT INTO TestScores VALUES(300, '国語',90);
INSERT INTO TestScores VALUES(300, '社会',55);
INSERT INTO TestScores VALUES(400, '算数',80);

-- query 1
select * from testscores ;

select
  distinct student_id
from
  testscores ts1
where
  not exists (
  select
    *
  from
    testscores ts2
  where
    ts2.student_id = ts1.student_id
    and ts2.score < 50 )
;


-- query 2
 select
  distinct student_id
from
  testscores ts1
where
  subject in ('国語', '算数')
  and not exists (
  select
    *
  from
    testscores ts2
  where
    ts2.student_id = ts1.student_id
    and 1 =
    case
      when ts2.subject = '算数' and ts2.score < 80 then 1
      when ts2.subject = '国語' and ts2.score < 50 then 1
      else 0 end )
;

-- Remove id 400 by count multi row
select
  student_id
from
  testscores ts1
where
  subject in ('算数', '国語')
  and not exists (
    select
      *
    from
      testscores ts2
    where
      ts2.student_id = ts1.student_id
      and 1 =
      case
        when subject = '算数' and score < 80 then 1
        when subject = '国語' and score < 50 then 1
        else 0 end )
group by
  student_id
having
  count(*) = 2
;

-- group vs pronunce - which is greater ?
CREATE TABLE Projects
(project_id VARCHAR(32),
 step_nbr   INTEGER ,
 status     VARCHAR(32),
  PRIMARY KEY(project_id, step_nbr));

INSERT INTO Projects VALUES('AA100', 0, '完了');
INSERT INTO Projects VALUES('AA100', 1, '待機');
INSERT INTO Projects VALUES('AA100', 2, '待機');
INSERT INTO Projects VALUES('B200',  0, '待機');
INSERT INTO Projects VALUES('B200',  1, '待機');
INSERT INTO Projects VALUES('CS300', 0, '完了');
INSERT INTO Projects VALUES('CS300', 1, '完了');
INSERT INTO Projects VALUES('CS300', 2, '待機');
INSERT INTO Projects VALUES('CS300', 3, '待機');
INSERT INTO Projects VALUES('DY400', 0, '完了');
INSERT INTO Projects VALUES('DY400', 1, '完了');
INSERT INTO Projects VALUES('DY400', 2, '完了');

select * from projects;
select count(*) from projects;

-- the way of serko
select
  project_id
from
  projects
group by
  project_id
having
  count(*) = sum(case when step_nbr <= 1 and status = '完了' then 1 when step_nbr > 1 and status = '待機' then 1 else 0 end);

-- universal proposition
/* step_status = case when step_nbr <= 1
              then '完了'
              else '待機' end
*/

-- using universal proposition
-- 直感的ではないものの、こちらのほうがパフォーマンスがいい。
--   1. 結合条件でproject_id列のインデックスが使える
--   2. 1行でも条件を満たさない行があれば検索を打ち切ることができる
select
  *
from
  projects p1
where
  not exists (
    select
      status
    from
      projects p2
    where
      p1.project_id = p2.project_id -- プロジェクトごとに条件を調べる
      -- 全称文を二重否定で表現
      and status <>
      case
        when step_nbr <= 1 then '完了'
        else '待機' end);


-- 列に対する量化
/* 列に対する量化：オール１の行を探せ */
CREATE TABLE ArrayTbl
 (keycol CHAR(1) PRIMARY KEY,
  col1  INTEGER,
  col2  INTEGER,
  col3  INTEGER,
  col4  INTEGER,
  col5  INTEGER,
  col6  INTEGER,
  col7  INTEGER,
  col8  INTEGER,
  col9  INTEGER,
  col10 INTEGER);

--オールNULL
INSERT INTO ArrayTbl VALUES('A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ArrayTbl VALUES('B', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
--オール1
INSERT INTO ArrayTbl VALUES('C', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
--少なくとも一つは9
INSERT INTO ArrayTbl VALUES('D', NULL, NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ArrayTbl VALUES('E', NULL, 3, NULL, 1, 9, NULL, NULL, 9, NULL, NULL);

select * from arraytbl;

-- 全部１
select * 
from arraytbl 
where 1 = all(array[col1, col2, col3, col4, col5, col6, col7, col8, col9, col10]);

-- 少なくとも１つは9 - any
select * 
from arraytbl 
where 9 = any(array[col1, col2, col3, col4, col5, col6, col7, col8, col9, col10]);

-- 少なくとも１つは9 - in
select * 
from arraytbl 
where 9 in (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10);

-- 演習1
drop table arraytbl2;
CREATE TABLE ArrayTbl2
 (keycol CHAR(1),
  i  INTEGER,
  val  INTEGER,
  PRIMARY KEY(keycol, i));

INSERT INTO ArrayTbl2 VALUES('A',1,null);
INSERT INTO ArrayTbl2 VALUES('A',2,null);
INSERT INTO ArrayTbl2 VALUES('A',3,null);
INSERT INTO ArrayTbl2 VALUES('A',4,null);
INSERT INTO ArrayTbl2 VALUES('A',5,null);
INSERT INTO ArrayTbl2 VALUES('A',6,null);
INSERT INTO ArrayTbl2 VALUES('A',7,null);
INSERT INTO ArrayTbl2 VALUES('A',8,null);
INSERT INTO ArrayTbl2 VALUES('A',9,null);
INSERT INTO ArrayTbl2 VALUES('A',10,null);
INSERT INTO ArrayTbl2 VALUES('B',1,3);
INSERT INTO ArrayTbl2 VALUES('B',2,null);
INSERT INTO ArrayTbl2 VALUES('B',3,null);
INSERT INTO ArrayTbl2 VALUES('B',4,null);
INSERT INTO ArrayTbl2 VALUES('B',5,null);
INSERT INTO ArrayTbl2 VALUES('B',6,null);
INSERT INTO ArrayTbl2 VALUES('B',7,null);
INSERT INTO ArrayTbl2 VALUES('B',8,null);
INSERT INTO ArrayTbl2 VALUES('B',9,null);
INSERT INTO ArrayTbl2 VALUES('B',10,null);
INSERT INTO ArrayTbl2 VALUES('C',1,1);
INSERT INTO ArrayTbl2 VALUES('C',2,1);
INSERT INTO ArrayTbl2 VALUES('C',3,1);
INSERT INTO ArrayTbl2 VALUES('C',4,1);
INSERT INTO ArrayTbl2 VALUES('C',5,1);
INSERT INTO ArrayTbl2 VALUES('C',6,1);
INSERT INTO ArrayTbl2 VALUES('C',7,1);
INSERT INTO ArrayTbl2 VALUES('C',8,1);
INSERT INTO ArrayTbl2 VALUES('C',9,1);
INSERT INTO ArrayTbl2 VALUES('C',10,1);

select * from arraytbl2 ;











