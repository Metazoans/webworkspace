-- 1) ���̺� �غ�
DROP TABLE employee;
CREATE TABLE employee
AS
    SELECT *
    FROM employees;
    
CREATE TABLE t_job_history
AS
    SELECT *
    FROM job_history;

-- 2) ����� ������ �μ��� ����� ��� job_history ���̺� �������� �Է�
CREATE PROCEDURE add_job_history 
(p_eid IN employees.employee_id%TYPE,
 p_pre_hdate IN employees.hire_date%TYPE,
 p_new_hdate IN employees.hire_date%TYPE,
 p_job_id IN jobs.job_id%TYPE,
 p_dept_id IN departments.department_id%TYPE)
IS

BEGIN
    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (p_eid, p_pre_hdate, p_new_hdate, p_job_id, p_dept_id);
END;
/

-- 3) employee ���̺��� ����� ��� �ڵ����� ����� �۾��� Ʈ���ŷ� ����
drop trigger update_job_history;
CREATE OR REPLACE TRIGGER update_job_history
  AFTER UPDATE OF job_id, department_id ON employees
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/


SELECT *
FROM job_history
ORDER BY end_date;


UPDATE employees
SET job_id = 'IT_PROG'
WHERE employee_id = 100;