
-- [PL/SQL �ǽ�]

-- SQL ��ɾ� �ƴ�, �۾��� �Ϸ�Ǿ����ϴٸ� ǥ�õ� / ���� �۾�
-- DB�� ���ο��� ������ ����� ȭ������ ����ϰڴٴ� ����Ŭ ����, ������ �ƴ϶� �Ҷ����� ó���� ����� ��
SET SERVEROUTPUT ON

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL!!');
END;
/

-- /�� �ϳ��� ��ɾ�, => / ��ġ�� �κб��� �ϳ��� �������� ����, ;�ڿ� �ٿ� ���� �ȵ�(������ �ϳ��� �� ����)

-- [�⺻ ����] => DECLARE�� EXCEPTION�� ���� ����, DECLARE�� ���� ��κ� �����
DECLARE
-- ����� : ���� �� ����
BEGIN
-- ����� : ���� ���μ��� ����
EXCEPTION
-- ����ó�� : ���� �߻��� ó���ϴ� �۾�
END;
/

DECLARE
    v_str VARCHAR2(100); -- �⺻
    v_num CONSTANT NUMBER(2,0) := 10; -- ���
    v_count NUMBER(2,0) NOT NULL DEFAULT 5; -- ������ ����
    v_sum NUMBER(3,0) := v_num + v_count; -- ǥ����(����)�� ������� �ʱ�ȭ
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_str : ' || v_str);
    DBMS_OUTPUT.PUT_LINE('v_num : ' || v_num);
--    v_num := 100; -- ����� ������ ���� �����Ϸ��� �ϸ� ���� �߻�
    DBMS_OUTPUT.PUT_LINE('v_count : ' || v_count);
    DBMS_OUTPUT.PUT_LINE('v_sum : ' || v_sum);
END;
/

-- %TYPE �Ӽ� : ������ Ÿ�� ����
DECLARE
    v_eid employees.employee_id%TYPE; -- imployee_id�� ������ �ִ� ũ��(NUMBER(6,0))
    v_ename employees.last_name%TYPE; -- VARCHAR2(25 BYTE)
    v_new v_ename%TYPE; -- VARCHAR2(25 BYTE)
BEGIN
    SELECT employee_id, last_name
    INTO v_eid, v_ename
    FROM employees
    WHERE employee_id = 100;
    
    v_new := v_eid || ' ' || v_ename;
    DBMS_OUTPUT.PUT_LINE(v_new);
END;
/

-- VARCHAR2�� ũ�� -> BYTE / CHAR
-- BYTE�� BYTE����(���� �� ���ڴ� 1BYTE�� ǥ�� �Ұ����ؼ� ���̰� ����)
-- CHAR�� ���ڸ� �������� ũ�� ����


-- PL/SQL���� �ܵ� ��� ������ SQL �Լ� => ������ �Լ���(DECODE, �׷��Լ� ����)
DECLARE
    v_date DATE;
BEGIN
    v_date := SYSDATE + 7;
    DBMS_OUTPUT.PUT_LINE(v_date);
END;
/

-- PL/SQL�� SELECT
-- 1) INTO�� : ��ȸ�� �÷��� ���� ��� ���� ���� => �ݵ�� �����ʹ� �ϳ��� �ุ ��ȯ
DECLARE
    v_name employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_name
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(v_name);
END;
/

-- 2) ��� ���� ������ �ϳ��� ��
DECLARE
    v_name employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_name
    FROM employees
    WHERE department_id = &�μ���ȣ;
    -- �μ���ȣ 0 : "no data found"
    -- �μ���ȣ 50 : "exact fetch returns more than requested number of rows" (�����Ͱ� �ʹ� ����)
    -- �μ���ȣ 10 : ���� ����
    
    DBMS_OUTPUT.PUT_LINE(v_name);
END;
/

-- 3) SELECT���� �÷� ���� = INTO���� ���� ����
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT employee_id, last_name
    INTO v_eid, v_ename
    -- SELECT > INTO : not enough values
    -- SELECT < INTO : too many values
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
END;
/

-- must be declared ���� : ���� �ȵ� ���� ���� ���


-- [����]
/*
1.
�����ȣ�� �Է�(ġȯ�������&)�� ���
�����ȣ, ����̸�, �μ��̸�  
�� ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
*/
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT e.employee_id, e.last_name, d.department_name
    INTO v_eid, v_ename, v_dname
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    WHERE e.employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE(v_eid || ' / ' || v_ename || ' / ' || v_dname);
END;
/

-- 1�� ������ select���� 2���� �и�
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_did departments.department_id%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, department_id
    INTO v_eid, v_ename, v_did
    FROM employees e
    WHERE employee_id = &�����ȣ;
    
    SELECT department_name
    INTO v_dname
    FROM departments
    WHERE department_id = v_did;
    
    DBMS_OUTPUT.PUT_LINE(v_eid || ' / ' || v_ename || ' / ' || v_dname);
END;
/

-- 1�� ������ ��������
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT  e.employee_id,
            e.last_name,
            (select d.department_name
             from departments d
             where e.department_id = d.department_id)
    INTO v_eid, v_ename, v_dname
    FROM employees e
    WHERE e.employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE(v_eid || ' / ' || v_ename || ' / ' || v_dname);
END;
/


/*
2.
�����ȣ�� �Է�(ġȯ�������&)�� ��� 
����̸�, 
�޿�, 
����->(�޿�*12+(nvl(�޿�,0)*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))
�� ����ϴ�  PL/SQL�� �ۼ��Ͻÿ�.
*/
DECLARE
    v_ename employees.last_name%TYPE;
    v_esalary employees.salary%TYPE;
    v_year_salary NUMBER(20);
BEGIN
    SELECT last_name, salary, ((salary * 12) + (NVL(salary, 0) * NVL(commission_pct, 0) * 12))
    INTO v_ename,v_esalary, v_year_salary
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_esalary);
    DBMS_OUTPUT.PUT_LINE(v_year_salary);
END;
/

-- 2�� ������ ������ select������ �������� �ʰ� �и��ؼ� ���
DECLARE
    v_ename employees.last_name%TYPE;
    v_esalary employees.salary%TYPE;
    v_ecom employees.commission_pct%TYPE;
    v_year_salary NUMBER(20);
BEGIN
    SELECT last_name, salary, commission_pct
    INTO v_ename,v_esalary, v_ecom
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    v_year_salary := ((v_esalary * 12) + (NVL(v_esalary, 0) * NVL(v_ecom, 0) * 12));
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_esalary);
    DBMS_OUTPUT.PUT_LINE(v_year_salary);
END;
/


-- PL/SQL �ȿ��� DML
DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE := .1;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    INSERT INTO employees (employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);
    
    UPDATE employees
    SET salary = (NVL(salary, 0) + 10000) * v_comm
    WHERE employee_id = 1000;
    
    COMMIT; -- ��� =/= Ʈ�����, �ݵ�� �ʿ��ϴٸ� ��������� COMMIT/ROLLBACK �ۼ�
END;
/

select *
from employees
where employee_id in (200, 1000);

ROLLBACK;


BEGIN
    DELETE FROM employees
    WHERE employee_id = 1000;
END;
/






