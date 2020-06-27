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
drop table loadsample;
CREATE TABLE LoadSample
(sample_date   DATE PRIMARY KEY,
 load_val      INTEGER NOT NULL);

INSERT INTO LoadSample VALUES('2018-02-08',    780);
INSERT INTO LoadSample VALUES('2018-02-02',   2366);
INSERT INTO LoadSample VALUES('2018-02-05',   2366);
INSERT INTO LoadSample VALUES('2018-02-12',   1000);
INSERT INTO LoadSample VALUES('2018-02-07',    985);
INSERT INTO LoadSample VALUES('2018-02-01',   1024);

select * from loadsample;
select * from loadsample order by 2;

-- Calc 1 day before current row date
select
  sample_date as cur_date
  , min(sample_date) over (
      order by sample_date asc
      rows between 1 preceding and 1 preceding) as latest_date
from
  loadsample;

-- Calc current load and latest one
select 
  sample_date as cur_date
  , min(sample_date) over (
      order by sample_date asc
      rows between 1 preceding and 1 preceding) as latest_date
  , load_val as cur_load
  , min(load_val) over(
    order by sample_date asc
    rows between 1 preceding and 1 preceding) as latest_load
from 
  loadsample
;

-- Calc current load and diff of latest one
select 
  sample_date as cur_date
  , min(sample_date) over w as latest_date
  , sample_date - min(sample_date) over w as diff_date
  , load_val as cur_load
  , min(load_val) over w as latest_load
  , load_val - min(load_val) over w as diff_load
from
  loadsample
window w as (
  order by sample_date asc
  rows between 1 preceding and 1 preceding )
order by 1 asc
;

-- Test follow frame
select 
  sample_date as cur_date
  , min(sample_date) over w as next_date
  , load_val as cur_load
  , min(load_val) over w as next_load
  , min(load_val) over w - load_val as diff_load
  , min(sample_date) over w - sample_date as diff_date
from
  loadsample
window w as (
  order by sample_date asc
  rows between 1 following and 1 following)
order by 1 asc
;

-- Range frame
-- Calc Interval 1 day before
select 
  sample_date as cur_date
  , min(sample_date) over w_1day_before as 1day_before
  , load_val as cur_load
  , min(load_val) over w_1day_before as load_1day_before
from
  loadsample
window w_1day_before as (
  order by sample_date asc
  range between interval '1' day preceding and interval '1' day preceding)
order by 1 asc
;

-- Generalize diff rows
select 
  sample_date as cur_date,
  min(sample_date) over (
    order by sample_date asc 
    rows between 1 preceding and 1 preceding ) as latest_1,
  min(sample_date) over (
    order by sample_date asc 
    rows between 2 preceding and 2 preceding ) as latest_2,
  min(sample_date) over ( 
    order by sample_date asc 
    rows between 3 preceding and 3 preceding ) as latest_3
from 
  loadsample;

-- Inner algorithm of window function
--   1. cutting record group with partition by
--   2. ordering group with order by
--   3. create subset around current record with frame

-- exercise 2-1. Predicate result of window function
drop table Serverloadsample;
CREATE TABLE ServerLoadSample(
 server        char(1) not null,
 sample_date   DATE not null,
 load_val      INTEGER not null,
 primary key(server, sample_date)
);
INSERT INTO ServerLoadSample VALUES('A', '2018-02-01', 1024);
INSERT INTO ServerLoadSample VALUES('A', '2018-02-02', 2366);
INSERT INTO ServerLoadSample VALUES('A', '2018-02-05', 2366);
INSERT INTO ServerLoadSample VALUES('A', '2018-02-07', 985);
INSERT INTO ServerLoadSample VALUES('A', '2018-02-08', 780);
INSERT INTO ServerLoadSample VALUES('A', '2018-02-12', 1000);
INSERT INTO ServerLoadSample VALUES('B', '2018-02-01', 54);
INSERT INTO ServerLoadSample VALUES('B', '2018-02-02', 39008);
INSERT INTO ServerLoadSample VALUES('B', '2018-02-05', 2900);
INSERT INTO ServerLoadSample VALUES('B', '2018-02-07', 556);
INSERT INTO ServerLoadSample VALUES('B', '2018-02-08', 12600);
INSERT INTO ServerLoadSample VALUES('B', '2018-02-12', 7309);
INSERT INTO ServerLoadSample VALUES('C', '2018-02-01', 1000);
INSERT INTO ServerLoadSample VALUES('C', '2018-02-07', 2000);
INSERT INTO ServerLoadSample VALUES('C', '2018-02-16', 500);
select * from serverloadsample s ;

select 
  server,
  sample_date,
  sum(load_val) over () as sum_load
from 
  serverloadsample;


