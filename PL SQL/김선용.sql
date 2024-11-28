-- �輱�� �׽�Ʈ 2~11
-- ���� ���� = 5�� �輱��
-- mjk@yedam.ac / ���ϸ� : �����̸�

SET SERVEROUTPUT ON

-- 2. �����ȣ �Է� / �μ��̸�, job_id, �޿�, ���� �Ѽ���(����)
DECLARE
     v_dname departments.department_name%TYPE;
     v_jid employees.job_id%TYPE;
     v_sal employees.salary%TYPE;
     v_com employees.commission_pct%TYPE;
     
     v_year_sal NUMBER; -- ����
BEGIN
    -- �Ի��� �Է� / �μ��̸�, job_id, �޿�, commission_pct �˻�
    SELECT d.department_name, e.job_id, NVL(e.salary, 0), NVL(e.commission_pct, 0)
    INTO v_dname, v_jid, v_sal, v_com
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    WHERE e.employee_id = &�����ȣ;
    
    -- ���� �Ѽ��� ���
    v_year_sal := (v_sal + (v_sal * v_com)) * 12;
    
    -- ���
    DBMS_OUTPUT.PUT_LINE('�μ��̸� : ' || v_dname);
    DBMS_OUTPUT.PUT_LINE('job_id : ' || v_jid);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('���� �Ѽ��� : ' || v_year_sal);
END;
/



-- 3. �����ȣ �Է�, �Ի�⵵ 2015�� ����(2015����) �Ի�� New employee �ƴϸ� Career employee ���
DECLARE
    v_hdate employees.hire_date%TYPE; -- �Ի���
BEGIN
    -- �Ի��� �Է� �� �˻�
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    -- 2015�� ����(2015����) �Ի��� -> New employee
    IF TO_CHAR(v_hdate, 'yyyy') > '2015' THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE -- �ƴϸ� -> Career employee
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/



-- 4. ������ 1~9�� ���(Ȧ���ܸ� ���)
BEGIN
    -- ���� �ݺ�
    FOR num IN 1 .. 9 LOOP
        -- �ܼ� �ݺ�
        FOR dan IN 1 .. 9 LOOP
            -- Ȧ�� �ܸ� ����
            IF MOD(dan, 2) <> 0 AND dan * num >= 10 THEN -- 10�̻��̸� ���� ����
                DBMS_OUTPUT.PUT(dan || ' X ' || num || ' = ' || (dan * num));
            ELSIF MOD(dan, 2) <> 0 AND dan * num < 10 THEN -- 10 �̸��̸� ���� �߰�
                DBMS_OUTPUT.PUT(dan || ' X ' || num || ' =  ' || (dan * num));
            END IF;
            
            -- ĭ����
            DBMS_OUTPUT.PUT('  ');
        END LOOP;
        
        -- ���� ����
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/



--5. �μ���ȣ �Է� / �ش� �μ��� ��� ����� ���, �̸�, �޿� ���(CURSOR ���)
DECLARE
    -- Ŀ�� : �μ���ȣ �Է� / ���, �̸�, �޿� �˻�
    CURSOR emp_cursor IS
        SELECT employee_id eid, last_name ename, salary sal
        FROM employees
        WHERE department_id = &�μ���ȣ;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('��� : ' || emp_rec.eid);
        DBMS_OUTPUT.PUT(', �̸� : ' || emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(', �޿� : ' || emp_rec.sal);
    END LOOP;
END;
/



-- 6. ���, �޿� ����ġ(����)  �Է½� ����� �޿� ���� procedure / ��� ������ No search employee!! ���(����ó��)
CREATE PROCEDURE sal_inc
    --���, �޿� ����ġ(����) �Է�
    (p_eid IN employees.employee_id%TYPE,
     p_inc_sal IN employees.salary%TYPE)
IS
    -- ��� ���� ��� ���� ����
    p_no_emp EXCEPTION;
BEGIN
    -- ����� �޿� ����
    UPDATE employees
    SET salary = salary + (salary * (p_inc_sal/100))
    WHERE employee_id = p_eid;
    
    -- ��� ���� ��� üũ
    IF SQL%ROWCOUNT = 0 THEN
        RAISE p_no_emp;
    END IF;
    
EXCEPTION -- ���� ó��
    WHEN p_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/
-- 6�� ���� : ���, �޿� ����ġ(����)
EXECUTE sal_inc(100, 100);
select employee_id, salary
from employees
where employee_id = 100;



-- 7. �ֹι�ȣ �Է� -> �� ���̿� ���� ��� ���
CREATE PROCEDURE jumin_num
    (p_num VARCHAR2) -- �ֹι�ȣ �Է�
IS
    v_date VARCHAR2(100);
    v_birth DATE;
    v_age NUMBER;
    v_check NUMBER := MOD(TO_NUMBER(SUBSTR(p_num, 7, 1)), 2);
BEGIN
    -- �ֹι�ȣ ���ڸ� Ȯ�� �� ������� ���ڿ� ����
    IF SUBSTR(p_num, 7, 1) IN (0,9) THEN
        v_date := '18' || SUBSTR(p_num, 1, 6);
    ELSIF SUBSTR(p_num, 7, 1) IN (1,2) THEN
        v_date := '19' || SUBSTR(p_num, 1, 6);
    ELSIF SUBSTR(p_num, 7, 1) IN (3,4) THEN
        v_date := '20' || SUBSTR(p_num, 1, 6);
    END IF;
    
    -- ������� DATE�� ��ȯ
    v_birth := TO_DATE(v_date, 'yyyyMMdd');
    -- ���� ���
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_birth)/12 , 0);
    
    --������ / ���� ���
    DBMS_OUTPUT.PUT_LINE('�� ���� ' || v_age);
    IF v_check = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���� : ��');
    ELSE
        DBMS_OUTPUT.PUT_LINE('���� : ��');
    END IF;
