-- <2024-11-26>

SET SERVEROUTPUT ON

/*
9. ������ 1~9�ܱ��� ��µǵ��� �Ͻÿ�.
   (��, Ȧ���� ���)
   --> % ������ ������ ����
   --> MOD(num, 2) = 0   ==  ������ �Լ�
   => MOD(num, 2) <> 0   ==  0�� �ƴ� ��� üũ(<> ��ȣ�� !=)
   => CONTINUE WHEN MOD(dan, 2) = 0  ==  2�� �������� �������� 0�� ��� �ݺ����� �ѹ� �ǳʶ�
*/
DECLARE

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


/*

*���� ����
������ [CONSTANT] ������ Ÿ�� [NOT NULL] [:= | default expr]

*�ʵ� ����
�ʵ��            ������ Ÿ�� [NOT NULL] [:= | default expr]
-> �ʵ�� ��� ���� �Ұ�(constant �Ұ�)

*/


-- ���� ������ ���� : ���� ���� ���� �� �ִ� ������ Ÿ��
-- RECORD : ���ο� �ʵ带 ������ ������ ����, SELECT��ó�� �����͸� ��ȸ�ϴ� ��� ���� ����
-- 1) ����
DECLARE
    -- 1. ���ڵ� Ÿ�� ����
    TYPE ���ڵ�Ÿ�Ը� IS RECORD
        ( �ʵ�� ������Ÿ��,
          �ʵ�� ������Ÿ�� := �ʱⰪ,
          �ʵ�� ������Ÿ�� NOT NULL := �ʱⰪ);

    -- 2. ���� ����
    ������ ���ڵ�Ÿ�Ը�; -- ���� ����Ϸ��� ����ó�� �����ؾ���
BEGIN
    -- 3. ���
    ������.�ʵ�� := ���氪;
    DBMS_OUTPUT_PUT_LINE(������.�ʵ��); -- ��� ���, ������ �ۼ��Ͽ� ��ü �ʵ� ��� �Ұ�(�ʵ� �ϳ��� ����ؾ���)
END;
/

-- 2) ����
DECLARE
    -- 1. Ÿ�� ���� => INTO ������ ���Ǵ� ��� SELECT���� �÷��� ������ ���·� ����
    TYPE emp_record_type IS RECORD (
        empno NUMBER(6,0),
        ename employees.last_name%TYPE NOT NULL := 'Hong',
        sal employees.salary%TYPE := 0
    );
    
    -- 2. ���� ����
    v_emp_info emp_record_type;
    v_emp_rec emp_record_type;
BEGIN
    DBMS_OUTPUT.PUT(v_emp_info.empno);
    DBMS_OUTPUT.PUT(', ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', ' || v_emp_info.sal);
    
    v_emp_rec.empno := &�����ȣ;
    
    SELECT employee_id, last_name, salary
    INTO v_emp_info -- ���ڵ� Ÿ���� ���� �߿�, SELECT �÷��� Ÿ���� ���� ������ ����
    FROM employees
    WHERE employee_id = v_emp_rec.empno;
    
    DBMS_OUTPUT.PUT(v_emp_info.empno);
    DBMS_OUTPUT.PUT(', ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', ' || v_emp_info.sal);
END;
/

-- %ROWTYPE : ���̺� Ȥ�� ���� �� ���� RECORD TYPE���� ��ȯ => Ÿ�� ���� ���� ���� �������� �ٷ� ���
DECLARE
    v_emp_rec employees%ROWTYPE; -- �ʵ�� ���� ���ؼ� SELECT���� �÷����� �״�� �ʵ������ ������
BEGIN
    SELECT *
    INTO v_emp_rec
    FROM employees
    WHERE employee_id = &�����ȣ;

    DBMS_OUTPUT.PUT_LINE(v_emp_rec.employee_id);
    DBMS_OUTPUT.PUT_LINE(v_emp_rec.last_name);
    DBMS_OUTPUT.PUT_LINE(v_emp_rec.salary);
END;
/

-- TABLE : ������ ������ Ÿ���� ���� ������ ����. �ַ�, ���ڵ�Ÿ�԰� �Բ� Ư�� ���̺��� ��� �����͸� ������ ���� �� ���
-- 1) ����
DECLARE
    -- 1. Ÿ�� ����
    TYPE ���̺�Ÿ�Ը� IS TABLE OF ������Ÿ��
        INDEX BY BINARY_INTEGER; -- PLS_INTEGER : BINARY_INTEGER���� ����
    
    -- 2. ���� ����
    ������ ���̺�Ÿ�Ը�;
BEGIN
    -- 3. ���
    ������(�ε���) := �ʱⰪ;
    DBMS_OUTPUT.PUT_LINE(������(�ε���));
END;
/

-- 2) ����
DECLARE
    -- 1. ����
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER;
        
    -- 2. ���� ����
    v_num_info num_table_type;
