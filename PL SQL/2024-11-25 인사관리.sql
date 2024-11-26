-- <2024-11-25>

-- [SQL Ŀ��]

-- �Ͻ��� Ŀ�� : SQL���� ���� ����� ���� �޸� ����
-- => �� ���� : DML�� ������ Ȯ��, SQL%ROWCOUNT  ==> �Ͻ��� Ŀ���� �̸��� ��� SQL�� �������� ������
-- => ���ǻ��� : ������ ����� SQL���� ����� Ȯ�� ����
SET SERVEROUTPUT ON

BEGIN
    DELETE FROM employees
    WHERE employee_id = 0;

    DBMS_OUTPUT.PUT_LINE(SQL%rowcount || '���� �����Ǿ����ϴ�.');
END;
/


-- employees ������ Ȯ�ο�
SELECT employee_id
FROM employees
WHERE employee_id NOT IN (
            SELECT manager_id
            FROM employees
            WHERE manager_id IS NOT NULL
            UNION
            SELECT manager_id
            FROM departments
            WHERE manager_id IS NOT NULL
        );

ROLLBACK;

-- [���ǹ�]
-- 1) �⺻ IF �� : Ư�� ������ TRUE �� ��츸
BEGIN
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;

    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('���������� �����Ǿ����ϴ�.');
    END IF;
END;
/

-- 2) IF ~ ELSE �� : Ư�� ������ �������� TRUE/FALSE ��� Ȯ��
BEGIN
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT >= 1 THEN
        -- ���ǽ��� TRUE�� ���
        DBMS_OUTPUT.PUT_LINE('���������� �����Ǿ����ϴ�.');
    ELSE
        -- ���� ������ ��� ���ǽ��� FALSE�� ���
        DBMS_OUTPUT.PUT_LINE('�������� �ʾҽ��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('�����ȣ�� Ȯ�����ּ���.');
    END IF;
END;
/

-- 3) IF ~ ELSEIF ~ ELSE �� : ���� ������ ������� �� ����� ���� ó��
DECLARE
    v_score NUMBER(2,0) := &����;
    v_grade CHAR(1);
BEGIN
    IF v_score >= 90 THEN -- v_score�� ������ �ִ밪�� �ּҰ� ��� : �ּҰ� < v_score < �ִ밪
        v_grade := 'A';
        DBMS_OUTPUT.PUT_LINE('90 <= ' || v_score || ' < 100');
    ELSIF v_score >= 80 THEN
        v_grade := 'B';
        DBMS_OUTPUT.PUT_LINE('80 <= ' || v_score || ' < 90');
    ELSIF v_score >= 70 THEN
        v_grade := 'C';
        DBMS_OUTPUT.PUT_LINE('70 <= ' || v_score || ' < 80');
    ELSIF v_score >= 60 THEN
        v_grade := 'D';
        DBMS_OUTPUT.PUT_LINE('60 <= ' || v_score || ' < 70');
    ELSE
        v_grade := 'F';
        DBMS_OUTPUT.PUT_LINE('0 <= ' || v_score || ' < 60');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_grade);
END;
/


-- �����ȣ�� �Է¹޾� �ش� ����� ����(JOB_ID)�� ������ ���('SA'�� ���Ե� ���)�� Ȯ�����ּ���.
-- ��¹��� : �ش� ����� �������� �����о� �Դϴ�.

DECLARE
    v_jid employees.job_id%TYPE; -- job_id
BEGIN
    -- 1. �����ȣ �Է�
    SELECT job_id
    INTO v_jid
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    -- 2. �ش� ����� ������ ������ ��� Ȯ��
    IF UPPER(v_jid) LIKE '%SA%' THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �����о� �Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� ' || v_jid || ' �ƴմϴ�.');
    END IF;
END;
/


/*
3.
�����ȣ�� �Է�(ġȯ�������&)�� ���
�Ի����� 2025�� ����(2025�� ����)�̸� 'New employee' ���
      2025�� �����̸� 'Career employee' ���
��, DBMS_OUTPUT.PUT_LINE ~ �� �ѹ��� ���
*/
select * 
from employees;

DECLARE
    v_hdate employees.hire_date%TYPE;
    v_msg VARCHAR(100);
BEGIN
    -- �����ȣ �Է�
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    -- �Ի��� üũ
    --IF v_hdate >= TO_DATE('20250101', 'yyyyMMdd') THEN
    IF TO_CHAR(v_hdate, 'yyyy') >= '2025' THEN
        v_msg := 'New employee';
    ELSE
        v_msg := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/
