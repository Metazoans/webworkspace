// app.js
require('dotenv').config({ path : './database/mysql.env' });
console.log(process.env);
const express = require('express');
const app = express();
const mysql = require('./database/mapper.js');

// content-type : application/json
app.use(express.json());

app.listen(3000, () => {
  console.log('Server start');
  console.log('http://localhost:3000');
});

// 전체조회
app.get('/customers', async (req, res) => {
  let list = await mysql.query('customerList'); // promise가 비동기라서 await async를 사용함
  res.send(list);
});

// 단건조회
app.get('/customers/:id', async (req, res) => {
  let selected = req.params.id;
  let info = (await mysql.query('customerInfo', selected))[0]; // 하나의 객체가 들어있는 배열로 값이 리턴되어 배열을 깨트림
  res.send(info);
});

// 등록
app.post('/customers', async (req, res) => {
  let newObj = req.body;
  console.log(newObj);
  let info = await mysql.query('customerInsert', newObj);
  res.send(info);
});
/*
"affectedRows": 1,
"insertId": 16, -> 추가된 객체의 id 번호
"changedRows": 0
*/

// 수정
app.put('/customers/:id', async (req, res) => {
  let data = req.body;
  let selected = req.params.id;
  let array = [data, selected];
  let info = await mysql.query('customerUpdate', array);
  res.send(info);
});

// 삭제
app.delete('/customers/:id', async (req, res) => {
  let selected = req.params.id;
  let info = await mysql.query('customerDelete', selected);
  res.send(info);
});
/*
[결과값 리턴 판단]
"affectedRows": 1, -> 영향 받은 값 1
"changedRows": 0 -> 변경된 값 0
=> 삭제됨
*/








