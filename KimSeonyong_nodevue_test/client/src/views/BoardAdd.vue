
<template>
  <div class="container">    
    <p>No</p>
    <input type="text" v-model="boardInfo.no" readonly>
    <p>제목</p>
    <input type="text" v-model="boardInfo.title">
    <p>작성자</p>
    <input type="text" v-model="boardInfo.writer">
    <p>내용</p>
    <textarea v-model="boardInfo.content"></textarea>
    <p>작성일자</p>
    <input type="date" v-model="boardInfo.created_date" readonly>
    <br>
    <div>
      <button @click="addBoardInfo">등록</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      boardInfo : {}
    }
  },
  created() {
    let date = new Date();
    this.boardInfo.created_date = this.dateFormat(date, 'yyyy-MM-dd');
  },
  methods : {
    async addBoardInfo() {
      let result = await axios.post('/api/boards', this.boardInfo)
                              .catch(err => console.log(err));
      if(result.data.board_no > 0) {
        alert('등록되었습니다.');
        this.$router.push({name : 'boardInfo', query : {no : result.data.board_no}});
      } else {
        alert('등록되지 않았습니다.');
      }
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
    }
  }
}
</script>