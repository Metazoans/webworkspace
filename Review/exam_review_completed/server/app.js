require('dotenv').config({ path : './database/mysql.env'});
const express = require('express');
const app = express();
const boardRouter = require('./router/board_router.js');

// 미들웨어
app.use(express.json()); // application/json

// 라우터 등록
app.use('/', boardRouter);

app.listen(3000, ()=>{
  console.log('Server Start');
  console.log('http://localhost:3000');
})

// 라우팅
app.get('/', (req, res)=>{
  res.send('Welcome!!');
})