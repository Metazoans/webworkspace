
const boardList = 
`SELECT b.no
		, b.title
        , b.writer
        , b.content
        , b.created_date
        , b.updated_date
        , COUNT(c.no) as comment
FROM t_board_board b
	 LEFT OUTER JOIN t_comment_board c
     ON b.no = c.bno
GROUP by b.no, b.title, b.writer, b.content, b.created_date, b.updated_date
ORDER BY no`;

const boardInfo =
`SELECT no
	    , title
        , writer
        ,content
        ,created_date
        ,updated_date
        , (SELECT COUNT(*) FROM t_comment_board WHERE bno = b.no) as comment
FROM t_board_board b
WHERE no = ?`;

const boardInsert =
`INSERT INTO t_board_board 
SET ? `;

const boardUpdate =
`UPDATE t_board_board 
SET ? 
WHERE no = ? `;


module.exports = {
  boardList,
  boardInfo,
  boardInsert,
  boardUpdate
}