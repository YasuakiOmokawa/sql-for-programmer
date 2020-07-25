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