BEGIN
    v_num_info(10) := 1000; -- �ε��� ���� ���� ����(������ �ο�����)
    DBMS_OUTPUT.PUT_LINE(v_num_info(10));
    
    v_num_info(-123456789) := 123456789; -- ���� �ε��� ����
    DBMS_OUTPUT.PUT_LINE(v_num_info(-123456789));
    
    v_num_info(1111111111) := 1111111111; -- ���� �ε��� ����
    DBMS_OUTPUT.PUT_LINE(v_num_info(1111111111));
    
--    DBMS_OUTPUT.PUT_LINE(v_num_info(-1111111111)); -- ���� �ε��� ���ٽ� ���� : "no data found"
END;
/
-- ���̺��� �ε��� ������ �Ϲ����� ��Ģ�� ������ -> �޼ҵ� ����ؼ� ������ ����

-- ���̺� Ÿ���� �޼��� Ȱ��
DECLARE
    -- 1. ���̺� Ÿ�� ����
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY BINARY_INTEGER;
        
    -- 2. ���� ����
    v_num_info num_table_type;
    
    -- �⺻ LOOP���� ����
    v_idx NUMBER;
BEGIN
    v_num_info(-23) := 1;
    v_num_info(-5) := 2;
    v_num_info(11) := 3;
    v_num_info(1121) := 4;

    DBMS_OUTPUT.PUT_LINE('���� ���� : ' || v_num_info.COUNT);
    
    -- FOR LOOP��
    FOR idx IN v_num_info.FIRST .. v_num_info.LAST LOOP -- �ݺ����� FIRST���� LAST ����ŭ �ݺ���(��ȿ����)
        IF v_num_info.EXISTS(idx) THEN -- ���̺��� ���� ��� �ִ��� Ȯ��
            DBMS_OUTPUT.PUT_LINE(idx || ' : ' || v_num_info(idx));
        END IF;
    END LOOP;
    
    -- �⺻ LOOP�� : ���� ���� �˻�(���� ��� ���� ���� ���)
    v_idx := v_num_info.FIRST;
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_idx || ' : ' || v_num_info(v_idx));
        
        EXIT WHEN v_num_info.LAST <= v_idx;
        v_idx := v_num_info.NEXT(v_idx);
    END LOOP;
END;
/

-- TABLE + RECORD
DECLARE
    -- 1. Ÿ�� ����
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY BINARY_INTEGER;
        
    -- 2. ���� ����
    v_emp_list emp_table_type;
    v_emp_rec employees%ROWTYPE;
BEGIN
    -- ���̺� ��ȸ
    FOR eid IN 100 .. 104 LOOP
        SELECT *
        INTO v_emp_rec
        FROM employees
        WHERE employee_id = eid;
        
        v_emp_list(eid) := v_emp_rec;
    END LOOP;
    
    -- ���̺� Ÿ���� ������ ��ȸ
    FOR idx IN v_emp_list.FIRST .. v_emp_list.LAST LOOP
        IF v_emp_list.EXISTS(idx) THEN
            -- �ش� �ε����� �����Ͱ� �ִ� ���
            DBMS_OUTPUT.PUT(v_emp_list(idx).employee_id);
            DBMS_OUTPUT.PUT(', ' || v_emp_list(idx).last_name);
            DBMS_OUTPUT.PUT_LINE(', ' || v_emp_list(idx).salary);
        END IF;
    END LOOP;
