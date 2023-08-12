create database webdb;
drop database webdb;
create user 'web'@'localhost' identified by 'pass';
drop user web@localhost;
grant all privileges on webdb.* to web@localhost;



create database haksadb;
create user haksa@localhost identified by 'pass';
grant all privileges on haksadb.* to haksa@localhost;

