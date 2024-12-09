-- 2024-11-15 dev query --

-- MySQL 시간 함수
-- SYSDATE는 로그와 같은 세밀한 시간 추적이 필요한 경우 사용
SELECT SYSDATE();
-- NOW는 쿼리문 실행 하는 순간 값이 고정됨(속도적인 면에서 SYSDATE보다 좋음) => NOW를 MySQL에서 더 많이 사용함
SELECT NOW();

/*
대소문자 구분 안해서 `` 사용
테이블명 컬럼명 테이블명 대문자 사용 금지 -> MySQL에서는 대소문자 구분안함 하지만 자바스크립트에서는 구분해서 문제 발생 가능

CREATE TABLE `t_users`(
	`user_no` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` VARCHAR(100) NOT NULL,
    `user_pwd` VARCHAR(100) NOT NULL,
    `user_name` VARCHAR(100) NOT NULL,
    `user_gender` CHAR(1) CHECK( user_gender IN ( 'M', 'F')),
    `user_age` INT,
    
    `join_date` DATE
);

INSERT INTO `t_users` ( user_id, user_pwd, user_name, user_gender)
VALUES ('Hong', '1234', 'Hong', 'M');

INSERT INTO `t_users` ( user_id, user_pwd, user_name, user_gender)
VALUES ('Han', '1234', 'Han', 'F');

*/

commit;

select *
from t_users;



