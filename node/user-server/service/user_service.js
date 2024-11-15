// service/user_service.js
// 서비스에서 (결제 API 호출 / DB에 저장) 이런 기능이 들어있어야 함


const mysql = require('../database/mapper.js');

// 전체조회
const findAll = async () => {
  let list = await mysql.query('userList');
  return list;
}

// 단건조회
const findByUserNo = async (userNo) => {
  let list = await mysql.query('userInfo', userNo);
  let info = list[0]; // 하나의 객체가 돌아와도 배열로 돌아와서 한건만 처리하도록 변경
  return info;
}

// 등록
const createNewUser = async (newObj) => {
  let result = await mysql.query('userInsert', newObj);
  if(result.insertId > 0) {
    return { user_no : result.insertId };
  } else {
    return {};
  }
}

// 수정
const updateUserInfo = async (userNo, updateInfo) => {
  let data = [updateInfo, userNo];
  let result = await mysql.query('userUpdate', data);
  let returnData = {};

  if(result.changedRows == 1) {
    returnData.target = { 'user_no' : userNo };
    returnData.result = true;
  } else {
    returnData.result = false;
  }

  return returnData;
}

// 삭제
const delUserInfo = async (userNo) => {
  let result = await mysql.query('userDelete', userNo);
  if(result.affectedRows == 1 && result.changedRows == 0) {
    return { "result" : "success", "user_no" : userNo };
  } else {
    return { "result" : "fail" };
  }
}

module.exports = {
  findAll,
  findByUserNo,
  createNewUser,
  updateUserInfo,
  delUserInfo
}



