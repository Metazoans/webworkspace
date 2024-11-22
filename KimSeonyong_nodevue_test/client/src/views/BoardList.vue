<!-- views/BoardList.vue -->

<template>
  <div class="container">
    <table class="table">
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
        <tr :key="boardInfo.no" v-for="boardInfo in boardList"
            v-on:click="goToDetailInfo(boardInfo.no)">
          <td>{{ boardInfo.no }}</td>
          <td>{{ boardInfo.title }}</td>
          <td>{{ boardInfo.writer }}</td>
          <td>{{ dateFormat(boardInfo.created_date, 'yyyy-MM-dd') }}</td>
          <td>{{ 0 }}</td> <!-- 댓글 수 가져오기 -->
        </tr>
      </tbody>
    </table>
  </div>
</template>


<script>
import axios from 'axios';

export default {
  data() {
    return {
      boardList : []
    }
  },
  created() {
    this.getBoardList();
  },
  methods : {
    async getBoardList() {
      let result = await axios.get('/api/boards')
                              .catch(err => console.log(err));
      this.boardList = result.data;
    },
    dateFormat(value, format) {
      let date = value == null ? new Date() : new Date(value);

      let year = date.getFullYear();
      let month = ('0' + (date.getMonth() + 1)).slice(-2);
      let day = ('0' + date.getDate()).slice(-2);

      let result = format.replace('yyyy', year)
                         .replace('MM', month)
                         .replace('dd', day);
      
      return result;
    },
    goToDetailInfo(boardNo) {
      this.$router.push({ name : 'boardInfo', query : { no : boardNo } });
    }
  }
}
</script>


