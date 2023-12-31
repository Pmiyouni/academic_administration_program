use haksadb;
drop table enrollments;
drop table courses;
drop table students;
drop table professors;

-- 교수테이블
create table professors(
 pcode char(3) not null, 
 pname varchar(15) not null, 
 dept varchar(30), 
 hiredate date, 
 title varchar(15), 
 salary int default 0,
 primary key(pcode)
);
desc professors;
select * from professors;
select * from professors where pname like '%%' or dept like '%%' limit 0,5;
insert into professors(pcode,pname,dept,title,salary, hiredate)
 values(select max(pcode)+1 from professors,'홍길동','컴정','정교수',0,'2023-8-2');
 -- 같이 사용 못함

-- 학생테이블
create table students(
 scode char(8) not null, 
 sname varchar(15) not null,
 dept varchar(30), 
 year int default 1,
 birthday date, 
 advisor char(3), 
 primary key(scode),
 foreign key(advisor) references professors(pcode) /* on delete cascade */
);
desc students;
select  * from students;
create view view_stu as select s.*, p.pname, p.dept pdept from students s, professors p where p.pcode=s.advisor;
select * from view_stu ;

select max(scode)+1 ncode  from students;

-- 강좌테이블
create table courses(
 lcode char(4) not null,
 lname varchar(50) not null,
 hours int,
 room char(3),
 instructor char(3),
 capacity int default 0, 
 persons int default 0, 
 primary key(lcode), /* constraint child_pk foreign key(instructor) references professors(pcode) */
 foreign key(instructor) references professors(pcode)
);
desc courses;
select * from courses;
create view view_cou as select c.*, pname from courses c, professors p where c.instructor = p.pcode;
select * from view_cou;
select * from view_cou where lcode="c301";
drop view view_cou;
select max(lcode) mlcode from courses;


select max(pcode) from professors;

-- 수강신청테이블
create table enrollments(
 lcode char(4) not null, 
 scode char(8) not null, 
 edate datetime default now(),
 grade int default 0, 
 primary key(lcode, scode),
 foreign key(lcode) references courses(lcode),
 foreign key(scode) references students(scode)
);
desc enrollments;
select * from enrollments;


update courses set capacity=6 where lcode>''; 

select * from courses;

 
update courses c
set persons=(select count(*) from enrollments e where c.lcode=e.lcode)
where c.lcode>'';

create view view_enroll_cou as
select e.*,lname,room,hours,pname,persons,capacity
from enrollments e, view_cou c 
where e.lcode=c.lcode ;

drop view view_enroll_cou;


-- 특정학생 신청 목록
select * from view_enroll_cou where scode=92514023;

call add_enroll('92454018','C401',@cnt);
select @cnt;

select * from enrollments where scode='92454018';

call del_enroll('92454018','C301');

create view view_enroll_stu as
select e.*, sname,dept 
from enrollments e, students s
where e.scode=s.scode;

select * from view_enroll_stu;

insert into professors(pcode,pname,dept,hiredate,title,salary) values('221','이병렬','전산','75/04/03','정교수',3000000);
insert into professors(pcode,pname,dept,hiredate,title,salary) values('228','이재광','전산','91/09/19','부교수',2500000);
insert into professors(pcode,pname,dept,hiredate,title,salary) values('311','강승일','전자','94/06/09','부교수',2300000);
insert into professors(pcode,pname,dept,hiredate,title,salary) values('509','오문환','건축','92/10/14','조교수',2000000);
insert into professors(pcode,pname,dept,hiredate,title,salary) values('510','홍길동','건축','92/10/14','조교수',2000000);
insert into professors(pcode,pname,dept,hiredate,title,salary) values('511','심청이','건축','92/10/14','조교수',2000000);

