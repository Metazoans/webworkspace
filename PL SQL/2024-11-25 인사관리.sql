-- <2024-11-25>

-- [SQL 커서]

-- 암시적 커서 : SQL문의 실행 결과를 담은 메모리 영역
-- => 주 목적 : DML의 실행결과 확인, SQL%ROWCOUNT  ==> 암시적 커서는 이름이 없어서 SQL을 기준으로 가져옴
-- => 주의사항 : 직전에 실행된 SQL문의 결과만 확인 가능
SET SERVEROUTPUT ON

BEGIN
    DELETE FROM employees
    WHERE employee_id = 0;

    DBMS_OUTPUT.PUT_LINE(SQL%rowcount || '건이 삭제되었습니다.');
END;
/


-- employees 데이터 확인용
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

-- [조건문]
-- 1) 기본 IF 문 : 특정 조건이 TRUE 인 경우만
BEGIN
    DELETE FROM employees
    WHERE employee_id = &사원번호;

    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다.');
    END IF;
END;
/

-- 2) IF ~ ELSE 문 : 특정 조건을 기준으로 TRUE/FALSE 모두 확인
BEGIN
    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT >= 1 THEN
        -- 조건식이 TRUE일 경우
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다.');
    ELSE
        -- 위에 선언한 모든 조건식이 FALSE인 경우
        DBMS_OUTPUT.PUT_LINE('삭제되지 않았습니다.');
        DBMS_OUTPUT.PUT_LINE('사원번호를 확인해주세요.');
    END IF;
END;
/

-- 3) IF ~ ELSEIF ~ ELSE 문 : 여러 조건을 기반으로 각 경우의 수를 처리
DECLARE
    v_score NUMBER(2,0) := &점수;
    v_grade CHAR(1);
BEGIN
    IF v_score >= 90 THEN -- v_score이 가지는 최대값과 최소값 출력 : 최소값 < v_score < 최대값
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


-- 사원번호를 입력받아 해당 사원의 업무(JOB_ID)가 영업인 경우('SA'가 포함된 경우)를 확인해주세요.
-- 출력문구 : 해당 사원의 담당업무는 영업분야 입니다.

DECLARE
    v_jid employees.job_id%TYPE; -- job_id
BEGIN
    -- 1. 사원번호 입력
    SELECT job_id
    INTO v_jid
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- 2. 해당 사원의 업무가 영업인 경우 확인
    IF UPPER(v_jid) LIKE '%SA%' THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원의 담당업무는 영업분야 입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('해당 사원의 담당업무는 ' || v_jid || ' 아닙니다.');
    END IF;
END;
/


/*
3.
사원번호를 입력(치환변수사용&)할 경우
입사일이 2025년 이후(2025년 포함)이면 'New employee' 출력
      2025년 이전이면 'Career employee' 출력
단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용
*/
select * 
from employees;

DECLARE
    v_hdate employees.hire_date%TYPE;
    v_msg VARCHAR(100);
BEGIN
    -- 사원번호 입력
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- 입사일 체크
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

사원번호를 입력(치환변수사용&)할 경우
사원들 중 2025년 이후(2025년 포함)에 입사한 사원의 사원번호, 
사원이름, 입사일을 test01 테이블에 입력하고, 2025년 이전에 
입사한 사원의 사원번호,사원이름,입사일을 test02 테이블에 입력하시오.
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
    --사원번호 입력, 입사일 저장
    SELECT employee_id, last_name, hire_date
    INTO v_eid, v_ename, v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    --25년 이후 입사 -> (empid, ename, hiredate) test01입력
    IF TO_CHAR(v_hdate, 'yyyy') >= '2025' THEN
        INSERT INTO test01 (empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    --25년 이전 입사 -> (empid, ename, hiredate) test02입력
    ELSE
        INSERT INTO test02 (empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    END IF;
END;
/

/*
5.
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오.
*/
select employee_id, salary
from employees;

DECLARE
    v_ename employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_inc_salary NUMBER(15);
BEGIN
    --사원번호 입력 / 이름 및 급여 저장
    SELECT last_name, salary
    INTO v_ename, v_salary
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_salary <= 5000 THEN --급여가  5000이하이면 20% 인상된 급여
        v_inc_salary := v_salary * 1.2;
    ELSIF v_salary <= 10000 THEN --급여가 10000이하이면 15% 인상된 급여
        v_inc_salary := v_salary * 1.15;
    ELSIF v_salary <= 15000 THEN --급여가 15000이하이면 10% 인상된 급여
        v_inc_salary := v_salary * 1.1;
    ELSE --급여가 15001이상이면 급여 인상없음
        v_inc_salary := v_salary;
    END IF;
    
    -- 이름, 급여, 인상급여 출력
    DBMS_OUTPUT.PUT_LINE(v_ename || ' | ' || v_salary || ' | ' || v_inc_salary);
    
    
    --[다른 방식]
--    IF v_salary <= 5000 THEN --급여가  5000이하이면 20% 인상된 급여
--        v_raise := 20;
--    ELSIF v_salary <= 10000 THEN --급여가 10000이하이면 15% 인상된 급여
--        v_raise := 15;
--    ELSIF v_salary <= 15000 THEN --급여가 15000이하이면 10% 인상된 급여
--        v_raise := 10;
--    ELSE --급여가 15001이상이면 급여 인상없음
--        v_raise := 0;
--    END IF;
--    v_new_sal = v_sal + v_sal * (v_raise /100);
--    DBMS_OUTPUT.PUT_LINE(v_ename || ' | ' || v_salary || ' | ' || v_new_sal);
END;
/


-- [LOOP문]

-- 기본 LOOP문 : 조건없이 무한 LOOP문을 의미 -> 반드시 EXIT문을 포함하라고 권장
-- 1) 문법
/*
BEGIN
    LOOP
        -- 반복하고자 하는 코드
        EXIT WHEN -- 종료 조건을 의미
    END LOOP;
END;
/
*/

-- 2) 적용
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
        -- 반복하고자 하는 코드
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        
        -- LOOP문을 제어하는 코드
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
    END LOOP;