END;
/

-- employees ���̺� ��ü ������ => ���̺� Ÿ���� ������ ���
DECLARE
    -- 1. Ÿ�� ����
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY BINARY_INTEGER;
        
    -- 2. ���� ����
    v_emp_list emp_table_type;
    v_emp_rec employees%ROWTYPE;
    
    -- �߰� ����
    v_min employees.employee_id%TYPE;
    v_max v_min%TYPE;
    v_count NUMBER;
BEGIN
    -- employee_id �ּҰ�, �ִ밪
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    -- ���̺� ��ȸ
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)
        INTO v_count
        FROM employees
        WHERE employee_id = eid;
        -- �ش� �����ȣ ���� �����Ͱ� ���� ��� ���� ��������
        CONTINUE WHEN v_count = 0;
        
        SELECT *
        INTO v_emp_rec
        FROM employees
        WHERE employee_id = eid;
        
        v_emp_list(eid) := v_emp_rec;
    END LOOP;
    
    -- ���̺� Ÿ���� ������ ��ȸ
    FOR idx IN v_emp_list.FIRST .. v_emp_list.LAST LOOP
        IF v_emp_list.EXISTS(idx) THEN
            -- �ش� �ε����� �����Ͱ� �ִ� ���
            DBMS_OUTPUT.PUT(v_emp_list(idx).employee_id);
            DBMS_OUTPUT.PUT(', ' || v_emp_list(idx).last_name);
            DBMS_OUTPUT.PUT_LINE(', ' || v_emp_list(idx).salary);
        END IF;
    END LOOP;
END;
/

-- count(*)�� null ����, *��� �� ������ null ����
SELECT COUNT(*), COUNT(commission_pct)
FROM employees;


/*
����� Ŀ�� : ������ SELECT��
1) DECLARE : Ŀ�� ����
2) OPEN    : 1.Ŀ�� ���� -> Ȱ������  /  2.�����͸� �� ���� �̵�
3) FETCH   : 1.�����͸� ������ �̵�  /  2. ���� ����Ű�� �� �������
4) CLOSE   : Ȱ������ �Ҹ�
*/

-- ����� Ŀ�� : ���� �� SELECT���� �����ϱ� ���� PL/SQL ����
SELECT *
FROM employees;

-- 1) ����
DECLARE
    -- 1. Ŀ�� ����
    CURSOR Ŀ���� IS
        SELECT��(SQL�� SELECT��, INTO�� ���Ұ�);
    
BEGIN
    -- 2. Ŀ�� ����
    -- 2-1. Ŀ���� ���� �����ؼ� Ȱ������(���)�� �ĺ�
    -- 2-2. �����͸� ���� ���� ��ġ
    OPEN Ŀ����;
    
    -- 3. ������ ����
    -- 3-1. �����͸� �Ʒ��� �̵�
    -- 3-2. ���� ����Ű�� �����͸� ����
    FETCH Ŀ���� INTO ����;
    
    -- 4. Ŀ�� ���� : Ȱ������(���)�� ����
    CLOSE Ŀ����;
END;
/

-- ����
DECLARE
    -- 1. Ŀ�� ����
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
    
    -- INTO���� ����� ������ �ʿ� => Ŀ���� SELECT�� �÷� ������ŭ
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2. Ŀ�� ����
    OPEN emp_cursor;
    
    -- 3. Ŀ������ ������ ����
    FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
    
    -- 3.5 �����͸� ������� ����
    DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
    
    -- 4. Ŀ�� ����
    CLOSE emp_cursor;
END;
/

