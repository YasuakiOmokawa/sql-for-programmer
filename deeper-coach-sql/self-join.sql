CREATE TABLE Products
(name VARCHAR(16) PRIMARY KEY,
 price INTEGER NOT NULL);

--重複順列・順列・組み合わせ
DELETE FROM Products;
INSERT INTO Products VALUES('りんご',  100);
INSERT INTO Products VALUES('みかん',  50);
INSERT INTO Products VALUES('バナナ',  80);

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