END;
/

-- 1부터 10까지 정수의 총합 구하기
DECLARE
    v_count NUMBER(2,0) := 1;
    v_sum NUMBER(3,0) := 0;
BEGIN
    LOOP
        -- 반복 코드 : 1~10까지 합;
        v_sum := v_sum + v_count;
        
        -- 제어 코드 : 10번 반복시 종료
        v_count := v_count + 1;
        EXIT WHEN v_count > 10;
    END LOOP;
    
    -- 합 출력
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

/*
6. 다음과 같이 출력되도록 하시오.
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
        -- 별표 출력
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
        
        -- 제어 코드
        v_cnt := v_cnt + 1;
        EXIT WHEN v_cnt >= 5;
--        EXIT WHEN LENGTH(v_star) >= 5;
    END LOOP;
END;
/

/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...
*/
DECLARE
    v_num NUMBER(3,0) := 1;
    v_dan NUMBER(2,0);
BEGIN
    -- 숫자 입력
    v_dan := &입력;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('===' || v_dan || '단===');
    
    LOOP
        -- 구구단 출력
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
        
        -- 제어 코드
        v_num := v_num + 1;
        EXIT WHEN v_num > 9;
    END LOOP;
END;
/

/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/
DECLARE
    v_num NUMBER(3,0) := 1;
    v_dan NUMBER(2,0) := 2;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('===' || v_dan || '단===');
        LOOP
            -- 구구단 출력
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
            
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
        END LOOP;
        
        -- 단수 증가 및 카운트 초기화
        v_num := 1;
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

-- WHILE LOOP문 : 특정 조건을 만족하는 동안 반복하는 LOOP문 => 경우에 따라 실행 안되는 경우 있음
-- 1) 문법
DECLARE

BEGIN
    WHILE 반복조건 LOOP
        -- 반복하고자 하는 코드
    END LOOP;
END;
/

-- 2) 적용
DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    WHILE v_count < 5 LOOP -- 명확한 반복 조건 표기
        --반복하고자 하는 코드
        DBMS_OUTPUT.PUT_LINE('Hello !!');
        
        -- LOOP문을 제어하는 코드
        v_count := v_count + 1;
    END LOOP;
END;
/

-- 1에서 10까지 정수의 총합 구하기
DECLARE
    v_num NUMBER(2,0) := 1;
    v_sum NUMBER(3,0) := 0;
BEGIN
    -- 10이하일때 반복
    WHILE v_num <= 10
    LOOP
        -- 1~10 더하기
        v_sum := v_sum + v_num;
        
        -- 제어 코드
        v_num := v_num + 1;
    END LOOP;
    
    -- 합계 출력
    DBMS_OUTPUT.PUT_LINE('총합 = ' || v_sum);
END;
/

-- 6,7,8번 문제 WHILE문으로 풀기
/*
6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    
*/
DECLARE
    v_star VARCHAR2(10) := '*'; -- v_star := '' => NULL로 인식(LENGTH 함수 적용 안됨)
