
-- ���̺� ����(department, employee)
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


-- employee ���̺� birthday �÷� �߰�
alter table employee add birthday date;


-- ��ȸ�� ����� ���� ������ �Է� sql�� �ۼ�
insert into department
values ( 1001, '�ѹ���', '��101ȣ', '053-777-8777');
insert into department
values ( 1002, 'ȸ����', '��102ȣ', '053-888-9999');
insert into department
values ( 1003, '������', '��103ȣ', '053-222-3333');

select *
from department;


-- ALTER session set NLS_DATE_FORMAT = 'yyyyMMdd';

insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20121945 , '�ڹμ�', to_date(20120302, 'yyyyMMdd'), '�뱸', '010-1111-1234', 1001);
insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20101817 , '���ؽ�', to_date(20100901, 'yyyyMMdd'), '���', '010-2222-1234', 1003);
insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20122245 , '���ƶ�', to_date(20120302, 'yyyyMMdd'), '�뱸', '010-3333-1222', 1002);
insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20121729 , '�̹���', to_date(20110302, 'yyyyMMdd'), '����', '010-3333-4444', 1001);
insert into employee (empid, empname, hiredate, addr, tel, deptid)
values ( 20121646 , '������', to_date(20120901, 'yyyyMMdd'), '�λ�', '010-1234-2222', 1003);

select *
from employee;


-- ���� ���̺� empname�÷��� not null �������� �߰�
alter table employee
modify empname not null;


-- �ѹ��� �ٹ��� �̸�, �Ի���, �μ��� ���
select e.empname, e.hiredate, d.deptname
from employee e
and d.deptid = e.deptid;


-- �뱸�� ����ִ� ���� ����
delete from employee
where addr = '�뱸';

select * from employee;


-- �������� �ٹ��ϴ� ������ ��� ȸ�������� ����
update employee
set deptid = (select deptid
              from department
              where deptname = 'ȸ����')
where deptid = (select deptid
                from department
                where deptname = '������');


-- ���� ��ȣ�� 20121729�� ������ �Ի��� ���� �ʰ� �Ի��� ������ ������ȣ, �̸�, �������, �μ��̸� ���
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

-- �ѹ��� �ٹ� ������ �̸�, �ּ�, �μ��� �� �� �ִ� �� ����
GRANT CREATE VIEW TO hr;
CREATE OR REPLACE VIEW emp_vu 
AS
  SELECT e.empname, 
		 e.addr, 
		 d.deptname
  FROM   employee e 
         JOIN department d
         ON (d.deptid = e.deptid)
  WHERE  d.deptname='�ѹ���';

--create view emp_view
--as (select e.empname, e.addr, d.deptname
--    from employee e, (select *
--                      from department
--                      where deptname = '�ѹ���') d
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

/* [�ʱ�]

<�������� ��Ī>
select : ��Į�� �������� -> select �� ���� �� �������� �����, ������ ���� ����
from   : �ζ��� ��
other  : ��������


����Ŭ ������ ��ȯ �Լ�
to_number = char -> number
to_char   = date -> char || number -> char
to_date   = char -> date


[join]
*inner join
=> ������(��ġ�� �����͸� ������)

*outer join - left/right outer join
            => A���� / B���� ���� ������(left/right ���̺�)
            - full outer join
            => ������(�������� �ʴ� ������ ������)

*������ ������ ���� ������� ���ε� ����� �߰� ���ε�(���� �߿�!)





*/











