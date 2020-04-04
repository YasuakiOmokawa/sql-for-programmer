-- セルコオリジナルバージョン
CREATE table FOOBAR_DDL
(
  A CHAR(1) CHECK (A IN ('T', 'F')),
  B CHAR(1) CHECK (B IN ('T', 'F')),
  CONSTRAINT IMPLICATION_EXAMPLE_2 CHECK
  (CASE
    WHEN A = 'T' THEN
    CASE
      WHEN B = 'T' THEN 1
      ELSE 0
    END
    ELSE 1
  END = 1)
);

-- インサート
insert into foobar_ddl values ('T', 'T');
insert into foobar_ddl values ('T', 'F'); -- 制約変換で失敗
insert into foobar_ddl values ('T', NULL); -- 制約変換で失敗
insert into foobar_ddl values ('F', 'T');
insert into foobar_ddl values ('F', 'F');
insert into foobar_ddl values ('F', NULL);
insert into foobar_ddl values (NULL, 'T');
insert into foobar_ddl values (NULL, 'F');
insert into foobar_ddl values (NULL, NULL);

select * from foobar_ddl;

