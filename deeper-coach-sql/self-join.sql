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
  distinct a1.name,
  a1.price
from 
  products a1 inner join products a2
    on a1.price = a2.price 
    and a1.name <> a2.name
;


  




