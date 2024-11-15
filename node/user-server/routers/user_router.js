// router/user_router.js

// 라우팅 = 사용자의 요청(URL + METHOD) + Service + view

const express = require('express');
const router = express.Router();
const userService = require('../service/user_service.js');

// 전체조회
router.get('/users', (req, res) => {
  // let userList = await userService.findAll();
  // res.send(userList);
  userService // async await 대신 Promise 방식으로 작성한 코드 -> 500 에러 코드 때문(사용자에게 무슨 내용으로 에러가 났는지 숨기려고)
    .findAll()
    .then(list => {
      res.send(list);
    })
    .catch(err => {
      res.status(500).send('Fail process');
    })
});

// 단건조회
router.get('/users/:no', async (req, res) => {
  let userNo = req.params.no;
  let info = await userService.findByUserNo(userNo);
  res.send(info);
})

// 등록
router.post('/users', async (req, res) => {
  let newObj = req.body;
  let result = await userService.createNewUser(newObj);
  res.send(result);
})


// 수정
router.put('/users/:no', async (req, res) => {
  let no = req.params.no;
  let info = req.body;
  let result = await userService.updateUserInfo(no, info);
  res.send(result);
})

// 삭제
router.delete('/users/:no', async (req, res) => {
  let userNo = req.params.no;
  let result = await userService.delUserInfo(userNo);
  res.send(result);
})


module.exports = router;

