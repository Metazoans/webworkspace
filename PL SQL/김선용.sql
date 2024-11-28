-- 김선용 테스트 2~11
-- 메일 제목 = 5강 김선용
-- mjk@yedam.ac / 파일명 : 본인이름

SET SERVEROUTPUT ON

-- 2. 사원번호 입력 / 부서이름, job_id, 급여, 연간 총수입(연봉)
DECLARE
     v_dname departments.department_name%TYPE;
     v_jid employees.job_id%TYPE;
     v_sal employees.salary%TYPE;
     v_com employees.commission_pct%TYPE;
     
     v_year_sal NUMBER; -- 연봉
BEGIN
    -- 입사일 입력 / 부서이름, job_id, 급여, commission_pct 검색
    SELECT d.department_name, e.job_id, NVL(e.salary, 0), NVL(e.commission_pct, 0)
    INTO v_dname, v_jid, v_sal, v_com
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    WHERE e.employee_id = &사원번호;
    
    -- 연간 총수입 계산
    v_year_sal := (v_sal + (v_sal * v_com)) * 12;
    
    -- 출력
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || v_dname);
    DBMS_OUTPUT.PUT_LINE('job_id : ' || v_jid);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('연간 총수입 : ' || v_year_sal);
END;
/



-- 3. 사원번호 입력, 입사년도 2015년 이후(2015제외) 입사면 New employee 아니면 Career employee 출력
DECLARE
    v_hdate employees.hire_date%TYPE; -- 입사일
BEGIN
    -- 입사일 입력 및 검색
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- 2015년 이후(2015제외) 입사자 -> New employee
    IF TO_CHAR(v_hdate, 'yyyy') > '2015' THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE -- 아니면 -> Career employee
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/



-- 4. 구구단 1~9단 출력(홀수단만 출력)
BEGIN
    -- 곱수 반복
    FOR num IN 1 .. 9 LOOP
        -- 단수 반복
        FOR dan IN 1 .. 9 LOOP
            -- 홀수 단만 구분
            IF MOD(dan, 2) <> 0 AND dan * num >= 10 THEN -- 10이상이면 공백 없음
                DBMS_OUTPUT.PUT(dan || ' X ' || num || ' = ' || (dan * num));
            ELSIF MOD(dan, 2) <> 0 AND dan * num < 10 THEN -- 10 미만이면 공백 추가
                DBMS_OUTPUT.PUT(dan || ' X ' || num || ' =  ' || (dan * num));
            END IF;
            
            -- 칸띄우기
            DBMS_OUTPUT.PUT('  ');
        END LOOP;
        
        -- 라인 종료
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/



--5. 부서번호 입력 / 해당 부서의 모든 사원의 사번, 이름, 급여 출력(CURSOR 사용)
DECLARE
    -- 커서 : 부서번호 입력 / 사번, 이름, 급여 검색
    CURSOR emp_cursor IS
        SELECT employee_id eid, last_name ename, salary sal
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('사번 : ' || emp_rec.eid);
        DBMS_OUTPUT.PUT(', 이름 : ' || emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(', 급여 : ' || emp_rec.sal);
    END LOOP;
END;
/



-- 6. 사번, 급여 증가치(비율)  입력시 사원의 급여 갱신 procedure / 사원 없으면 No search employee!! 출력(에러처리)
CREATE PROCEDURE sal_inc
    --사번, 급여 증가치(비율) 입력
    (p_eid IN employees.employee_id%TYPE,
     p_inc_sal IN employees.salary%TYPE)
IS
    -- 사원 없는 경우 예외 정의
    p_no_emp EXCEPTION;
BEGIN
    -- 사원의 급여 갱신
    UPDATE employees
    SET salary = salary + (salary * (p_inc_sal/100))
    WHERE employee_id = p_eid;
    
    -- 사원 없는 경우 체크
    IF SQL%ROWCOUNT = 0 THEN
        RAISE p_no_emp;
    END IF;
    
EXCEPTION -- 예외 처리
    WHEN p_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/
-- 6번 실행 : 사번, 급여 증가치(비율)
EXECUTE sal_inc(100, 100);
select employee_id, salary
from employees
where employee_id = 100;



-- 7. 주민번호 입력 -> 만 나이와 성별 모두 출력
CREATE PROCEDURE jumin_num
    (p_num VARCHAR2) -- 주민번호 입력
IS
    v_date VARCHAR2(100);
    v_birth DATE;
    v_age NUMBER;
    v_check NUMBER := MOD(TO_NUMBER(SUBSTR(p_num, 7, 1)), 2);
BEGIN
    -- 주민번호 뒷자리 확인 후 생년월일 문자열 생성
    IF SUBSTR(p_num, 7, 1) IN (0,9) THEN
        v_date := '18' || SUBSTR(p_num, 1, 6);
    ELSIF SUBSTR(p_num, 7, 1) IN (1,2) THEN
        v_date := '19' || SUBSTR(p_num, 1, 6);
    ELSIF SUBSTR(p_num, 7, 1) IN (3,4) THEN
        v_date := '20' || SUBSTR(p_num, 1, 6);
    END IF;
    
    -- 생년월일 DATE로 변환
    v_birth := TO_DATE(v_date, 'yyyyMMdd');
    -- 나이 계산
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_birth)/12 , 0);
    
    --만나이 / 성별 출력
    DBMS_OUTPUT.PUT_LINE('만 나이 ' || v_age);
    IF v_check = 0 THEN
        DBMS_OUTPUT.PUT_LINE('성별 : 여');
    ELSE
        DBMS_OUTPUT.PUT_LINE('성별 : 남');
    END IF;