-- ����� Ŀ���� �Ӽ��� �⺻ LOOP��
DECLARE
    -- 1. Ŀ�� ����
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
    
    -- INTO���� ����� ������ �ʿ� => Ŀ���� SELECT�� �÷� ������ŭ
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2. Ŀ�� ����
    OPEN emp_cursor;
    
    LOOP
        -- 3. Ŀ������ ������ ����
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
        EXIT WHEN emp_cursor%NOTFOUND; -- ���ο� �������� ���� ���� Ȯ��
        -- Ŀ���� �������� �����ϸ� �ߺ� �����͸� ����, NOTFOUND�� ������ ������ Ȯ��
        -- FETCH�� EXIT WHEN�� ���� �����̰� �ۼ��� ��
        
        -- 3.5 �����͸� ������� ����
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : '); -- FETCH�� �����ؼ� ������ ���� ��
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
    END LOOP;
    
    -- ERROR 1 : Ŀ���� ����� ���¿��� �ٽ� ���� => cursor already open
    IF NOT emp_cursor%ISOPEN THEN -- Ŀ�� ���� ���� Ȯ��
        OPEN emp_cursor;
    END IF;
    
    -- 4. Ŀ�� ����
    CLOSE emp_cursor;
    
    -- ERROR 2 : Ŀ���� ����� ���¿��� �Ӽ� ��� => invalid cursor
--    DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT);
    
END;
/

-- ���ǻ��� : ����� Ŀ���� ����� ���� ��� ������ �߻����� ����
-- Ư�� �μ��� ���� ����� �����ȣ, �̸�, ������ ���
-- ����� Ŀ�� => SQL�� SELECT���� �䱸
SELECT employee_id, last_name, job_id
FROM employees
WHERE department_id = &�μ���ȣ;
-- �μ���ȣ 0  => ������ ����
-- �μ���ȣ 10 => ������ 1��
-- �μ���ȣ 50 => ������ 5��

DECLARE
    -- 1. Ŀ�� ����
    CURSOR emp_of_dept_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &�μ���ȣ;
    
    -- FETCH INTO���� ����� ���� ����
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_job employees.job_id%TYPE;
BEGIN
    -- 2. Ŀ�� ����
    OPEN emp_of_dept_cursor;
    
    LOOP
        -- 3. ������ ����
        FETCH emp_of_dept_cursor INTO v_eid, v_ename, v_job;
        EXIT WHEN emp_of_dept_cursor%NOTFOUND;
        
        -- ROWCOUNT : LOOP�� ���ο����� ������, ���� ��ȯ�� ������ ����
        DBMS_OUTPUT.PUT(emp_of_dept_cursor%ROWCOUNT || ' : ');
        
        -- 4. ������ ���� ���� �� ����
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_job);
    END LOOP;
    
    -- ROWCOUNT : LOOP�� �ٱ������� ������, Ŀ���� �� ������ ����
    DBMS_OUTPUT.PUT_LINE(emp_of_dept_cursor%ROWCOUNT);
    
    IF emp_of_dept_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �Ҽӻ���� �����ϴ�.');
    END IF;
    
    -- 5. Ŀ�� ����
    CLOSE emp_of_dept_cursor;
END;
/

/*
1.
���(employees) ���̺���
����� �����ȣ, ����̸�, �Ի翬����  => ����� Ŀ�� : ������ SELECT��
���� ���ؿ� �°� ���� test01, test02�� �Է��Ͻÿ�.

�Ի�⵵�� 2025��(����) ���� �Ի��� ����� test01 ���̺� �Է�
�Ի�⵵�� 2025�� ���� �Ի��� ����� test02 ���̺� �Է�
=> ���ǹ�
*/
-- 2015�� �������� ����
DECLARE
    -- Ŀ�� ����
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
    
    -- FETCH INTO�� ����
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
    
BEGIN
    -- Ŀ�� ����
    OPEN emp_cursor;
    
    LOOP
        -- ������ ���� : �����ȣ, �̸�, �Ի���
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        -- ������ ���
        -- 2015�� ����(����) �Ի��� -> test01
        IF TO_CHAR(v_hdate, 'yyyy') <= '2015' THEN -- TO_DATE�� ����� ��� ���϶� 20151231 �������� �ؾ���(��ü ������� �������� ���ؼ�)
            INSERT INTO test01 (empid, ename, hiredate)
            VALUES (v_eid, v_ename, v_hdate);
        ELSE -- 2015�� ���� �Ի��� -> test02
            INSERT INTO test02 (empid, ename, hiredate)
            VALUES (v_eid, v_ename, v_hdate);
        END IF;
    END LOOP;
    
    -- Ŀ�� ����
    CLOSE emp_cursor;
