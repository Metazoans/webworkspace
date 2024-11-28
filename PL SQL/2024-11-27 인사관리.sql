-- <2024-11-27>

SET SERVEROUTPUT ON

-- [커서 FOR LOOP]

-- 커서 FOR LOOP : 명시적 커서를 사용하는 단축 방법
-- 1) 문법
DECLARE
    CURSOR 커서명 IS
        SELECT문;
BEGIN
    FOR 임시변수(레코드타입) IN 커서명 LOOP -- 암시적으로 OPEN과 FETCH
        -- 커서에 데이터가 존재하는 경우 수행하는 코드
    END LOOP; -- 암시적으로 CLOSE
END;
/

-- 2) 적용
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id eid, last_name ename, salary sal
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_rec IN emp_dept_cursor LOOP
        DBMS_OUTPUT.PUT(emp_dept_cursor%ROWCOUNT || ' : ' );
        DBMS_OUTPUT.PUT(emp_rec.eid);
        DBMS_OUTPUT.PUT(', ' || emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.sal);
    END LOOP;
END;
/

-- 부서번호를 입력받아 해당 부서에 소속된 사원정보(사원번호, 이름, 급여)를 출력하세요.
-- 부서번호 0  : 커서의 데이터가 없음
-- 부서번호 50 : 커서의 데이터가 존재함
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id eid, last_name ename, salary sal
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_rec IN emp_dept_cursor LOOP
        DBMS_OUTPUT.PUT(emp_dept_cursor%ROWCOUNT || ' : ' );
        DBMS_OUTPUT.PUT(emp_rec.eid);
        DBMS_OUTPUT.PUT(', ' || emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.sal);
    END LOOP; -- 암시적으로 CLOSE
    
    -- 이미 닫힌 커서를 사용하려 해서 invalid cursor 에러
    DBMS_OUTPUT.PUT_LINE('총 데이터 갯수 : ' || emp_dept_cursor%ROWCOUNT);
END;
/

-- 커서 FOR LOOP 문의 경우 명시적 커서의 데이터를 보장할 수 있을때만 사용

/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2025년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2025년 이후 입사한 사원은 test02 테이블에 입력
*/
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        -- 2015년(포함) 이전 입사자 -> test01
        IF TO_CHAR(emp_rec.hire_date, 'yyyy') <= '2015' THEN
            INSERT INTO test01 (empid, ename, hiredate)
            VALUES (emp_rec.employee_id, emp_rec.last_name, emp_rec.hire_date);
        -- 2015년(제외) 이후 입사자 -> test02
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
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
*/
DECLARE
    -- 부서번호 입력 / 사원 정보 검색
    CURSOR emp_dept_cursor IS
        SELECT e.last_name ename, e.hire_date hdate, d.department_name dname
        FROM employees e JOIN departments d
                         ON (e.department_id = d.department_id)
        WHERE e.department_id = &부서번호;
BEGIN
    FOR emp_dept_rec IN emp_dept_cursor LOOP
        -- 사원이름, 입사일자, 부서명 출력
        DBMS_OUTPUT.PUT_LINE(emp_dept_rec.ename || ', ' || emp_dept_rec.hdate || ', ' || emp_dept_rec.dname);
    END LOOP;
END;
/

-- 커서 FOR LOOP문은 서브쿼리를 이용해서 동작 가능(단, 속성은 사용불가)
BEGIN
    -- FOR LOOP문 조건
    FOR emp_dept_rec IN (SELECT last_name, hire_date, department_name
                         FROM employees e JOIN departments d
                                          ON (e.department_id = d.department_id)
                         WHERE e.department_id = &부서번호)
    LOOP -- FOR LOOP문 반복 시작
        -- 사원이름, 입사일자, 부서명 출력
        DBMS_OUTPUT.PUT_LINE(emp_dept_rec.last_name || ', ' || emp_dept_rec.hire_date || ', ' || emp_dept_rec.department_name);
    END LOOP;
END;
/

