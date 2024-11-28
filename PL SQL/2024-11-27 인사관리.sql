-- <2024-11-27>

SET SERVEROUTPUT ON

-- [Ŀ�� FOR LOOP]

-- Ŀ�� FOR LOOP : ����� Ŀ���� ����ϴ� ���� ���
-- 1) ����
DECLARE
    CURSOR Ŀ���� IS
        SELECT��;
BEGIN
    FOR �ӽú���(���ڵ�Ÿ��) IN Ŀ���� LOOP -- �Ͻ������� OPEN�� FETCH
        -- Ŀ���� �����Ͱ� �����ϴ� ��� �����ϴ� �ڵ�
    END LOOP; -- �Ͻ������� CLOSE
END;
/

-- 2) ����
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id eid, last_name ename, salary sal
        FROM employees
        WHERE department_id = &�μ���ȣ;
BEGIN
    FOR emp_rec IN emp_dept_cursor LOOP
        DBMS_OUTPUT.PUT(emp_dept_cursor%ROWCOUNT || ' : ' );
        DBMS_OUTPUT.PUT(emp_rec.eid);
        DBMS_OUTPUT.PUT(', ' || emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.sal);
    END LOOP;
END;
/

-- �μ���ȣ�� �Է¹޾� �ش� �μ��� �Ҽӵ� �������(�����ȣ, �̸�, �޿�)�� ����ϼ���.
-- �μ���ȣ 0  : Ŀ���� �����Ͱ� ����
-- �μ���ȣ 50 : Ŀ���� �����Ͱ� ������
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id eid, last_name ename, salary sal
        FROM employees
        WHERE department_id = &�μ���ȣ;
BEGIN
    FOR emp_rec IN emp_dept_cursor LOOP
        DBMS_OUTPUT.PUT(emp_dept_cursor%ROWCOUNT || ' : ' );
        DBMS_OUTPUT.PUT(emp_rec.eid);
        DBMS_OUTPUT.PUT(', ' || emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.sal);
    END LOOP; -- �Ͻ������� CLOSE
    
    -- �̹� ���� Ŀ���� ����Ϸ� �ؼ� invalid cursor ����
    DBMS_OUTPUT.PUT_LINE('�� ������ ���� : ' || emp_dept_cursor%ROWCOUNT);
END;
/

-- Ŀ�� FOR LOOP ���� ��� ����� Ŀ���� �����͸� ������ �� �������� ���

/*
1.
���(employees) ���̺���
����� �����ȣ, ����̸�, �Ի翬���� 
���� ���ؿ� �°� ���� test01, test02�� �Է��Ͻÿ�.

�Ի�⵵�� 2025��(����) ���� �Ի��� ����� test01 ���̺� �Է�
�Ի�⵵�� 2025�� ���� �Ի��� ����� test02 ���̺� �Է�
*/
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        -- 2015��(����) ���� �Ի��� -> test01
        IF TO_CHAR(emp_rec.hire_date, 'yyyy') <= '2015' THEN
            INSERT INTO test01 (empid, ename, hiredate)
            VALUES (emp_rec.employee_id, emp_rec.last_name, emp_rec.hire_date);
        -- 2015��(����) ���� �Ի��� -> test02
        ELSE
            INSERT INTO test02
            VALUES emp_rec;
        END IF;
    END LOOP;
END;
/

SELECT *
FROM test02;

DELETE FROM test01;

/*
2.
�μ���ȣ�� �Է��� ���(&ġȯ���� ���)
�ش��ϴ� �μ��� ����̸�, �Ի�����, �μ����� ����Ͻÿ�.
*/
DECLARE
    -- �μ���ȣ �Է� / ��� ���� �˻�
    CURSOR emp_dept_cursor IS
        SELECT e.last_name ename, e.hire_date hdate, d.department_name dname
        FROM employees e JOIN departments d
                         ON (e.department_id = d.department_id)
        WHERE e.department_id = &�μ���ȣ;
