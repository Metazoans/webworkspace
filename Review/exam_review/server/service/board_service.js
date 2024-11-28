const mysql = require('../database/mapper.js');

// 전체조회
const findAllBoard = async ()=>{

}

// 단건조회
const findBoardByNo = async (no)=>{

}

// 등록
const createNewBoard = async (boardInfo)=>{

}

// 수정
const updateBoardInfo = async (no, updateInfo)=>{

}

// 게시글의 댓글 목록 조회
const findCommentsByNo = async (no)=>{
  let list = await mysql.query('commentListByBno', no);
  return list;
}

module.exports = {
  findAllBoard,
  findBoardByNo,
  createNewBoard,
  updateBoardInfo,
  findCommentsByNo
}