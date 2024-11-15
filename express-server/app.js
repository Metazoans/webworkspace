
// 파일 시스템 모듈 불러오기
const fs = require('fs');

// express 모듈 불러오기
const express = require('express');
const server = express();

// router 모듈 불러오기
const userRouter = require('./router/user.js');
server.use('/user', userRouter); // 대표 경로 설정(시작 경로 설정)

// 지정된 폴더 불러오기
server.use('/img', express.static('./images')); // images 폴더의 모든 파일들에 /img 경로로 주소 자동 생성(하위 폴더도 등록)

// 전체 에러 처리
server.use(function(err, req, res, next) {
  res.status(500).json({
    statusCode: res.statusCode,
    errMessage : err.message
  });
});

server.get('/error', (req, res, next) => {
  next(new Error('Process Fail! Check Data!'));
});

// 미들웨어 등록
server.use(express.json());


// DB 설정
const jsonFile = fs.readFileSync('data.json');
const jsonData = JSON.parse(jsonFile); // json을 객체로 변환 == fetch에서 res.json()과 같은 역할


// jsonData로 crud 동작
const query = (crud, target, where = null)=>{
  let result = null;

  let emps = jsonData;
  switch(crud){
  // 조회
  case 'SELECT' :
    result = (where == null) ? emps :  emps.filter(emp => {
      return findEmp(emp, where);
    });
    break;  

  // 등록
  case 'INSERT' :
    emps.push(target);
    break;
  // 수정
  case 'UPDATE' :
    emps.forEach(emp => {
      if(findEmp(emp, where)){
        for(let field in target){
          emp[field] = target[field];
        }
      }
    });
    break;
  // 삭제
  case 'DELETE' :
    let selected = null;
    emps.forEach((emp, idx) => {
      if(findEmp(emp, where)){
        selected = idx;
      }
    });

    emps.splice(selected, 1);
    break;
  }
  
  return result;
};

function findEmp(emp, where){
  let fieldNum = 0; // 총 검색조건 갯수
  let selected = 0; // true인 검색조건 갯수
  for(let field in where){
    fieldNum++;
    if(emp[field] == where[field]){
      selected++;
    }
  }
  return (fieldNum == selected);
}


// 서버 실행, 포트는 일반적으로 3000, 5000 중에 사용
server.listen(3000, () => {
  console.log('Server Start');
  console.log('http://localhost:3000');
});


// 루트 경로
server.get('/', (req, res) => {
  // res.send('Server Connect!');
  res.sendFile('index.html', {root : __dirname});
});

// server.method('endpoint', callback);
// origin = http://localhost:3000

// 전체조회 : GET, emps
// http://localhost:3000/emps/
server.get('/emps', (req, res) => {
  // res.send(jsonData);
  res.send(query('SELECT'));
});

/*
req.params  => pathvariable
req.body    => JSON
req.query   => QueryString

Content-type
1) application/x-www-form-urlencoded
=> QueryString(질의문자열) : key=value,&key=value&...
=> req.query 속성

2) application/json
=> JSON : {} or []
=> req.body 속성

3) pathvariable
=> content-type이 없음
=> req.params 속성

*/

// 단건조회 : GET, emps/:id => pathvariable(경로에 붙는 변수) -> :id에서 콜론은 값을 받는 위치라는 의미
// http://localhost:3000/emps/1
server.get('/emps/:id', (req, res) => {
  // res.send('Emp Info');
  res.send(query('SELECT', null, { id : req.params.id }));
});

// 등록, 수정, 삭제는 브라우저만 가지고는 접근 불가
// 등록     : POST, emps
server.post('/emps', (req, res) => {
  // res.send('Emp Insert');
  console.log(req.body);
  res.send(query('INSERT', req.body));
});

// 수정     : PUT, emps/:id
server.put('/emps/:id', (req, res) => {
  // res.send('Emp Update');
  res.send(query('UPDATE', req.body, { id : req.params.id }));
});

// 삭제     : DELETE, emps/:id
server.delete('/emps/:id', (req, res) => {
  // res.send('Emp Delete');
  res.send(query('DELETE', null, { id : req.params.id }));
});