select *
from employees
order by hire_date desc;
/*
4.
create table test01(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

create table test02(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

�����ȣ�� �Է�(ġȯ�������&)�� ���
����� �� 2025�� ����(2025�� ����)�� �Ի��� ����� �����ȣ, 
����̸�, �Ի����� test01 ���̺� �Է��ϰ�, 2025�� ������ 
�Ի��� ����� �����ȣ,����̸�,�Ի����� test02 ���̺� �Է��Ͻÿ�.
*/
select *
from test01;
select *
from test02;

DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    --�����ȣ �Է�, �Ի��� ����
    SELECT employee_id, last_name, hire_date
    INTO v_eid, v_ename, v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    --25�� ���� �Ի� -> (empid, ename, hiredate) test01�Է�
    IF TO_CHAR(v_hdate, 'yyyy') >= '2025' THEN
        INSERT INTO test01 (empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    --25�� ���� �Ի� -> (empid, ename, hiredate) test02�Է�
    ELSE
        INSERT INTO test02 (empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    END IF;
END;
/

/*
5.
�޿���  5000�����̸� 20% �λ�� �޿�
�޿��� 10000�����̸� 15% �λ�� �޿�
�޿��� 15000�����̸� 10% �λ�� �޿�
�޿��� 15001�̻��̸� �޿� �λ����

�����ȣ�� �Է�(ġȯ����)�ϸ� ����̸�, �޿�, �λ�� �޿��� ��µǵ��� PL/SQL ����� �����Ͻÿ�.
*/
select employee_id, salary
from employees;

DECLARE
    v_ename employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_inc_salary NUMBER(15);
BEGIN
    --�����ȣ �Է� / �̸� �� �޿� ����
    SELECT last_name, salary
    INTO v_ename, v_salary
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF v_salary <= 5000 THEN --�޿���  5000�����̸� 20% �λ�� �޿�
        v_inc_salary := v_salary * 1.2;
    ELSIF v_salary <= 10000 THEN --�޿��� 10000�����̸� 15% �λ�� �޿�
        v_inc_salary := v_salary * 1.15;
    ELSIF v_salary <= 15000 THEN --�޿��� 15000�����̸� 10% �λ�� �޿�
        v_inc_salary := v_salary * 1.1;
    ELSE --�޿��� 15001�̻��̸� �޿� �λ����
        v_inc_salary := v_salary;
    END IF;
    
    -- �̸�, �޿�, �λ�޿� ���
    DBMS_OUTPUT.PUT_LINE(v_ename || ' | ' || v_salary || ' | ' || v_inc_salary);
    
    
    --[�ٸ� ���]
--    IF v_salary <= 5000 THEN --�޿���  5000�����̸� 20% �λ�� �޿�
--        v_raise := 20;
--    ELSIF v_salary <= 10000 THEN --�޿��� 10000�����̸� 15% �λ�� �޿�
--        v_raise := 15;
--    ELSIF v_salary <= 15000 THEN --�޿��� 15000�����̸� 10% �λ�� �޿�
--        v_raise := 10;
--    ELSE --�޿��� 15001�̻��̸� �޿� �λ����
--        v_raise := 0;
--    END IF;
--    v_new_sal = v_sal + v_sal * (v_raise /100);
--    DBMS_OUTPUT.PUT_LINE(v_ename || ' | ' || v_salary || ' | ' || v_new_sal);
END;
/


-- [LOOP��]

-- �⺻ LOOP�� : ���Ǿ��� ���� LOOP���� �ǹ� -> �ݵ�� EXIT���� �����϶�� ����
-- 1) ����
/*
BEGIN
    LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
        EXIT WHEN -- ���� ������ �ǹ�
    END LOOP;
END;
/
*/

-- 2) ����
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        EXIT;
    END LOOP;
END;
/

DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        
        -- LOOP���� �����ϴ� �ڵ�
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
    END LOOP;
END;
/

-- 1���� 10���� ������ ���� ���ϱ�
DECLARE
    v_count NUMBER(2,0) := 1;
    v_sum NUMBER(3,0) := 0;
BEGIN
    LOOP
        -- �ݺ� �ڵ� : 1~10���� ��;
        v_sum := v_sum + v_count;
        
        -- ���� �ڵ� : 10�� �ݺ��� ����
        v_count := v_count + 1;
        EXIT WHEN v_count > 10;
    END LOOP;
    
    -- �� ���
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