BEGIN
    FOR emp_dept_rec IN emp_dept_cursor LOOP
        -- ����̸�, �Ի�����, �μ��� ���
        DBMS_OUTPUT.PUT_LINE(emp_dept_rec.ename || ', ' || emp_dept_rec.hdate || ', ' || emp_dept_rec.dname);
    END LOOP;
END;
/

-- Ŀ�� FOR LOOP���� ���������� �̿��ؼ� ���� ����(��, �Ӽ��� ���Ұ�)
BEGIN
    -- FOR LOOP�� ����
    FOR emp_dept_rec IN (SELECT last_name, hire_date, department_name
                         FROM employees e JOIN departments d
                                          ON (e.department_id = d.department_id)
                         WHERE e.department_id = &�μ���ȣ)
    LOOP -- FOR LOOP�� �ݺ� ����
        -- ����̸�, �Ի�����, �μ��� ���
        DBMS_OUTPUT.PUT_LINE(emp_dept_rec.last_name || ', ' || emp_dept_rec.hire_date || ', ' || emp_dept_rec.department_name);
    END LOOP;
END;
/

/*
3.
�μ���ȣ�� �Է�(&���)�� ��� 
����̸�, �޿�, ����->(�޿�*12+(�޿�*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))
�� ����ϴ�  PL/SQL�� �ۼ��Ͻÿ�.
*/
DECLARE
    -- �μ���ȣ �Է� / ��� ���� �˻�
    CURSOR emp_cursor IS
        SELECT last_name ename, salary sal, (salary * 12 + (salary * NVL(commission_pct,0) * 12)) yearsal
        FROM employees
        WHERE department_id = &�μ���ȣ;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        -- ����̸�, �޿�, ���� ���
        DBMS_OUTPUT.PUT_LINE(emp_rec.ename || ', ' || emp_rec.sal || ', ' || emp_rec.yearsal);
    END LOOP;
END;
/


-- [����ó��]

-- ����ó�� : ���ܰ� �߻����� �� ���������� �۾��� ����� �� �ֵ��� ó��
-- 1) ����
DECLARE

BEGIN

EXCEPTION
    WHEN �����̸� THEN -- �ʿ��� ��ŭ �߰� ����
        --���� �߻��� ó���ϴ� �ڵ�
    WHEN OTHERS THEN -- ���� ���ǵ� ���ܸ��� �߻��ϴ� ��� �ϰ� ó��
        --���� �߻��� ó���ϴ� �ڵ�
END;
/

-- 2) ����
-- 2-1) �̹� ����Ŭ�� ���ǵǾ� �ְ�(�����ڵ尡 ����) �̸��� �����ϴ� ���ܻ���
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &�μ���ȣ;
    -- �μ���ȣ 0  : ORA-01403, NO_DATA_FOUND
    -- �μ���ȣ 10 : �������
    -- �μ���ȣ 50 : ORA-01422, TOO_MANY_ROWS
    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� ���� ����� �����ϴ�.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��Ÿ ���ܻ����� �߻��߽��ϴ�.');
        
        -- ���� �޼����� ���� �и��ؼ� ���
        -- OTHERS���� ó���� ������ �������� Ȯ���ϱ� ���� �ڵ�
        DBMS_OUTPUT.PUT_LINE('ORA' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 12));
        
        DBMS_OUTPUT.PUT_LINE('����� ����Ǿ����ϴ�.'); -- ����ó���� ���� Ȯ������ �ʾƼ� �鿩���� ���� �ȹ���
END;
/
-- 2-2) �̹� ����Ŭ�� ���ǵǾ� �ְ�(�����ڵ尡 ����) �̸��� �������� �ʴ� ���ܻ���
DECLARE
    -- �ڵ� ���� �� ó���ϴ� �۾�
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
    -- �μ���ȣ 10 : ORA-02292: integrity constraint (HR.EMP_DEPT_FK) violated - child record found

EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �ٸ� ���̺��� ��� ���Դϴ�.');
END;
/
-- 2-3) ����� ���� ���� => ����Ŭ ���忡�� �����ڵ�� ����
DECLARE
    e_dept_del_fail EXCEPTION;
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
    -- �μ���ȣ 0 : ���������� ��������� ��ɻ� ���з� �����ؾ� �ϴ� ���
    
    IF SQL%ROWCOUNT = 0 THEN -- ����� ����� ���� ���
        RAISE e_dept_del_fail; -- ���� ���� �߻� �ڵ�
    END IF;
EXCEPTION
    WHEN e_dept_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �������� �ʽ��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('�μ���ȣ�� Ȯ�����ּ���.');
END;
/
-- 2-3 => ����� ���� ���� ������ : EXCEPTION�� �ݵ�� ��� �ϴ� ���� �ƴ�
-- ==> ����ó���� ���� ����, �߿��� �۾����� ����ó���� �帧�� ����� �ϴ� ��쿡 ����� ���� ���� ó�� ���
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
    -- �μ���ȣ 0 : ���������� ��������� ��ɻ� ���з� �����ؾ� �ϴ� ���
    
    IF SQL%ROWCOUNT = 0 THEN -- ����� ����� ���� ��� => EXCEPTION�� ������� �ʰ� �ٷ� �����޼��� ���
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �������� �ʽ��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('�μ���ȣ�� Ȯ�����ּ���.');
    END IF;
END;
/

/*
1.
drop table emp_test;

create table emp_test
as
  select employee_id, last_name
  from   employees
  where  employee_id < 200;

emp_test ���̺��� �����ȣ�� ���(&ġȯ���� ���)�Ͽ� ����� �����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
(��, ����� ���� ���ܻ��� ���)
(��, ����� ������ "�ش����� �����ϴ�.'��� �����޽��� �߻�)
*/
DECLARE
    -- ����� ���� ���ܻ��� ����
    emp_del_fail EXCEPTION;
BEGIN
    -- emp_test ���̺��� ���� ����
    DELETE FROM emp_test
    WHERE employee_id = &�����ȣ;
    
    -- ����� ����� ���� ���
    IF SQL%ROWCOUNT = 0 THEN
        RAISE emp_del_fail; -- ���� ���� �߻� �ڵ�
    END IF;
EXCEPTION
    -- ������ ����� ���� ��� �����޼��� ���
    WHEN emp_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�.');
END;
/

SELECT *
FROM emp_test
ORDER BY employee_id;


-- [���ν���]

-- PROCEDURE
-- 1)����
CREATE PROCEDURE ���ν�����
    ( �Ű������� [���] ������Ÿ��, ... )
IS
    -- ����� : ���ú���, Ŀ��, ���ܻ��� ���� ����  => DECLARE ������ ������ DECLARE���� �������� ����(�浹)
BEGIN
    -- PROCEDURE�� ������ �ڵ�
EXCEPTION
    -- ����ó��
END;
/

-- 2) ����
CREATE PROCEDURE test_pro
    (p_msg VARCHAR2) -- �Ͻ������� IN���� ����, �Ű������� ũ������ �ȵ�
IS
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�����Ͱ� �������� �ʽ��ϴ�.');
END;
/

-- ���ν��� ����
DROP PROCEDURE test_pro;

-- 3) ����
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    -- ����Ŭ�� ���� �����ϴ� ��ü�� PROCEDURE���� FUNCTION���� �����ϴ� ���
    -- => ȣ������ (���ʿ� ������ �����ϴ� �� == �����͸� ���� �� �ִ� ��)
--    v_result := test_pro('PL/SQL'); => �Լ��� �ν�
    test_pro('PL/SQL');
END;
/

-- ���ν��� ���� ��ɾ�(�ϳ��� �����ϰ� ����� ��) => �׽�Ʈ��
EXECUTE test_pro('WORLD');