BEGIN
    -- 길이 5이하일때 반복
    WHILE LENGTH(v_star) <= 5 -- NVL(LENGTH(v_star),0) -> NULL 체크 하고 싶으면 사용
    LOOP
        -- 별표 출력
        DBMS_OUTPUT.PUT_LINE(v_star);
        
        -- 별표 증가
        v_star := v_star || '*';
    END LOOP;
END;
/

/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...
*/
DECLARE
    v_num NUMBER(3,0) := 1;
    v_dan NUMBER(2,0) := &단수; -- 변수 선언과 동시에 입력
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('===' || v_dan || '단===');
    
    WHILE v_num <= 9 
    LOOP
        -- 구구단 출력
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
        
        -- 제어 코드
        v_num := v_num + 1;
    END LOOP;
END;
/

/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/
DECLARE
    v_num NUMBER(3,0) := 1;
    v_dan NUMBER(2,0) := 2;
BEGIN
    WHILE v_dan <= 9 
    LOOP
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('===' || v_dan || '단===');
        
        -- 구구단 출력
        WHILE v_num <= 9 
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
            
            v_num := v_num + 1;
        END LOOP;
        
        -- 제어 코드 : 단수 증가 / 곱수 초기화
        v_num := 1;
        v_dan := v_dan + 1;
    END LOOP;
END;
/

-- FOR LOOP문 : 지정된 범위 안 모든 정수의 갯수만큼 반복
-- 1) 문법
BEGIN
    FOR 임시 변수 IN 최소값 .. 최대값 LOOP
        -- 반복하고자 하는 코드
    END LOOP;
    -- 임시변수 : 정수타입, DECLARE절에 따로 선언하지 않음, 반드시 최소값과 최대값 사이의 정수값만 가짐 => Readonly
    -- 최소값, 최대값 : 정수, 반드시 최소값 <= 최대값
END;
/

-- 2) 적용
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
    v_max NUMBER(2,0) := &최대값;
BEGIN
    FOR idx IN 5 .. v_max LOOP -- v_max가 5보다 작은 경우 LOOP문은 실행되지 않음
--        idx := 10; : FOR LOOP문의 임시변수는 변경 불가
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

BEGIN
    FOR idx IN REVERSE 1 .. 5 LOOP -- REVERSE : 범위 내에 존재하는 정수 값을 내림차순으로 가지고 옴
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

-- 1에서 10까지의 정수의 총합 구하기
DECLARE
    v_sum NUMBER(3,0) := 0;
BEGIN
    -- 1~10 더하기
    FOR num IN 1 .. 10 LOOP
        v_sum := v_sum + num;
    END LOOP;
    
    -- 총합 출력
    DBMS_OUTPUT.PUT_LINE('총합 = ' || v_sum);
END;
/

-- 6,7,8번 문제 FOR LOOP문으로 풀기
/*
6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    
*/
DECLARE
    v_star VARCHAR2(10):= '';
BEGIN
    FOR idx in 1 .. 5 LOOP -- 5회 반복
        -- 별 증가
        v_star := v_star || '*';
        
        -- 별 출력
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;
END;
/

/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...
*/
DECLARE
    v_dan NUMBER(2,0) := &단수; -- 단수 입력
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('===' || v_dan || '단===');
    
    FOR num IN 1 .. 9 LOOP -- 곱하는 수 : 1~9
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || num || ' = ' || (v_dan * num));
    END LOOP;
END;
/

/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/
BEGIN
    FOR dan IN 2 .. 9 LOOP -- 단수 증가 LOOP문
        -- 몇단인지 출력
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('===' || dan || '단===');
        
        FOR num IN 1 .. 9 LOOP -- 곱수 증가 LOOP문
            DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num || ' = ' || (dan * num));
        END LOOP;
    END LOOP;
END;
/

-- 6번을 DECLARE 없이 2중 FOR LOOP문으로 작성
-- DBMS_OUTPUT.PUT();
BEGIN
    FOR i IN 1 .. 5 LOOP
        FOR j IN 1 .. i LOOP -- 별 출력
            DBMS_OUTPUT.PUT('*'); -- PUT 단독으로는 출력 안됨(PUT_LINE으로 줄의 끝을 입력해야 출력)
        END LOOP;
        
        -- 다음 줄로 넘어감
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 8번 구구단을 가로로 출력
BEGIN
    FOR num IN 0 .. 9 LOOP -- 단수 증가 LOOP문
        -- 몇단인지 출력
        IF num = 0 THEN
            FOR dan IN 2 .. 9 LOOP
                DBMS_OUTPUT.PUT('  == ' || dan || '단 ==   ');
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






