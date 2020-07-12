CREATE TABLE Products
(name VARCHAR(16) PRIMARY KEY,
 price INTEGER NOT NULL);

--重複順列・順列・組み合わせ
DELETE FROM Products;
INSERT INTO Products VALUES('りんご',  50);
INSERT INTO Products VALUES('みかん',  100);
INSERT INTO Products VALUES('ぶどう',  50);
INSERT INTO Products VALUES('スイカ',  80);
INSERT INTO Products VALUES('レモン',  30);
INSERT INTO Products VALUES('いちご',  100);
INSERT INTO Products VALUES('バナナ',  100);
select * from products p ;

-- get duplicated order
select 
  p1.name as name_1,
  p2.name as name_2
from products p1 cross join products p2;

-- get distinct order
select 
  p1.name as name_1,
  p2.name as name_2
from
  products p1 inner join products p2
    on p1.name <> p2.name;
  
-- get combination
select 
  p1.name as name_1,
  p2.name as name_2,
  p3.name as name_3
from
  products p1 inner join products p2
    on p1.name > p2.name
      inner join products p3
       on p2.name > p3.name;

-- remove duplication pattern, using not equivalant join
CREATE TABLE DuplicateProducts
(name VARCHAR(16),
 price INTEGER NOT NULL);

INSERT INTO DuplicateProducts VALUES('りんご',  100);
INSERT INTO DuplicateProducts VALUES('みかん',  50);
INSERT INTO DuplicateProducts VALUES('バナナ',  80);
INSERT INTO DuplicateProducts VALUES('みかん',  50);
INSERT INTO DuplicateProducts VALUES('みかん',  50);
select * from Duplicateproducts;

delete from Duplicateproducts p1
where exists (
  select * from duplicateproducts p2
  where
    p1.name = p2.name
    and p1.price = p2.price
    and p1.rowid < p2.rowid
);
  
-- search not partial match key
-- same family id but not same address
CREATE TABLE Addresses
(name VARCHAR(32),
 family_id INTEGER,
 address VARCHAR(32),
 PRIMARY KEY(name, family_id));

INSERT INTO Addresses VALUES('前田 義明', '100', '東京都港区虎ノ門3-2-29');
INSERT INTO Addresses VALUES('前田 由美', '100', '東京都港区虎ノ門3-2-92');
INSERT INTO Addresses VALUES('加藤 茶',   '200', '東京都新宿区西新宿2-8-1');
INSERT INTO Addresses VALUES('加藤 勝',   '200', '東京都新宿区西新宿2-8-1');
INSERT INTO Addresses VALUES('ホームズ',  '300', 'ベーカー街221B');
INSERT INTO Addresses VALUES('ワトソン',  '400', 'ベーカー街221B');
select * from addresses;

select
  distinct a1.name,
  a1.address
from 
  addresses a1 inner join addresses a2
    on a1.family_id = a2.family_id
    and a1.address <> a2.address
;

-- search same price products
select 
  distinct p1.name,
  p1.price
from 
  products p1 inner join products p2
    on p1.price = p2.price 
    and p1.name <> p2.name
order by 
  p1.price 
;

-- search same price products using correlated query
select 
  p1.name,
  p1.price
from 
  products p1
where 
  exists (
    select
      *
    from
      products p2
    where
      p1.price = p2.price 
      and p1.name <> p2.name       
  )  
order by 
  p1.price 
;

-- column: create rank with window function
select 
  name,
  price,
  rank() over ( -- jump rank between over and over
    order by price desc
  ) as rank_1,
  dense_rank() over ( -- ordered ranking
    order by price desc
  ) as rank_2  
from 
  products
;

-- exercise 3-1. duplicate variation
select 
  p1.name as name_1,
  p2.name as name_2
from  
  products p1 inner join products p2
    on p1.name <= p2.name
order by name_1
;

-- exercise 3-2. catch duplicate row
select
  p1.name,
  p1.price,
  rank() over (order by p1.name, p1.price) as row_id1
from
  Duplicateproducts p1
where exists (
  select
    p2.name,
    p2.price,
    rank() over (order by p1.name, p1.price) as row_id2
  from
    duplicateproducts p2
  where
    p1.name = p2.name
    and p1.price = p2.price    
    and row_id1 <> row_id2
)
;

select * from duplicateproducts;

select 
  name,
  price,
  rank() over(order by name) as data_rank
from 
  duplicateproducts
;

CREATE TABLE dup_prods
(name VARCHAR(16),
 price INTEGER NOT null,
 sales_price Integer not null
);

-- set data
INSERT INTO dup_prods VALUES('りんご',  50, 100);
INSERT INTO dup_prods VALUES('みかん',  100, 200);
INSERT INTO dup_prods VALUES('みかん',  100, 250);
INSERT INTO dup_prods VALUES('みかん',  100, 150);
select * from dup_prods ;

select 
  name,
  price,
  sales_price,
  rank() over (order by name, price, sales_price) as rank_1,
  rank() over (order by name, price) as rank_2
from dup_prods
;


select 
  name,
  price,
  row_number() over(
    partition by name, price
    order by name) as row_num
from 
  duplicateproducts
;