END;
/

-- 1���� RECORD ���
DECLARE
    -- Ŀ�� ����
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
    
    -- RECORD ����
    TYPE emp_recode_type IS RECORD(
        eid employees.employee_id%TYPE,
        ename employees.last_name%TYPE,
        hdate employees.hire_date%TYPE
    );
    v_emp_info emp_recode_type;
BEGIN
    -- Ŀ�� ����
    OPEN emp_cursor;
    
    LOOP
        -- ������ ���� : �����ȣ, �̸�, �Ի���
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        -- ������ ���
        -- 2015�� ����(����) �Ի��� -> test01
        IF TO_CHAR(v_emp_info.hdate, 'yyyy') <= '2015' THEN -- TO_DATE�� ����� ��� ���϶� 20151231 �������� �ؾ���(��ü ������� �������� ���ؼ�)
            INSERT INTO test01 (empid, ename, hiredate)
            VALUES (v_emp_info.eid, v_emp_info.ename, v_emp_info.hdate);
        ELSE -- 2015�� ���� �Ի��� -> test02
            INSERT INTO test02 -- RECORD ���� ���� ��� ���̺��� �÷��� �ۼ��ϸ� �ȵ�
            VALUES v_emp_info; -- ���̺�� RECORD �÷��� ���ƾ� ��
        END IF;
    END LOOP;
    
    -- Ŀ�� ����
    CLOSE emp_cursor;
END;
/

-- ��� Ȯ��
select *
from test01;

DELETE FROM test02;

/*
2.
�μ���ȣ�� �Է��� ���(&ġȯ���� ���)
�ش��ϴ� �μ��� ����̸�, �Ի�����, �μ����� ����Ͻÿ�.
*/
DECLARE
    -- Ŀ�� ���� - �μ���ȣ �Է½� �μ��� ����̸�, �Ի���, �μ��� �˻�
    CURSOR emp_dept_cursor IS
        SELECT e.last_name, e.hire_date, d.department_name
        FROM employees e JOIN departments d
                         ON (e.department_id = d.department_id)
        WHERE e.department_id = &�μ���ȣ;
        
    -- FETCH INTO�� ����
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    -- Ŀ�� ����
    OPEN emp_dept_cursor;
    
    LOOP
        -- ������ ���� : ����̸�, �Ի���, �μ���
        FETCH emp_dept_cursor INTO v_ename, v_hdate, v_dname;
        EXIT WHEN emp_dept_cursor%NOTFOUND;
        
        -- ������ ��� : �μ��� ����̸�, �Ի���, �μ��� ���
        DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_hdate || ', ' || v_dname);
    END LOOP;
    
    -- Ŀ�� ����
    CLOSE emp_dept_cursor;
END;
/

SELECT employee_id, department_id
FROM employees
ORDER BY department_id;

/*
3.
�μ���ȣ�� �Է�(&���)�� ��� 
����̸�, �޿�, ����->(�޿�*12+(�޿�*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))
�� ����ϴ�  PL/SQL�� �ۼ��Ͻÿ�.
*/
DECLARE
    -- Ŀ�� ���� : �μ���ȣ �Է� / �̸�, �޿�, Ŀ�̼� ���
    CURSOR emp_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id = &�μ���ȣ;
        
    -- FETCH INTO�� ����
    v_ename employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_com_pct employees.commission_pct%TYPE;
    
    -- ���� ����
    v_year_salary NUMBER;
BEGIN
    -- Ŀ�� ����
    OPEN emp_cursor;
    
    LOOP
        -- ������ ���� : �̸�, �޿�, ���ʽ�
        FETCH emp_cursor INTO v_ename, v_salary, v_com_pct;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        -- ������ ���
        -- ���� = (�޿�*12+(�޿�*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))
        v_year_salary := v_salary * 12 + (v_salary * NVL(v_com_pct,0) * 12);
        -- �̸�, �޿�, ���� ���
        DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_salary || ', ' || v_year_salary);
    END LOOP;
    
    -- Ŀ�� ����
    CLOSE emp_cursor;
END;
/












