// router/user.js

const express = require('express');
const router = express.Router();

// /user/
router.get('/', (req, res) => {
  res.send('회원 정보 조회');
});

// /user/insert
router.post('/insert', (req, res) => {
  res.send('회원등록');
});

module.exports = router; // 사실상 종료 문구임, 뒤에 코드 추가 작성 금지