/*
6. ������ ���� ��µǵ��� �Ͻÿ�.
*         
**        
***       
****     
*****    
*/
DECLARE
    v_star VARCHAR2(10) := '';
    v_cnt NUMBER(2,0) := 0;
BEGIN
    LOOP
        -- ��ǥ ���
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
        
        -- ���� �ڵ�
        v_cnt := v_cnt + 1;
        EXIT WHEN v_cnt >= 5;
--        EXIT WHEN LENGTH(v_star) >= 5;
    END LOOP;
END;
/

/*
7. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� 
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½� �Ʒ��� ���� ���
2 * 1 = 2
2 * 2 = 4
...
*/
DECLARE
    v_num NUMBER(3,0) := 1;
    v_dan NUMBER(2,0);
BEGIN
    -- ���� �Է�
    v_dan := &�Է�;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('===' || v_dan || '��===');
    
    LOOP
        -- ������ ���
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
        
        -- ���� �ڵ�
        v_num := v_num + 1;
        EXIT WHEN v_num > 9;
    END LOOP;
END;
/

/*
8. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
*/
DECLARE
    v_num NUMBER(3,0) := 1;
    v_dan NUMBER(2,0) := 2;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('===' || v_dan || '��===');
        LOOP
            -- ������ ���
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
            
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
        END LOOP;
        
        -- �ܼ� ���� �� ī��Ʈ �ʱ�ȭ
        v_num := 1;
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

-- WHILE LOOP�� : Ư�� ������ �����ϴ� ���� �ݺ��ϴ� LOOP�� => ��쿡 ���� ���� �ȵǴ� ��� ����
-- 1) ����
DECLARE

BEGIN
    WHILE �ݺ����� LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
    END LOOP;
END;
/

-- 2) ����
DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    WHILE v_count < 5 LOOP -- ��Ȯ�� �ݺ� ���� ǥ��
        --�ݺ��ϰ��� �ϴ� �ڵ�
        DBMS_OUTPUT.PUT_LINE('Hello !!');
        
        -- LOOP���� �����ϴ� �ڵ�
        v_count := v_count + 1;
    END LOOP;
END;
/

-- 1���� 10���� ������ ���� ���ϱ�
DECLARE
    v_num NUMBER(2,0) := 1;
    v_sum NUMBER(3,0) := 0;
BEGIN
    -- 10�����϶� �ݺ�
    WHILE v_num <= 10
    LOOP
        -- 1~10 ���ϱ�
        v_sum := v_sum + v_num;
        
        -- ���� �ڵ�
        v_num := v_num + 1;
    END LOOP;
    
    -- �հ� ���
    DBMS_OUTPUT.PUT_LINE('���� = ' || v_sum);
END;
/

-- 6,7,8�� ���� WHILE������ Ǯ��
/*
6. ������ ���� ��µǵ��� �Ͻÿ�.
*         
**        
***       
****     
*****    
*/
DECLARE
    v_star VARCHAR2(10) := '*'; -- v_star := '' => NULL�� �ν�(LENGTH �Լ� ���� �ȵ�)
BEGIN
    -- ���� 5�����϶� �ݺ�
    WHILE LENGTH(v_star) <= 5 -- NVL(LENGTH(v_star),0) -> NULL üũ �ϰ� ������ ���
    LOOP
        -- ��ǥ ���
        DBMS_OUTPUT.PUT_LINE(v_star);
        
        -- ��ǥ ����
        v_star := v_star || '*';
    END LOOP;
END;
/

/*
7. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� 
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½� �Ʒ��� ���� ���
2 * 1 = 2
2 * 2 = 4
...
*/
DECLARE
    v_num NUMBER(3,0) := 1;
    v_dan NUMBER(2,0) := &�ܼ�; -- ���� ����� ���ÿ� �Է�
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('===' || v_dan || '��===');
    
    WHILE v_num <= 9 
    LOOP
        -- ������ ���
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
        
        -- ���� �ڵ�
        v_num := v_num + 1;
    END LOOP;
END;
/

/*
8. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
*/
DECLARE
    v_num NUMBER(3,0) := 1;
    v_dan NUMBER(2,0) := 2;
