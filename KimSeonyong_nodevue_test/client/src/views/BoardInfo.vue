<!-- views/BoardInfo.vue -->

<template>
  <div class="container">
    <div class="row">
      <div class="col-12">
        <div class="row">
          <div class="col-1">번호</div>
          <div class="col-1">{{ boardInfo.no }}</div>
          <div class="col-2">작성일</div>
          <div class="col-3">{{ boardInfo.created_date }}</div>
          <div class="col-2">이름</div>
          <div class="col-3">{{ boardInfo.writer }}</div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <div class="row">
          <div class="col-2">제목</div>
          <div class="col-10">{{ boardInfo.title }}</div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <div class="row">
          <div class="col-12">{{ boardInfo.content }}</div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-2">
        <button type="button" @click="goToUpdateForm(boardInfo.no)">수정</button>
      </div>
    </div>

    <br>

    <!-- 댓글 -->
    <div class="row">
      <div class="col-12">
        <div class="row">
          <div class="col-12">댓글 없음</div>
        </div>
      </div>
    </div>
  </div>
</template>


<script>
import axios from 'axios';
// import CommentList from '@/components/CommentList.vue';

export default {
  data() {
    return {
      boardInfo : {}
    }
  },
  created() {
    let selected = this.$route.query.no;

    this.getBoardInfo(selected);
    
  },
  methods : {
    async getBoardInfo(boardNo) {
      let result = await axios.get(`/api/boards/${boardNo}`)
                              .catch(err => console.log(err));
      this.boardInfo = result.data;
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
    goToUpdateForm(boardNo) {
      this.$router.push({ name : 'boardUpdate', params : {board_no : boardNo} });
    }
  },
  components : {
    // CommentList
  }
}
</script>


