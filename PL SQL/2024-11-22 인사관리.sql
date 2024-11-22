
-- [PL/SQL 실습]

-- SQL 명령어 아님, 작업이 완료되었습니다만 표시됨 / 세팅 작업
-- DB가 내부에서 실행한 명령을 화면으로 출력하겠다는 오라클 설정, 고정이 아니라서 할때마다 처음에 적어야 함
SET SERVEROUTPUT ON

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL!!');
END;
/

-- /는 하나의 명령어, => / 위치한 부분까지 하나의 구역으로 설정, ;뒤에 붙여 쓰면 안됨(무조건 하나의 줄 배정)

-- [기본 구조] => DECLARE와 EXCEPTION은 생략 가능, DECLARE는 거의 대부분 사용함
DECLARE
-- 선언부 : 변수 등 선언
BEGIN
-- 실행부 : 실제 프로세스 수행
EXCEPTION
-- 예외처리 : 예외 발생시 처리하는 작업
END;
/

DECLARE
    v_str VARCHAR2(100); -- 기본
    v_num CONSTANT NUMBER(2,0) := 10; -- 상수
    v_count NUMBER(2,0) NOT NULL DEFAULT 5; -- 조건의 변수
    v_sum NUMBER(3,0) := v_num + v_count; -- 표현식(계산식)을 기반으로 초기화
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_str : ' || v_str);
    DBMS_OUTPUT.PUT_LINE('v_num : ' || v_num);
--    v_num := 100; -- 상수로 선언한 값을 변경하려고 하면 에러 발생
    DBMS_OUTPUT.PUT_LINE('v_count : ' || v_count);
    DBMS_OUTPUT.PUT_LINE('v_sum : ' || v_sum);
END;
/

-- %TYPE 속성 : 데이터 타입 공유
DECLARE
    v_eid employees.employee_id%TYPE; -- imployee_id가 가지고 있는 크기(NUMBER(6,0))
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

-- VARCHAR2의 크기 -> BYTE / CHAR
-- BYTE는 BYTE단위(영문 외 문자는 1BYTE로 표현 불가능해서 차이가 생김)
-- CHAR는 글자를 기준으로 크기 생성


-- PL/SQL에서 단독 사용 가능한 SQL 함수 => 단일행 함수들(DECODE, 그룹함수 제외)
DECLARE
    v_date DATE;
BEGIN
    v_date := SYSDATE + 7;
    DBMS_OUTPUT.PUT_LINE(v_date);
END;
/

-- PL/SQL의 SELECT
-- 1) INTO절 : 조회한 컬럼의 값을 담는 변수 선언 => 반드시 데이터는 하나의 행만 반환
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

-- 2) 결과 값은 무조건 하나의 행
DECLARE
    v_name employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_name
    FROM employees
    WHERE department_id = &부서번호;
    -- 부서번호 0 : "no data found"
    -- 부서번호 50 : "exact fetch returns more than requested number of rows" (데이터가 너무 많음)
    -- 부서번호 10 : 정상 실행
    
    DBMS_OUTPUT.PUT_LINE(v_name);
END;
/

-- 3) SELECT절의 컬럼 갯수 = INTO절의 변수 갯수
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

-- must be declared 에러 : 선언 안된 변수 사용시 출력


-- [문제]
/*
1.
사원번호를 입력(치환변수사용&)할 경우
사원번호, 사원이름, 부서이름  
을 출력하는 PL/SQL을 작성하시오.
*/
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT e.employee_id, e.last_name, d.department_name
    INTO v_eid, v_ename, v_dname
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    WHERE e.employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE(v_eid || ' / ' || v_ename || ' / ' || v_dname);
END;
/

-- 1번 문제의 select문을 2개로 분리
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_did departments.department_id%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, department_id
    INTO v_eid, v_ename, v_did
    FROM employees e
    WHERE employee_id = &사원번호;
    
    SELECT department_name
    INTO v_dname
    FROM departments
    WHERE department_id = v_did;
    
    DBMS_OUTPUT.PUT_LINE(v_eid || ' / ' || v_ename || ' / ' || v_dname);
END;
/

-- 1번 문제를 서브쿼리
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
    WHERE e.employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE(v_eid || ' / ' || v_ename || ' / ' || v_dname);
END;
/


/*
2.
사원번호를 입력(치환변수사용&)할 경우 
사원이름, 
급여, 
연봉->(급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/
DECLARE
    v_ename employees.last_name%TYPE;
    v_esalary employees.salary%TYPE;
    v_year_salary NUMBER(20);
BEGIN
    SELECT last_name, salary, ((salary * 12) + (NVL(salary, 0) * NVL(commission_pct, 0) * 12))
    INTO v_ename,v_esalary, v_year_salary
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_esalary);
    DBMS_OUTPUT.PUT_LINE(v_year_salary);
END;
/

-- 2번 문제를 연봉을 select문에서 연산하지 않고 분리해서 계산
DECLARE
    v_ename employees.last_name%TYPE;
    v_esalary employees.salary%TYPE;
    v_ecom employees.commission_pct%TYPE;
    v_year_salary NUMBER(20);
BEGIN
    SELECT last_name, salary, commission_pct
    INTO v_ename,v_esalary, v_ecom
    FROM employees
    WHERE employee_id = &사원번호;
    
    v_year_salary := ((v_esalary * 12) + (NVL(v_esalary, 0) * NVL(v_ecom, 0) * 12));
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_esalary);
    DBMS_OUTPUT.PUT_LINE(v_year_salary);
END;
/


-- PL/SQL 안에서 DML
DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE := .1;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &사원번호;
    
    INSERT INTO employees (employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);
    
    UPDATE employees
    SET salary = (NVL(salary, 0) + 10000) * v_comm
    WHERE employee_id = 1000;
    
    COMMIT; -- 블록 =/= 트랜잭션, 반드시 필요하다면 명시적으로 COMMIT/ROLLBACK 작성
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