insert into students(scode,sname,dept,year,birthday,advisor) values('92414029','서연우','전산',3,'73/10/06','228');
insert into students(scode,sname,dept,year,birthday,advisor) values('92414033','김창덕','전산',4,'73/10/26','221');
insert into students(scode,sname,dept,year,birthday,advisor) values('92514009','이지행','전자',4,'73/11/16','311');
insert into students(scode,sname,dept,year,birthday,advisor) values('92514023','김형명','전자',4,'73/08/29','311');
insert into students(scode,sname,dept,year,birthday,advisor) values('92454018','이원구','건축',3,'74/09/30','509');
insert into students(scode,sname,dept,year,birthday,advisor) values('95454003','이재영','건축',4,'76/02/06','509');
insert into students(scode,sname,dept,year,birthday,advisor) values('95414058','박혜경','전산',4,'76/03/12','221');
insert into students(scode,sname,dept,year,birthday,advisor) values('96414404','김수정','전산',3,'77/12/22','228');
select * from students;

insert into courses(lcode,lname,hours,room,instructor,capacity,persons) values('C301','파일처리론', 3 ,'506','221',100,80);
insert into courses(lcode,lname,hours,room,instructor,capacity,persons) values('C401','데이터베이스',3,'414','221',80,80);
insert into courses(lcode,lname,hours,room,instructor,capacity,persons) values('C421','알고리즘',3,'510','228',80,72);
insert into courses(lcode,lname,hours,room,instructor,capacity,persons) values('C312','자료구조',2,'510','228',100,60);
insert into courses(lcode,lname,hours,room,instructor,capacity,persons) values('E221','논리회로',3,'304','311',100,80);
insert into courses(lcode,lname,hours,room,instructor,capacity,persons) values('A109','한국의건축문화',2,'101','509',120,36);

select * from courses;
insert into enrollments(lcode, scode, edate, grade) values('C401','92414033','98/03/02',85);
insert into enrollments(lcode, scode, edate, grade) values('C301','92414033','98/03/02',80);
insert into enrollments(lcode, scode, edate, grade) values('C421','92414033','98/03/02', 0);
insert into enrollments(lcode, scode, edate, grade) values('C401','95414058','98/03/03',90);
insert into enrollments(lcode, scode, edate, grade) values('C301','95414058','98/03/03',80);
insert into enrollments(lcode, scode, edate, grade) values('C312','95414058','98/03/03',80);
insert into enrollments(lcode, scode, edate, grade) values('C401','92514023','98/03/03',70);
insert into enrollments(lcode, scode, edate, grade) values('C301','92514023','98/03/03',70);
insert into enrollments(lcode, scode, edate, grade) values('C421','92514023','98/03/03',70);
insert into enrollments(lcode, scode, edate, grade) values('C301','92414029','98/03/03',90);
insert into enrollments(lcode, scode, edate, grade) values('C421','92414029','98/03/03',0);
insert into enrollments(lcode, scode, edate, grade) values('C312','92414029','98/03/03',70);
insert into enrollments(lcode, scode, edate, grade) values('E221','92414029','98/03/03',75);
insert into enrollments(lcode, scode, edate, grade) values('A109','92414029','98/03/03',90);
insert into enrollments(lcode, scode, edate, grade) values('C301','92514009','98/03/03',70);
insert into enrollments(lcode, scode, edate, grade) values('C401','92514009','98/03/03',85);
insert into enrollments(lcode, scode, edate, grade) values('E221','92514009','98/03/03',85);
insert into enrollments(lcode, scode, edate, grade) values('C301','96414404','98/03/04',75);
insert into enrollments(lcode, scode, edate, grade) values('C401','96414404','98/03/04',75);
insert into enrollments(lcode, scode, edate, grade) values('C421','96414404','98/03/04',75);
insert into enrollments(lcode, scode, edate, grade) values('C312','92454018','98/03/04',90);
insert into enrollments(lcode, scode, edate, grade) values('E221','92454018','98/03/04',90);
insert into enrollments(lcode, scode, edate, grade) values('A109','95454003','98/03/05',85);
insert into enrollments(lcode, scode, edate, grade) values('E221','95454003','98/03/05',85);

select * from enrollments;