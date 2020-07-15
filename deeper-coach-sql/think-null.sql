CREATE TABLE Class_A
(name CHAR(16) PRIMARY KEY,
 age INTEGER,
 city CHAR(16));

CREATE TABLE Class_B
(name CHAR(16) PRIMARY KEY,
 age INTEGER,
 city CHAR(16));

INSERT INTO class_a VALUES('ブラウン',  22, '東京');
INSERT INTO class_a VALUES('ラリー',  19, '埼玉');
INSERT INTO class_a VALUES('ボギー',  21, '千葉');

INSERT INTO class_b VALUES('斎藤',  22, '東京');
INSERT INTO class_b VALUES('田尻',  23, '東京');
INSERT INTO class_b VALUES('山田',  20, '東京');
INSERT INTO class_b VALUES('和泉',  18, '千葉');
INSERT INTO class_b VALUES('武田',  20, '千葉');
INSERT INTO class_b VALUES('石川',  19, '神奈川');

select * from class_a;
select * from class_b;

-- Choose student youngest than class_b in Tokyo city
select
  *
from 
  class_a
where age < all(select 
                  age
                from 
                  class_b 
                where 
                  city = '東京');

                