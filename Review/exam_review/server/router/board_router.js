const express = require('express');
const router = express.Router();
const boardService = require('../service/board_service.js');

// 전체조회
router.get('/boards', async (req, res)=>{
 
});

// 단건조회
router.get('/boards/:no', async (req,res)=>{

})

// 등록
router.post('/boards', async(req, res)=>{

});

// 수정
router.put('/boards/:no', async(req, res)=>{

});

// 게시글의 댓글 목록 조회
router.get('/boards/:bno/comments', async (req,res)=>{
  let boardNo = req.params.bno;
  let info = await boardService.findCommentsByNo(boardNo);
  res.send(info);
})

module.exports = router;