BEGIN
    WHILE v_dan <= 9 
    LOOP
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('===' || v_dan || '��===');
        
        -- ������ ���
        WHILE v_num <= 9 
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
            
            v_num := v_num + 1;
        END LOOP;
        
        -- ���� �ڵ� : �ܼ� ���� / ���� �ʱ�ȭ
        v_num := 1;
        v_dan := v_dan + 1;
    END LOOP;
END;
/

-- FOR LOOP�� : ������ ���� �� ��� ������ ������ŭ �ݺ�
-- 1) ����
BEGIN
    FOR �ӽ� ���� IN �ּҰ� .. �ִ밪 LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
    END LOOP;
    -- �ӽú��� : ����Ÿ��, DECLARE���� ���� �������� ����, �ݵ�� �ּҰ��� �ִ밪 ������ �������� ���� => Readonly
    -- �ּҰ�, �ִ밪 : ����, �ݵ�� �ּҰ� <= �ִ밪
END;
/

-- 2) ����
BEGIN
    FOR idx IN 1 .. 5 LOOP
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

BEGIN
    FOR idx IN -10 .. -6 LOOP
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

DECLARE
    v_max NUMBER(2,0) := &�ִ밪;
BEGIN
    FOR idx IN 5 .. v_max LOOP -- v_max�� 5���� ���� ��� LOOP���� ������� ����
--        idx := 10; : FOR LOOP���� �ӽú����� ���� �Ұ�
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

BEGIN
    FOR idx IN REVERSE 1 .. 5 LOOP -- REVERSE : ���� ���� �����ϴ� ���� ���� ������������ ������ ��
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

-- 1���� 10������ ������ ���� ���ϱ�
DECLARE
    v_sum NUMBER(3,0) := 0;
BEGIN
    -- 1~10 ���ϱ�
    FOR num IN 1 .. 10 LOOP
        v_sum := v_sum + num;
    END LOOP;
    
    -- ���� ���
    DBMS_OUTPUT.PUT_LINE('���� = ' || v_sum);
END;
/

-- 6,7,8�� ���� FOR LOOP������ Ǯ��
/*
6. ������ ���� ��µǵ��� �Ͻÿ�.
*         
**        
***       
****     
*****    
*/
DECLARE
    v_star VARCHAR2(10):= '';
BEGIN
    FOR idx in 1 .. 5 LOOP -- 5ȸ �ݺ�
        -- �� ����
        v_star := v_star || '*';
        
        -- �� ���
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;
END;
/

/*
7. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� 
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½� �Ʒ��� ���� ���
2 * 1 = 2
2 * 2 = 4
...
*/
DECLARE
    v_dan NUMBER(2,0) := &�ܼ�; -- �ܼ� �Է�
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('===' || v_dan || '��===');
    
    FOR num IN 1 .. 9 LOOP -- ���ϴ� �� : 1~9
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || num || ' = ' || (v_dan * num));
    END LOOP;
END;
/

/*
8. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
*/
BEGIN
    FOR dan IN 2 .. 9 LOOP -- �ܼ� ���� LOOP��
        -- ������� ���
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('===' || dan || '��===');
        
        FOR num IN 1 .. 9 LOOP -- ���� ���� LOOP��
            DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num || ' = ' || (dan * num));
        END LOOP;
    END LOOP;
END;
/

-- 6���� DECLARE ���� 2�� FOR LOOP������ �ۼ�
-- DBMS_OUTPUT.PUT();
BEGIN
    FOR i IN 1 .. 5 LOOP
        FOR j IN 1 .. i LOOP -- �� ���
            DBMS_OUTPUT.PUT('*'); -- PUT �ܵ����δ� ��� �ȵ�(PUT_LINE���� ���� ���� �Է��ؾ� ���)
        END LOOP;
        
        -- ���� �ٷ� �Ѿ
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 8�� �������� ���η� ���
BEGIN
    FOR num IN 0 .. 9 LOOP -- �ܼ� ���� LOOP��
        -- ������� ���
        IF num = 0 THEN
            FOR dan IN 2 .. 9 LOOP
                DBMS_OUTPUT.PUT('  == ' || dan || '�� ==   ');
            END LOOP;
        ELSE
            FOR dan IN 2 .. 9 LOOP
                IF dan * num >= 10 THEN
                    DBMS_OUTPUT.PUT(dan || ' X ' || num || ' = ' || (dan * num));
                ELSE
                    DBMS_OUTPUT.PUT(dan || ' X ' || num || ' =  ' || (dan * num));
                END IF;
                
                DBMS_OUTPUT.PUT('    ');
            END LOOP;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/






