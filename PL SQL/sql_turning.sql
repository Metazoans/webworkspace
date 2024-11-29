-- 1) �����غ�
-- 1-1) �����͸� ������ ���̺� ����
DROP TABLE t_emps;
CREATE TABLE t_emps
AS 
    SELECT *
    FROM employees;

ALTER TABLE t_emps
ADD CONSTRAINT t_emps_pk PRIMARY KEY (employee_id);

ALTER TABLE t_emps
MODIFY employee_id NUMBER(38,0);

ALTER TABLE t_emps
MODIFY last_name VARCHAR2(1000);

-- 1-2) PRIMARY KEY�� ����� ������ �÷��� �� ������ ��ü ����
DROP SEQUENCE t_emps_empid_seq;
CREATE SEQUENCE t_emps_empid_seq
    START WITH 1000;
 
-- 1-3) ���� ������ ����
BEGIN
    FOR count IN 1 .. 10 LOOP
        INSERT INTO t_emps(employee_id, last_name, email, hire_date, job_id)
        SELECT t_emps_empid_seq.NEXTVAL, last_name || count, email, hire_date, job_id
        FROM t_emps;
    END LOOP;
END;
/

SELECT COUNT(*)
FROM t_emps;

-- 1) �ε����� Ȱ���� �˻� ����

-- ���� 1 : �ε����� ������� ���� �÷�
SELECT *
FROM t_emps
WHERE last_name = 'King15';


-- ���� 2 : �ε����� ����� �÷�
SELECT *
FROM t_emps
WHERE employee_id = 100000;



-- 2) ORDER BY vs INDEX
-- ���� 1 : �ε����� ���� �÷��� �������� ������ ���
SELECT *
FROM t_emps
ORDER BY last_name;

-- ���� 2 :  �ε����� �ִ� �÷��� �������� ������ ���
SELECT *
FROM t_emps
ORDER BY employee_id;

-- 3) HINT ���
-- 3-1) FULL
SELECT /*+ FULL (t_emps) */ *
FROM t_emps;

-- 3-2) INDEX_ASC
SELECT /*+ INDEX_ASC(t_emps t_emps_pk) */ *
FROM t_emps;

-- 3-3) INDEX_DESC
SELECT /*+ INDEX_DESC(t_emps t_emps_pk) */ *
FROM t_emps;