/*
3.
부서번호를 입력(&사용)할 경우 
사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/
DECLARE
    -- 부서번호 입력 / 사원 정보 검색
    CURSOR emp_cursor IS
        SELECT last_name ename, salary sal, (salary * 12 + (salary * NVL(commission_pct,0) * 12)) yearsal
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        -- 사원이름, 급여, 연봉 출력
        DBMS_OUTPUT.PUT_LINE(emp_rec.ename || ', ' || emp_rec.sal || ', ' || emp_rec.yearsal);
    END LOOP;
END;
/


-- [예외처리]

-- 예외처리 : 예외가 발생했을 때 정상적으로 작업이 종료될 수 있도록 처리
-- 1) 문법
DECLARE

BEGIN

EXCEPTION
    WHEN 예외이름 THEN -- 필요한 만큼 추가 가능
        --예외 발생시 처리하는 코드
    WHEN OTHERS THEN -- 위에 정의된 예외말고 발생하는 경우 일괄 처리
        --예외 발생시 처리하는 코드
END;
/

-- 2) 적용
-- 2-1) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름도 존재하는 예외사항
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    -- 부서번호 0  : ORA-01403, NO_DATA_FOUND
    -- 부서번호 10 : 정상실행
    -- 부서번호 50 : ORA-01422, TOO_MANY_ROWS
    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 예외사항이 발생했습니다.');
        
        -- 에러 메세지를 따로 분리해서 출력
        -- OTHERS에서 처리된 에러가 무엇인지 확인하기 위한 코드
        DBMS_OUTPUT.PUT_LINE('ORA' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 12));
        
        DBMS_OUTPUT.PUT_LINE('블록이 종료되었습니다.'); -- 예외처리는 끝이 확실하지 않아서 들여쓰기 영향 안받음
END;
/
-- 2-2) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름은 존재하지 않는 예외사항
DECLARE
    -- 코드 실행 전 처리하는 작업
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
    -- 부서번호 10 : ORA-02292: integrity constraint (HR.EMP_DEPT_FK) violated - child record found

EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서는 다른 테이블에서 사용 중입니다.');
END;
/
-- 2-3) 사용자 정의 예외 => 오라클 입장에선 정상코드로 인지
DECLARE
    e_dept_del_fail EXCEPTION;
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
    -- 부서번호 0 : 정상적으로 수행되지만 기능상 실패로 인지해야 하는 경우
    
    IF SQL%ROWCOUNT = 0 THEN -- 실행된 결과가 없을 경우
        RAISE e_dept_del_fail; -- 에러 강제 발생 코드
    END IF;
EXCEPTION
    WHEN e_dept_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('부서번호를 확인해주세요.');
END;
/
-- 2-3 => 사용자 정의 예외 딜레마 : EXCEPTION을 반드시 써야 하는 것이 아님
-- ==> 예외처리는 강제 종료, 중요한 작업에서 예외처리로 흐름을 끊어야 하는 경우에 사용자 정의 예외 처리 사용
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
    -- 부서번호 0 : 정상적으로 수행되지만 기능상 실패로 인지해야 하는 경우
    
    IF SQL%ROWCOUNT = 0 THEN -- 실행된 결과가 없을 경우 => EXCEPTION을 사용하지 않고 바로 에러메세지 출력
        DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('부서번호를 확인해주세요.');
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

emp_test 테이블에서 사원번호를 사용(&치환변수 사용)하여 사원을 삭제하는 PL/SQL을 작성하시오.
(단, 사용자 정의 예외사항 사용)
(단, 사원이 없으면 "해당사원이 없습니다.'라는 오류메시지 발생)
*/
DECLARE
    -- 사용자 정의 예외사항 선언
    emp_del_fail EXCEPTION;
BEGIN
    -- emp_test 테이블에서 삭제 진행
    DELETE FROM emp_test
    WHERE employee_id = &사원번호;
    
    -- 실행된 결과가 없을 경우
    IF SQL%ROWCOUNT = 0 THEN
        RAISE emp_del_fail; -- 에러 강제 발생 코드
    END IF;
EXCEPTION
    -- 삭제할 사원이 없는 경우 에러메세지 출력
    WHEN emp_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
END;
/

SELECT *
FROM emp_test
ORDER BY employee_id;


-- [프로시저]

-- PROCEDURE
-- 1)문법
CREATE PROCEDURE 프로시저명
    ( 매개변수명 [모드] 데이터타입, ... )
IS
    -- 선언부 : 로컬변수, 커서, 예외사항 등을 선언  => DECLARE 공간은 있지만 DECLARE절을 선언하진 않음(충돌)
BEGIN
    -- PROCEDURE가 수행할 코드
EXCEPTION
    -- 에러처리
END;
/

-- 2) 적용
CREATE PROCEDURE test_pro
    (p_msg VARCHAR2) -- 암시적으로 IN으로 선언, 매개변수는 크기지정 안됨
IS
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('데이터가 존재하지 않습니다.');
END;
/

-- 프로시저 삭제
DROP PROCEDURE test_pro;

-- 3) 실행
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    -- 오라클이 현재 실행하는 객체가 PROCEDURE인지 FUNCTION인지 구분하는 방법
    -- => 호출형태 (왼쪽에 변수가 존재하는 가 == 데이터를 받을 수 있는 가)
--    v_result := test_pro('PL/SQL'); => 함수로 인식
    test_pro('PL/SQL');
END;
/

-- 프로시저 실행 명령어(하나만 간단하게 사용할 때) => 테스트용
EXECUTE test_pro('WORLD');


-- IN 모드 : 호출환경 -> 프로시저로 값을 전달, 프로시저 내부에서 상수 취급
DROP PROCEDURE raise_salary;
CREATE PROCEDURE raise_salary
    ( p_eid IN employees.employee_id%TYPE )
IS

BEGIN
    -- ERROR : 프로시저 내부에서 상수 취급되므로 값을 변경할 수 없음
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
    v_first NUMBER(3,0) := 100; -- 초기화된 변수
    v_second CONSTANT NUMBER(3,0) := 149; -- 상수
