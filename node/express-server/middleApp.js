// middleApp.js

// cors 모듈
const express = require('express');
const cors = require('cors');

// express-session 모듈
const session = require('express-session');

const app = express();

// 모든 요청에 응답
// app.use(cors());

// 지정한 요청에 대해서만 응답
const corsOptions = {
  origin : 'http://192.168.0.17:5500', // 자신 ip로 제한
  optionsSuccessStatus : 200
}
app.use(cors(corsOptions));

// application/x-www-form-urlencoded
app.use(express.urlencoded({extended : false}));

app.post('/info', (req, res) => {
  res.send(`keyword : ${req.body.search}`);
});

app.listen(3000, () => {
  console.log('http://localhost:3000');
});

// express-session
let sessionSetting = session({
  secret : '$#@1235TSecdx', // 암호화 키, 의미 없는 시드값(원래는 하드코딩 하지 않음)
  resave : false,
  saveUninitialized : true, // 로그인 전에도 세션을 생성할지 선택
  cookie : { 
    httpOnly : true, // 자바스크립트 기반 쿠키 접근 막음
    secure : false,
    maxAge : 60000 // 쿠키 유효기간
  }
});


app.use(sessionSetting);

app.post('/login', (req, res) => {
  const {id, pwd} = req.body; // { id : 'Hong', pwd : '1234' }
  req.session.user = id;
  req.session.pwd = pwd;
  req.session.save(function(err) {
    if(err) throw err;
    res.redirect('/');
  })
})

app.get('/', (req, res) => {
  res.send(req.session);
});

app.get('/logout', (req, res) => {
  req.session.destroy();
  res.redirect('/');
});



