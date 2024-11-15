// sql.js

// 전체조회
const customerList = 
`SELECT id
      , name
      , email
      , phone
      , address
 FROM customers
 ORDER BY id`;

// 단건조회
const customerInfo = 
`SELECT id
      , name
      , email
      , phone
      , address
 FROM customers
 WHERE id = ?`;

// 등록
const customerInsert = 
`INSERT INTO customers
 SET ?`; // 객체 타입 = { 'name' = 'Hong', 'phone' = '010-1234-1234' }

// 수정
const customerUpdate = 
`UPDATE customers
 SET ?
 WHERE id = ?`;
/* 배열 타입 = [ { 'name' = 'Hong', 'phone' = '010-1234-1234' } ],
                id ] */

// 삭제
const customerDelete = 
`DELETE FROM customers
 WHERE id = ?`;


/*

[? 입력값 판단]
1) ? 갯수
1-1) 1개 : 단일 값
1-2) 2개 이상 : 배열

2) ? 앞에 컬럼의 유무
2-1) 컬럼 있음 : 기본 데이터 값(문자, 숫자, 날짜 등)
2-2) 컬럼 없음 : 객체

*/



module.exports = {
  customerList,
  customerInfo,
  customerInsert,
  customerUpdate,
  customerDelete
};