BEGIN
    raise_salary(100);          -- 리터럴
    raise_salary(v_first+30);   -- 표현식
    raise_salary(v_first);      -- 초기화된 변수
    raise_salary(v_second);     -- 상수
END;
/

-- OUT 모드 : 프로시저 -> 호출환경으로 값을 반환, 프로시저 내부에서 초기화되지 않은 변수로 인지
CREATE PROCEDURE test_p_out
    (p_num IN NUMBER,
     p_out OUT NUMBER)
IS

BEGIN
    DBMS_OUTPUT.PUT_LINE('IN : ' || p_num);
    DBMS_OUTPUT.PUT_LINE('OUT : ' || p_out);
END; -- 블록이 종료되는 순간 OUT 모드의 매개변수가 가지고 있는 값이 그대로 반환
/

-- 실행코드
DECLARE
    v_result NUMBER(4,0) := 1234;
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) result : ' || v_result);
    test_p_out(1000, v_result);
    DBMS_OUTPUT.PUT_LINE('2) result : ' || v_result);
END;
/

-- 더하기 프로시저
CREATE PROCEDURE pro_plus
    (p_x IN NUMBER,
     p_y IN NUMBER,
     p_sum OUT NUMBER)
IS

BEGIN
    p_sum := p_x + p_y;
END;
/
-- 실행코드
DECLARE
    v_total NUMBER(10,0);
BEGIN
    pro_plus(10, 25, v_total);
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

-- IN OUT 모드 : IN 모드와 OUT 모드 두가지를 하나의 변수로 처리
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
-- 날짜를 지정한 포맷으로 변경 : '24/11/27' => '24년11월'


/*
1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju('9501011667777')
950101-1******
EXECUTE yedam_ju('1511013689977')
151101-3******
*/
DROP PROCEDURE yedam_ju;
CREATE PROCEDURE yedam_ju
    (p_number VARCHAR2) -- 주민번호 입력(문자열)
IS
    v_result VARCHAR2(30);
BEGIN
    -- 입력받은 번호 변경
    v_result := SUBSTR(p_number, 1, 6)
--                || '-' || SUBSTR(p_number, 7, 1) || '******';
                || '-' || RPAD(SUBSTR(p_number, 7, 1), 7, '*');
    -- 결과 출력
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro
    (p_eid NUMBER) -- 사원번호 입력
IS
    -- 사원 없는 경우 에러 정의
    p_del_fail EXCEPTION;
BEGIN
    -- 사원 삭제
    DELETE FROM employees
    WHERE employee_id = p_eid;
    
    -- 사원 없는 경우 체크
    IF SQL%ROWCOUNT = 0 THEN
        RAISE p_del_fail;
    END IF;
    
EXCEPTION -- 예외 처리
    WHEN p_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
END;
/
EXECUTE TEST_PRO(176);

/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/
DROP PROCEDURE yedam_emp;
CREATE PROCEDURE yedam_emp
    (p_eid NUMBER) -- 사원번호 입력
IS
    v_ename employees.last_name%TYPE;
BEGIN
    -- 입력받은 사원번호로 이름 저장
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = p_eid;
    
    -- 이름 변경
    v_ename := RPAD(SUBSTR(v_ename, 1, 1), LENGTH(v_ename), '*');
    
    -- 변경된 이름 출력
    DBMS_OUTPUT.PUT_LINE(v_ename);
END;
/

EXECUTE yedam_emp(104);

SELECT employee_id, last_name
FROM employees;
--102 de haan / 104 ernst

/*
4.
부서번호를 입력할 경우 
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name), 연차를 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30)
*/
DROP PROCEDURE get_emp;
CREATE PROCEDURE get_emp
    (p_dnum NUMBER) -- 부서번호 입력
IS
    -- 사원번호, 사원이름, 입사일 검색
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = p_dnum;
    
    v_emp_rec emp_cursor%ROWTYPE;
    
    -- 사원 없는 경우 에러
    p_no_emp EXCEPTION;
BEGIN
    -- 커서 실행
    OPEN emp_cursor;
    
    -- 사원 정보 출력 (사원번호, 사원이름, 연차)
    LOOP
        FETCH emp_cursor INTO v_emp_rec;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(v_emp_rec.employee_id || ', ');
        DBMS_OUTPUT.PUT(v_emp_rec.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE(ROUND((SYSDATE - v_emp_rec.hire_date)/365) || '년차');
    END LOOP;
    
    -- 사원 없는 경우 에러 발생
    IF emp_cursor%ROWCOUNT = 0 THEN
        RAISE p_no_emp;
    END IF;
    
    -- 커서 종료
    CLOSE emp_cursor;
    
EXCEPTION -- 예외 처리
    WHEN p_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
END;
/

EXECUTE get_emp(60);
SELECT * 
FROM employees
WHERE department_id = 60;

/*
5.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/
DROP PROCEDURE y_update;
CREATE PROCEDURE y_update
    --사번, 급여 증가치(퍼센트) 입력
    (p_eid NUMBER,
     p_inc_sal NUMBER)
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

EXECUTE y_update(200, 10);
SELECT employee_id, salary
FROM employees
WHERE employee_id = 200;
