-- IN ��� : ȣ��ȯ�� -> ���ν����� ���� ����, ���ν��� ���ο��� ��� ���
DROP PROCEDURE raise_salary;
CREATE PROCEDURE raise_salary
    ( p_eid IN employees.employee_id%TYPE )
IS

BEGIN
    -- ERROR : ���ν��� ���ο��� ��� ��޵ǹǷ� ���� ������ �� ����
--    p_eid := 100;
    
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;
END;
/

SELECT employee_id, salary
FROM employees
WHERE employee_id IN (100, 130, 149);

DECLARE
    v_first NUMBER(3,0) := 100; -- �ʱ�ȭ�� ����
    v_second CONSTANT NUMBER(3,0) := 149; -- ���
BEGIN
    raise_salary(100);          -- ���ͷ�
    raise_salary(v_first+30);   -- ǥ����
    raise_salary(v_first);      -- �ʱ�ȭ�� ����
    raise_salary(v_second);     -- ���
END;
/

-- OUT ��� : ���ν��� -> ȣ��ȯ������ ���� ��ȯ, ���ν��� ���ο��� �ʱ�ȭ���� ���� ������ ����
CREATE PROCEDURE test_p_out
    (p_num IN NUMBER,
     p_out OUT NUMBER)
IS

BEGIN
    DBMS_OUTPUT.PUT_LINE('IN : ' || p_num);
    DBMS_OUTPUT.PUT_LINE('OUT : ' || p_out);
END; -- ����� ����Ǵ� ���� OUT ����� �Ű������� ������ �ִ� ���� �״�� ��ȯ
/

-- �����ڵ�
DECLARE
    v_result NUMBER(4,0) := 1234;
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) result : ' || v_result);
    test_p_out(1000, v_result);
    DBMS_OUTPUT.PUT_LINE('2) result : ' || v_result);
END;
/

-- ���ϱ� ���ν���
CREATE PROCEDURE pro_plus
    (p_x IN NUMBER,
     p_y IN NUMBER,
     p_sum OUT NUMBER)
IS

BEGIN
    p_sum := p_x + p_y;
END;
/
-- �����ڵ�
DECLARE
    v_total NUMBER(10,0);
BEGIN
    pro_plus(10, 25, v_total);
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

-- IN OUT ��� : IN ���� OUT ��� �ΰ����� �ϳ��� ������ ó��
-- '01012341234' => '010-1234-1234'
CREATE PROCEDURE format_phone
    (p_phone_no IN OUT VARCHAR2)
IS

BEGIN
    DBMS_OUTPUT.PUT_LINE('before : ' || p_phone_no);
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
                || '-' || SUBSTR(p_phone_no, 4, 4)
                || '-' || SUBSTR(p_phone_no, 8);
    DBMS_OUTPUT.PUT_LINE('after : ' || p_phone_no);
END;
/
DECLARE
    v_no VARCHAR2(100) := '01012341234';
BEGIN
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE(v_no);
END;
/
-- ��¥�� ������ �������� ���� : '24/11/27' => '24��11��'


/*
1.
�ֹε�Ϲ�ȣ�� �Է��ϸ� 
������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�.

EXECUTE yedam_ju('9501011667777')
950101-1******
EXECUTE yedam_ju('1511013689977')
151101-3******
*/
DROP PROCEDURE yedam_ju;
CREATE PROCEDURE yedam_ju
    (p_number VARCHAR2) -- �ֹι�ȣ �Է�(���ڿ�)
IS
    v_result VARCHAR2(30);
BEGIN
    -- �Է¹��� ��ȣ ����
    v_result := SUBSTR(p_number, 1, 6)
--                || '-' || SUBSTR(p_number, 7, 1) || '******';
                || '-' || RPAD(SUBSTR(p_number, 7, 1), 7, '*');
    -- ��� ���
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

