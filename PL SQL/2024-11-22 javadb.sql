
-- 테이블 생성(department, employee)
create table department (
	deptid   number(10) primary key,
    deptname varchar2(10),
    location varchar2(10),
    tel      varchar2(15)
);

create table employee (
    empid    number(10) primary key,
    empname  varchar2(10),
    hiredate date,
    addr     varchar2(12),
    tel      varchar2(15),
    deptid   number(10) references department(deptid)
    /*
    deptid   number(10),
    constranint emp_deptid_fk foreign key(deptid) references department(deptid)
    */
);


-- employee 테이블에 birthday 컬럼 추가
alter table employee add birthday date;


-- 조회된 결과과 같은 데이터 입력 sql문 작성
insert into department
values ( 1001, '총무팀', '본101호', '053-777-8777');
insert into department
values ( 1002, '회계팀', '본102호', '053-888-9999');
insert into department
values ( 1003, '영업팀', '본103호', '053-222-3333');

select *
from department;


-- ALTER session set NLS_DATE_FORMAT = 'yyyyMMdd';

insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20121945 , '박민수', to_date(20120302, 'yyyyMMdd'), '대구', '010-1111-1234', 1001);
insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20101817 , '박준식', to_date(20100901, 'yyyyMMdd'), '경산', '010-2222-1234', 1003);
insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20122245 , '선아라', to_date(20120302, 'yyyyMMdd'), '대구', '010-3333-1222', 1002);
insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20121729 , '이범수', to_date(20110302, 'yyyyMMdd'), '서울', '010-3333-4444', 1001);
insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20121646 , '이융희', to_date(20120901, 'yyyyMMdd'), '부산', '010-1234-2222', 1003);

select *
from employee;


-- 직원 테이블 empname컬럼에 not null 제약조건 추가
alter table employee
modify empname not null;


-- 총무팀 근무자 이름, 입사일, 부서명 출력
select e.empname, e.hiredate, d.deptname
from employee e
and d.deptid = e.deptid;


-- 대구에 살고있는 직원 삭제
delete from employee
where addr = '대구';

select * from employee;


-- 영업팀에 근무하는 직원을 모두 회계팀으로 수정
update employee
set deptid = (select deptid
              from department
              where deptname = '회계팀')
where deptid = (select deptid
                from department
                where deptname = '영업팀');


-- 직원 번호가 20121729인 직원의 입사일 보다 늦게 입사한 직원의 직원번호, 이름, 생년월일, 부서이름 출력
SELECT e.empid, 
	   e.empname, 
	   e.birthday, 
	   d.deptname
FROM   employee e 
	   JOIN department d
       ON (d.deptid = e.deptid)
WHERE  e.hiredate > (SELECT hiredate
                     FROM   employee
                     WHERE  empid = 20121729)

--select a.empid, a.empname, a.birthday, d.deptname
--from department d, (select *
--                    from employee
--                    where hiredate > (select hiredate
--                                      from employee
--                                      where empid = 20121729)) a
--where d.deptid = a.deptid;

-- 총무팀 근무 직원의 이름, 주소, 부서명 볼 수 있는 뷰 생성
GRANT CREATE VIEW TO hr;
CREATE OR REPLACE VIEW emp_vu 
AS
  SELECT e.empname, 
		 e.addr, 
		 d.deptname
  FROM   employee e 
         JOIN department d
         ON (d.deptid = e.deptid)
  WHERE  d.deptname='총무팀';

--create view emp_view
--as (select e.empname, e.addr, d.deptname
--    from employee e, (select *
--                      from department
--                      where deptname = '총무팀') d
--    where e.deptid = d.deptid);



-- Paginging
SELECT r.* 
FROM (
        SELECT ROWNUM rn, e.*
        FROM  (
            SELECT *    
            FROM employees 
            ORDER BY first_name) e 
        ) r
WHERE rn BETWEEN 1 AND 10;

/* [필기]

<서브쿼리 명칭>
select : 스칼라 서브쿼리 -> select 문 실행 후 서브쿼리 실행됨, 단일행 조건 있음
from   : 인라인 뷰
other  : 서브쿼리


오라클 데이터 변환 함수
to_number = char -> number
to_char   = date -> char || number -> char
to_date   = char -> date


[join]
*inner join
=> 교집합(겹치는 데이터만 가져옴)

*outer join - left/right outer join
            => A집합 / B집합 영역 보여줌(left/right 테이블)
            - full outer join
            => 합집합(교차되지 않는 영역도 보여줌)

*조인을 여러개 사용시 순서대로 조인된 결과에 추가 조인됨(순서 중요!)





*/











