<template>
    <div class="container">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>No.</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일자</th>
                    <th>댓글 수</th>
                </tr>
            </thead>
            <tbody>
                <tr :key="board.no" v-for="board in boardList" 
                                    @click="goToDetail(board.no)">
                    <td>{{ board.no }}</td>
                    <td>{{ board.title }}</td>
                    <td>{{ board.writer }}</td>
                    <td>{{ dateFormat(board.created_date, 'yyyy-MM-dd') }}</td>
                    <td>{{ board.comment }}</td>
                </tr>
            </tbody>
        </table>
    </div>
</template>
<script>
import userDateUtils from '@/utils/useDates.js';
import axios from 'axios';

export default {
    data() {
        return {
            boardList: []
        };
    },
    created() {
        // 서버와 통신(=> axios), 값 초기화
        this.getBoardList();
    },
    methods: {
        async getBoardList() {            
            let result = await axios.get('/api/boards')
                                    .catch(err => console.log(err));
            this.boardList = result.data; // 서버가 실제로 보낸 데이터
        },
        goToDetail(boardNo) {
            // 선택한 게시글의 상세정보 페이지를 요청 => this.$router / router 폴더 밑에 검색
            this.$router.push({ name : 'boardInfo', params : { bno : boardNo }});

        },
        dateFormat(value, format) {
            return userDateUtils.dateFormat(value, format);
        }
    }
}
</script>
<style scoped>
table * {
    text-align: center;
}
</style>
