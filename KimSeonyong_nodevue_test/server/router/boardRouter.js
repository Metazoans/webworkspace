// boardRouter.js

const express = require('express');
const router = express.Router();
const boardService = require('../service/board_service.js');

// 전체조회
router.get('/boards', async (req, res) => {
  let boardList = await boardService.findAllBoard();
  res.send(boardList);
});

// 단건조회
router.get('/boards/:no', async (req, res) => {
  let boardNo = req.params.no;
  let info = await boardService.findByBoardNo(boardNo);
  res.send(info);
})

// 등록
router.post('/boards', async (req, res) => {
  let newObj = req.body;
  let result = await boardService.createNewBoard(newObj);
  res.send(result);
})


// 수정
router.put('/boards/:no', async (req, res) => {
  let no = req.params.no;
  let info = req.body;
  let result = await boardService.updateBoardInfo(no, info);
  res.send(result);
})


// 댓글
router.get('/comments/:bno', async (req, res) => {
  let bno = req.params.bno;
  let commentList = await boardService.findCommentList(bno);
  res.send(commentList);
})

module.exports = router;

