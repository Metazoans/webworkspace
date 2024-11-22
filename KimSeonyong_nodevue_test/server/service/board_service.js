// service/Board_service.js

const mysql = require('../database/mapper.js');

// 전체조회
const findAllBoard = async () => {
  let list = await mysql.query('boardList');
  return list;
}

// 단건조회
const findByBoardNo = async (boardNo) => {
  let list = await mysql.query('boardInfo', boardNo);
  let info = list[0]; // 하나의 객체가 돌아와도 배열로 돌아와서 한건만 처리하도록 변경
  return info;
}

// 등록
const createNewBoard = async (newObj) => {
  let result = await mysql.query('boardInsert', newObj);
  if(result.insertId > 0) {
    return { board_no : result.insertId };
  } else {
    return {};
  }
}

// 수정
const updateBoardInfo = async (boardNo, updateInfo) => {
  let data = [updateInfo, boardNo];
  let result = await mysql.query('boardUpdate', data);
  let returnData = {};

  if(result.changedRows == 1) {
    returnData.target = { 'board_no' : boardNo };
    returnData.result = true;
  } else {
    returnData.result = false;
  }

  return returnData;
}

// 댓글
const findCommentList = async (bno) => {
  let list = await mysql.query('commentList', bno);
  return list;
}

module.exports = {
  findAllBoard,
  findByBoardNo,
  createNewBoard,
  updateBoardInfo,
  findCommentList
}