END;
/
-- 7번 테스트
EXECUTE jumin_num('9511281222222');
EXECUTE jumin_num('0211023234567');



-- 8. 사원번호 입력, 근무기간의 근무 년수만 출력하는 FUNCTION / 근무 개월수는 제외(5년 10개월인 경우 5년만 표기)
CREATE FUNCTION work_year_func
    (p_eid employees.employee_id%TYPE) -- 사원번호 입력
    RETURN NUMBER -- 근무 년수 반환
IS
    v_hdate employees.hire_date%TYPE;
    v_work_year NUMBER;
BEGIN
    -- 입사일 검색
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = p_eid;
    
    -- 근무 년수 계산 -> 개월수 버림
    v_work_year := TRUNC(MONTHS_BETWEEN(SYSDATE, v_hdate)/12 , 0);
    
    RETURN v_work_year;
END;
/
-- 8번 확인
select employee_id, hire_date
from employees;
select work_year_func(101)
from dual;



-- 9. 부서이름 입력 -> 부서의 책임자(manager) 이름 출력 function / 서브쿼리 이용
CREATE FUNCTION mgr_prt
    (p_dname departments.department_name%TYPE) -- 부서이름 입력
    RETURN VARCHAR2 -- manager 이름 반환
IS
    v_mgr_name employees.last_name%TYPE;
BEGIN
    -- manager 이름 검색
    SELECT e.last_name
    INTO v_mgr_name
    FROM employees e
    WHERE e.employee_id = (SELECT d.manager_id
                         FROM departments d
                         WHERE UPPER(d.department_name) = UPPER(p_dname));

    RETURN v_mgr_name;
END;
/
-- 9번 테스트
select mgr_prt('it')
from dual;
select department_name, manager_id
from departments;
select employee_id, last_name
from employees
where employee_id = 124;



-- 10. hr사용자에 존재하는 procedure, function, package, package body 이름과 소스코드를 한꺼번에 확인 구문
SELECT name, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY');



-- 11. 별 역순 출력 -> 별 수 = 총 9개, 전체 길이10
DECLARE
    v_blank NUMBER := 9;
    v_star NUMBER := 1;
BEGIN
    -- 별 9개 그리면 종료
    LOOP
        -- 공백 그리기
        FOR blank IN 1 .. v_blank LOOP
            DBMS_OUTPUT.PUT('-');
        END LOOP;
        
        -- 별 그리기
        FOR star IN 1 .. v_star LOOP
            DBMS_OUTPUT.PUT('*');
        END LOOP;
        
        -- 라인 종료
        DBMS_OUTPUT.PUT_LINE('');
        
        --공백 감소, 별 증가
        v_blank := v_blank - 1;
        v_star := v_star + 1;
        EXIT WHEN v_star = 10;
    END LOOP;
END;
/


