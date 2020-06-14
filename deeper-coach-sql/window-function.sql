-- sample window function
CREATE TABLE sales_items
(id     CHAR(4) NOT NULL,
 name    VARCHAR(100) NOT NULL,
 category VARCHAR(32) NOT NULL,
 selling_price  INTEGER ,
 purchase_price  INTEGER ,
 created_at      DATE ,
     PRIMARY KEY (id));

INSERT INTO sales_items VALUES ('0001', 'Tシャツ' ,'衣服', 1000, 500, '2009-09-20');
INSERT INTO sales_items VALUES ('0002', '穴あけパンチ', '事務用品', 500, 320, '2009-09-11');
INSERT INTO sales_items VALUES ('0003', 'カッターシャツ', '衣服', 4000, 2800, NULL);
INSERT INTO sales_items VALUES ('0004', '包丁', 'キッチン用品', 3000, 2800, '2009-09-20');
INSERT INTO sales_items VALUES ('0005', '圧力鍋', 'キッチン用品', 6800, 5000, '2009-01-15');
INSERT INTO sales_items VALUES ('0006', 'フォーク', 'キッチン用品', 500, NULL, '2009-09-20');
INSERT INTO sales_items VALUES ('0007', 'おろしがね', 'キッチン用品', 880, 790, '2008-04-28');
INSERT INTO sales_items VALUES ('0008', 'ボールペン', '事務用品', 100, NULL, '2009-11-11');

select * from sales_items;

-- Calc moving average of selling price in time line about item id asc
-- between current row and two precending one.
select
  id
  , name
  , selling_price
  , avg (selling_price) over (
    order by id
    rows between 2 preceding and current row) as moving_avg
from
  sales_items;

-- same as above one but define window
select
  id
  , name
  , selling_price
  , avg(selling_price) over w as moving_avg
from
  sales_items
window w as (
  order by id rows between 2 preceding and current row )
;

-- Load data that is sample of time line 
CREATE TABLE LoadSample
(sample_date   DATE PRIMARY KEY,
 load_val      INTEGER NOT NULL);

INSERT INTO LoadSample VALUES('2018-02-01',   1024);
INSERT INTO LoadSample VALUES('2018-02-02',   2366);
INSERT INTO LoadSample VALUES('2018-02-05',   2366);
INSERT INTO LoadSample VALUES('2018-02-07',    985);
INSERT INTO LoadSample VALUES('2018-02-08',    780);
INSERT INTO LoadSample VALUES('2018-02-12',   1000);

select * from loadsample;

select sample_date as cur_date, 
