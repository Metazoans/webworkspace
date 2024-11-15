const express = require('express'); // express 모듈 불러오기
const app = express();

// 서버가 제공하는 서비스, 라우팅 메소드
app.get('/', (req, res) => { // get, post 방식에서의 get 방식으로 요청 / (request, response)
  res.send('Server Connect');
});

//서버 실행
app.listen(3000, () => { // 3000포트를 선택하여 서버 실행, 실행 완료시 콜백 함수를 통해서 접속 경로 출력
  console.log('서버가 실행됩니다.');
  console.log('http://localhost:3000');
});

//터미널 강제 종료 = ctrl + c
//서버 종료시 ctrl + c
