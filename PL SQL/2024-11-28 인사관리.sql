-- <2024-11-28>

SET SERVEROUTPUT ON

-- FUNCTION : 주로 계산하는 용도로 많이 사용하는 객체
-- => DML 없이 VARCHAR2, NUMBER, DATE 등 SQL에서 사용하는 데이터 타입으로 반환할 경우 SQL문과 함께 사용 가능
-- 1) 문법
CREATE FUNCTION 함수명
    ( 매개변수명 데이터타입, ...) -- IN 모드로만 사용가능하므로 모드는 생략
    RETURN 리턴타입
IS
    -- 선언부 : 변수, 커서, 예외사항 등을 선언
BEGIN
    -- 실행하고자 하는 코드
    RETURN 리턴값;
EXCEPTION
    WHEN 예외이름 THEN
        -- 예외처리 코드
        RETURN 리턴값;
END;
/

-- 2) 적용
CREATE FUNCTION test_func
    (p_msg VARCHAR2)
    RETURN VARCHAR2
IS
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    RETURN (v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '데이터가 존재하지 않습니다.';
END;
/

-- 3) 실행
-- 3-1) PL/SQL블록
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    -- 함수 호출시 반드시 변수가 필요
    v_result := test_func('PL/SQL');
    
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
-- 3-2) SQL문
SELECT test_func('SQL')
FROM dual; -- 테스트용 테이블

-- 더하기
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

-- 사원번호를 입력받아 해당 사원의 직속상사 이름을 출력
-- 원래 SELECT문
SELECT e.employee_id, m.last_name
FROM employees e JOIN employees m ON (e.manager_id = m.employee_id)
ORDER BY employee_id;

-- 함수 사용
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

-- 만들어둔 프로시저, 함수 등을 확인하는 방법
SELECT name, line, text
FROM user_source;

SELECT name, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION');


/*
1.
사원번호를 입력하면 
last_name + first_name 이 출력되는 
y_yedam 함수를 생성하시오.

실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
출력 예)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
DROP FUNCTION y_yedam;
CREATE FUNCTION y_yedam
    (p_eid employees.employee_id%TYPE) -- 사원번호 입력
    RETURN VARCHAR2 -- 이름 반환
IS
    v_full_name VARCHAR2(100);
BEGIN
    -- last_name, first_name 검색
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
사원번호를 입력할 경우 다음 조건을 만족하는 결과가 출력되는 ydinc 함수를 생성하시오.
- 급여가 5000 이하이면 20% 인상된 급여 출력
- 급여가 10000 이하이면 15% 인상된 급여 출력
- 급여가 20000 이하이면 10% 인상된 급여 출력
- 급여가 20000 초과이면 급여 그대로 출력
실행) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees; 
*/
DROP FUNCTION ydinc;
CREATE FUNCTION ydinc
    (p_eid employees.employee_id%TYPE) -- 사원번호 입력
    RETURN NUMBER -- 인상된 급여 반환
IS
    v_sal employees.salary%TYPE;
    v_inc_sal NUMBER; -- 인상된 급여 저장
BEGIN
    -- 급여 검색
    SELECT salary
    INTO v_sal
    FROM employees
    WHERE employee_id = p_eid;
    
    -- 급여 인상
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
사원번호를 입력하면 해당 사원의 연봉이 출력되는 yd_func 함수를 생성하시오.
->연봉계산 : (급여+(급여*인센티브퍼센트))*12
실행) SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;  
*/
DROP FUNCTION yd_func;
CREATE FUNCTION yd_func
    (p_eid employees.employee_id%TYPE) -- 사원번호 입력
    RETURN NUMBER -- 연봉 출력
IS
    v_sal employees.salary%TYPE;
    v_com employees.commission_pct%TYPE;
    v_year_sal NUMBER; -- 연봉
BEGIN
    -- 급여 검색
    SELECT salary, commission_pct
    INTO v_sal, v_com
    FROM employees
    WHERE employee_id = p_eid;
    
    -- 연봉 계산
    v_year_sal := (v_sal + (v_sal * NVL(v_com, 0))) * 12;
    
    RETURN v_year_sal;
END;
/
SELECT last_name, salary, yd_func(employee_id)
FROM   employees;



































