-- セルコオリジナルバージョン
create table　Foobar_DDL
(
	a char(1) check (a in ('T',　'F')),
	b char(1) check (b in ('T',　'F')),
	constraint implication_example
		check (not (A = 'T')　or (B = 'T'))
);

-- インサート
insert into foobar_ddl values ('T', 'T');
insert into foobar_ddl values ('T', 'F'); -- 制約変換で失敗
insert into foobar_ddl values ('T', NULL);
insert into foobar_ddl values ('F', 'T');
insert into foobar_ddl values ('F', 'F');
insert into foobar_ddl values ('F', NULL);
insert into foobar_ddl values (NULL, 'T');
insert into foobar_ddl values (NULL, 'F');
insert into foobar_ddl values (NULL, NULL);

select * from foobar_ddl;

