-- <2024-11-28>

SET SERVEROUTPUT ON

-- FUNCTION : �ַ� ����ϴ� �뵵�� ���� ����ϴ� ��ü
-- => DML ���� VARCHAR2, NUMBER, DATE �� SQL���� ����ϴ� ������ Ÿ������ ��ȯ�� ��� SQL���� �Բ� ��� ����
-- 1) ����
CREATE FUNCTION �Լ���
    ( �Ű������� ������Ÿ��, ...) -- IN ���θ� ��밡���ϹǷ� ���� ����
    RETURN ����Ÿ��
IS
    -- ����� : ����, Ŀ��, ���ܻ��� ���� ����
BEGIN
    -- �����ϰ��� �ϴ� �ڵ�
    RETURN ���ϰ�;
EXCEPTION
    WHEN �����̸� THEN
        -- ����ó�� �ڵ�
        RETURN ���ϰ�;
END;
/

-- 2) ����
CREATE FUNCTION test_func
    (p_msg VARCHAR2)
    RETURN VARCHAR2
IS
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    RETURN (v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '�����Ͱ� �������� �ʽ��ϴ�.';
END;
/

-- 3) ����
-- 3-1) PL/SQL���
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    -- �Լ� ȣ��� �ݵ�� ������ �ʿ�
    v_result := test_func('PL/SQL');
    
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
-- 3-2) SQL��
SELECT test_func('SQL')
FROM dual; -- �׽�Ʈ�� ���̺�

-- ���ϱ�
CREATE FUNCTION y_sum
    (p_x NUMBER,
     p_y NUMBER)
    RETURN NUMBER
IS

BEGIN
    RETURN (p_x + p_y);
END;
/
DECLARE
    v_sum NUMBER(10, 0);
BEGIN
    v_sum := y_sum(10, 5);
    
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

SELECT y_sum(20, 5)
FROM dual;

-- �����ȣ�� �Է¹޾� �ش� ����� ���ӻ�� �̸��� ���
-- ���� SELECT��
SELECT e.employee_id, m.last_name
FROM employees e JOIN employees m ON (e.manager_id = m.employee_id)
ORDER BY employee_id;

-- �Լ� ���
SELECT employee_id, get_mgr(employee_id)
FROM employees
ORDER BY employee_id;

DROP FUNCTION get_mgr;
CREATE FUNCTION get_mgr
    (p_eid employees.employee_id%TYPE)
    RETURN VARCHAR2
IS
    v_mname employees.last_name%TYPE;
BEGIN
    SELECT m.last_name
    INTO v_mname
    FROM employees e JOIN employees m ON (e.manager_id = m.employee_id)
    WHERE e.employee_id = p_eid;
    
    RETURN v_mname;
END;
/

-- ������ ���ν���, �Լ� ���� Ȯ���ϴ� ���
SELECT name, line, text
FROM user_source;

SELECT name, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION');


/*
1.
�����ȣ�� �Է��ϸ� 
last_name + first_name �� ��µǴ� 
y_yedam �Լ��� �����Ͻÿ�.

����) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
��� ��)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
DROP FUNCTION y_yedam;
CREATE FUNCTION y_yedam
    (p_eid employees.employee_id%TYPE) -- �����ȣ �Է�
    RETURN VARCHAR2 -- �̸� ��ȯ
IS
    v_full_name VARCHAR2(100);
BEGIN
    -- last_name, first_name �˻�
    SELECT first_name || ' ' || last_name
    INTO v_full_name
    FROM employees
    WHERE employee_id = p_eid;
    
    RETURN v_full_name;
END;
/
SELECT employee_id, y_yedam(employee_id)
FROM   employees;

/*
2.
�����ȣ�� �Է��� ��� ���� ������ �����ϴ� ����� ��µǴ� ydinc �Լ��� �����Ͻÿ�.
- �޿��� 5000 �����̸� 20% �λ�� �޿� ���
- �޿��� 10000 �����̸� 15% �λ�� �޿� ���
- �޿��� 20000 �����̸� 10% �λ�� �޿� ���
- �޿��� 20000 �ʰ��̸� �޿� �״�� ���
����) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees; 
*/
DROP FUNCTION ydinc;
CREATE FUNCTION ydinc
    (p_eid employees.employee_id%TYPE) -- �����ȣ �Է�
    RETURN NUMBER -- �λ�� �޿� ��ȯ
IS
    v_sal employees.salary%TYPE;
    v_inc_sal NUMBER; -- �λ�� �޿� ����
BEGIN
    -- �޿� �˻�
    SELECT salary
    INTO v_sal
    FROM employees
    WHERE employee_id = p_eid;
    
    -- �޿� �λ�
    IF v_sal <= 5000 THEN
        v_inc_sal := v_sal * 1.2;
    ELSIF v_sal <= 10000 THEN
        v_inc_sal := v_sal * 1.15;
    ELSIF v_sal <= 20000 THEN
        v_inc_sal := v_sal * 1.1;
    ELSE
        v_inc_sal := v_sal;
    END IF;
    
    RETURN v_inc_sal;
END;
/
SELECT last_name, salary, YDINC(employee_id)
FROM   employees; 

/*
3.
�����ȣ�� �Է��ϸ� �ش� ����� ������ ��µǴ� yd_func �Լ��� �����Ͻÿ�.
->������� : (�޿�+(�޿�*�μ�Ƽ���ۼ�Ʈ))*12
����) SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;  
*/
DROP FUNCTION yd_func;
CREATE FUNCTION yd_func
    (p_eid employees.employee_id%TYPE) -- �����ȣ �Է�
    RETURN NUMBER -- ���� ���
IS
    v_sal employees.salary%TYPE;
    v_com employees.commission_pct%TYPE;
    v_year_sal NUMBER; -- ����
BEGIN
    -- �޿� �˻�
    SELECT salary, commission_pct
    INTO v_sal, v_com
    FROM employees
    WHERE employee_id = p_eid;
    
    -- ���� ���
    v_year_sal := (v_sal + (v_sal * NVL(v_com, 0))) * 12;
    
    RETURN v_year_sal;
END;
/
SELECT last_name, salary, yd_func(employee_id)
FROM   employees;



































