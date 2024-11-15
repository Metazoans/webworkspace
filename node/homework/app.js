// app.js

const express = require('express');
const app = express();
const mysql = require('./mapper.js');

app.use(express.json());

app.listen(3000, () => {
  console.log('Server start');
  console.log('http://localhost:3000');
});

// 전체조회
app.get('/users', async (req, res) => {
  let list = await mysql.query('userList');
  res.send(list);
});

// 단건조회
app.get('/users/:user_no', async (req, res) => {
  let selected = req.params.user_no;
  let info = (await mysql.query('userInfo', selected))[0];
  res.send(info);
});

// 등록
app.post('/users', async (req, res) => {
  let newObj = req.body;
  console.log(newObj);
  let info = await mysql.query('userInsert', newObj);
  res.send(info);
});

// 수정 작성 못함
app.put('/users/:user_no', async (req, res) => {
  let data = req.body;
  let selected = req.params.user_no;
  let array = [data, selected];
  let info = await mysql.query('userUpdate', array);
  res.send(info);
});

// 삭제
app.delete('/users/:user_no', async (req, res) => {
  let selected = req.params.user_no;
  let info = await mysql.query('userDelete', selected);
  res.send(info);
});








