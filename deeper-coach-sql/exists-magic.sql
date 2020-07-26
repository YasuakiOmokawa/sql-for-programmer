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

