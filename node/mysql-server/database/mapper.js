// mapper.js

const mysql = require('mysql');
const sql = require('./sqls/sql.js');

const pool = mysql.createPool({
  host : process.env.MYSQL_HOST,
  port : process.env.MYSQL_PORT,
  user : process.env.MYSQL_USER,
  password : process.env.MYSQL_PWD,
  database : process.env.MYSQL_DB,
  connectionLimit : process.env.MYSQL_LIMIT
});

// Promise는 비동기 작업, 일종의 await
const query = (alias, values) => { // alias = customerList , values = 쿼리문의 조건 = ?를 대체
  return new Promise((resolve, reject) => {

    /*
    자바스크립트 객체 접근 방식 2가지 = 객체명["컬럼명"] / 객체명.컬럼명
    객체명["컬럼명"] 에서는 "" 생략 가능한 경우가 있음 / 객체명.컬럼명 경우도 객체명["컬럼명"]에서 "" 생략한 것
    . 기준은 리터럴 값만 가능 == 변경 가능성 있는 값은 . 방식 사용금지 => sql[alias] 와 sql.alias는 다름
    ==> sql.alias == sql["alias"] / sql내부의 "alias" 필드 값을 찾게됨
    */
    let excuteSql = sql[alias];

    console.log(excuteSql);
    pool.query(excuteSql, values, (err, results) => {
      // 실제로 실행한 결과를 반환
      if(err) {
        console.log(err);
        reject({err});
      } else {
        resolve(results);
      }
    });
  });
}

module.exports = {
  query
};



