// Table : t_board_board

// 전체조회
const boardList = 
`SELECT no
      , title
      , writer
      , content
      , created_date
      , updated_date
 FROM t_board_board
 ORDER BY no`;

// 단건조회
const boardInfo = 
`SELECT no
      , title
      , writer
      , content
      , created_date
      , updated_date
 FROM t_board_board
 WHERE no = ?`;

// 등록
const boardInsert = 
`INSERT INTO t_board_board
 SET ?`;

// 수정
const boardUpdate = 
`UPDATE t_board_board
 SET ?
 WHERE no = ?`;

const commentList = 
`SELECT no
      , writer
      , content
      , created_date
      , updated_date
      , bno
 FROM t_comment_board
 where bno = ?
 order by no`

module.exports = {
  boardList,
  boardInfo,
  boardInsert,
  boardUpdate,
  commentList
}

