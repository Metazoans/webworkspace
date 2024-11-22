// test용
require('dotenv').config( { path : './database/mysql.env' } );
const express = require('express');
const app = express();
const boardRouter = require('./router/boardRouter.js');

// 미들웨어
app.use(express.json());

// 라우터 등록
app.use('/', boardRouter);

app.listen(3000, () => {
  console.log('Sever Start');
  console.log('http://localhost:3000');
});

// 라우팅
app.get('/', (req, res) => {
  res.send('test');
});





