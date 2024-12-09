USE dev;

SELECT *
FROM t_users;

UPDATE t_users
SET join_date = NOW()
where user_no > 0;

update t_users
set user_age = 30
where user_no = 9;

INSERT INTO `t_users` ( user_id, user_pwd, user_name, user_gender, user_age, join_date)
VALUES ('test11', '1111', '1111', 'F', 20, NOW());

commit;