END;
/
-- 7�� �׽�Ʈ
EXECUTE jumin_num('9511281222222');
EXECUTE jumin_num('0211023234567');



-- 8. �����ȣ �Է�, �ٹ��Ⱓ�� �ٹ� ����� ����ϴ� FUNCTION / �ٹ� �������� ����(5�� 10������ ��� 5�⸸ ǥ��)
CREATE FUNCTION work_year_func
    (p_eid employees.employee_id%TYPE) -- �����ȣ �Է�
    RETURN NUMBER -- �ٹ� ��� ��ȯ
IS
    v_hdate employees.hire_date%TYPE;
    v_work_year NUMBER;
BEGIN
    -- �Ի��� �˻�
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = p_eid;
    
    -- �ٹ� ��� ��� -> ������ ����
    v_work_year := TRUNC(MONTHS_BETWEEN(SYSDATE, v_hdate)/12 , 0);
    
    RETURN v_work_year;
END;
/
-- 8�� Ȯ��
select employee_id, hire_date
from employees;
select work_year_func(101)
from dual;



-- 9. �μ��̸� �Է� -> �μ��� å����(manager) �̸� ��� function / �������� �̿�
CREATE FUNCTION mgr_prt
    (p_dname departments.department_name%TYPE) -- �μ��̸� �Է�
    RETURN VARCHAR2 -- manager �̸� ��ȯ
IS
    v_mgr_name employees.last_name%TYPE;
BEGIN
    -- manager �̸� �˻�
    SELECT e.last_name
    INTO v_mgr_name
    FROM employees e
    WHERE e.employee_id = (SELECT d.manager_id
                         FROM departments d
                         WHERE UPPER(d.department_name) = UPPER(p_dname));

    RETURN v_mgr_name;
END;
/
-- 9�� �׽�Ʈ
select mgr_prt('it')
from dual;
select department_name, manager_id
from departments;
select employee_id, last_name
from employees
where employee_id = 124;



-- 10. hr����ڿ� �����ϴ� procedure, function, package, package body �̸��� �ҽ��ڵ带 �Ѳ����� Ȯ�� ����
SELECT name, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY');



-- 11. �� ���� ��� -> �� �� = �� 9��, ��ü ����10
DECLARE
    v_blank NUMBER := 9;
    v_star NUMBER := 1;
BEGIN
    -- �� 9�� �׸��� ����
    LOOP
        -- ���� �׸���
        FOR blank IN 1 .. v_blank LOOP
            DBMS_OUTPUT.PUT('-');
        END LOOP;
        
        -- �� �׸���
        FOR star IN 1 .. v_star LOOP
            DBMS_OUTPUT.PUT('*');
        END LOOP;
        
        -- ���� ����
        DBMS_OUTPUT.PUT_LINE('');
        
        --���� ����, �� ����
        v_blank := v_blank - 1;
        v_star := v_star + 1;
        EXIT WHEN v_star = 10;
    END LOOP;
END;
/