/*
2.
�����ȣ�� �Է��� ���
�����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
��) EXECUTE TEST_PRO(176)
*/
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro
    (p_eid NUMBER) -- �����ȣ �Է�
IS
    -- ��� ���� ��� ���� ����
    p_del_fail EXCEPTION;
BEGIN
    -- ��� ����
    DELETE FROM employees
    WHERE employee_id = p_eid;
    
    -- ��� ���� ��� üũ
    IF SQL%ROWCOUNT = 0 THEN
        RAISE p_del_fail;
    END IF;
    
EXCEPTION -- ���� ó��
    WHEN p_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�.');
END;
/
EXECUTE TEST_PRO(176);

/*
3.
������ ���� PL/SQL ����� ������ ��� 
�����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
'*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�.

����) EXECUTE yedam_emp(176)
������) TAYLOR -> T*****  <- �̸� ũ�⸸ŭ ��ǥ(*) ���
*/
DROP PROCEDURE yedam_emp;
CREATE PROCEDURE yedam_emp
    (p_eid NUMBER) -- �����ȣ �Է�
IS
    v_ename employees.last_name%TYPE;
BEGIN
    -- �Է¹��� �����ȣ�� �̸� ����
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = p_eid;
    
    -- �̸� ����
    v_ename := RPAD(SUBSTR(v_ename, 1, 1), LENGTH(v_ename), '*');
    
    -- ����� �̸� ���
    DBMS_OUTPUT.PUT_LINE(v_ename);
END;
/

EXECUTE yedam_emp(104);

SELECT employee_id, last_name
FROM employees;
--102 de haan / 104 ernst

/*
4.
�μ���ȣ�� �Է��� ��� 
�ش�μ��� �ٹ��ϴ� ����� �����ȣ, ����̸�(last_name), ������ ����ϴ� get_emp ���ν����� �����Ͻÿ�. 
(cursor ����ؾ� ��)
��, ����� ���� ��� "�ش� �μ����� ����� �����ϴ�."��� ���(exception ���)
����) EXECUTE get_emp(30)
*/
DROP PROCEDURE get_emp;
CREATE PROCEDURE get_emp
    (p_dnum NUMBER) -- �μ���ȣ �Է�
IS
    -- �����ȣ, ����̸�, �Ի��� �˻�
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = p_dnum;
    
    v_emp_rec emp_cursor%ROWTYPE;
    
    -- ��� ���� ��� ����
    p_no_emp EXCEPTION;
BEGIN
    -- Ŀ�� ����
    OPEN emp_cursor;
    
    -- ��� ���� ��� (�����ȣ, ����̸�, ����)
    LOOP
        FETCH emp_cursor INTO v_emp_rec;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(v_emp_rec.employee_id || ', ');
        DBMS_OUTPUT.PUT(v_emp_rec.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE(ROUND((SYSDATE - v_emp_rec.hire_date)/365) || '����');
    END LOOP;
    
    -- ��� ���� ��� ���� �߻�
    IF emp_cursor%ROWCOUNT = 0 THEN
        RAISE p_no_emp;
    END IF;
    
    -- Ŀ�� ����
    CLOSE emp_cursor;
    
EXCEPTION -- ���� ó��
    WHEN p_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�.');
END;
/

EXECUTE get_emp(60);
SELECT * 
FROM employees
WHERE department_id = 60;

/*
5.
�������� ���, �޿� ����ġ�� �Է��ϸ� Employees���̺� ���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���. 
���� �Է��� ����� ���� ��쿡�� ��No search employee!!����� �޽����� ����ϼ���.(����ó��)
����) EXECUTE y_update(200, 10)
*/
DROP PROCEDURE y_update;
CREATE PROCEDURE y_update
    --���, �޿� ����ġ(�ۼ�Ʈ) �Է�
    (p_eid NUMBER,
     p_inc_sal NUMBER)
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

EXECUTE y_update(200, 10);
SELECT employee_id, salary
FROM employees
WHERE employee_id = 200;
































