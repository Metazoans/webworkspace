
<template>
  <div class="container">    
    <p>No.</p>
    <input type="text" v-model="boardInfo.no" readonly>
    <p>제목</p>
    <input type="text" v-model="boardInfo.title">
    <p>작성자</p>
    <input type="text" v-model="boardInfo.writer">
    <p>내용</p>
    <textarea v-model="boardInfo.content"></textarea>
    <p>작성일자</p>
    <input type="date" v-model="boardInfo.updated_date">
    <br>
    <div>
      <button @click="updateBoardInfo">저장</button>
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
    let selected = this.$route.params.board_no;

    this.getBoardInfo(selected);
  },
  methods : {
    async getBoardInfo(boardNo) {
      let result = await axios.get(`/api/boards/${boardNo}`)
                              .catch(err => console.log(err));
      this.boardInfo = result.data;
      this.boardInfo.updated_date = this.dateFormat(this.boardInfo.updated_date, 'yyyy-MM-dd');
    },
    async updateBoardInfo() {
      let obj = {
        title : this.boardInfo.title,
        writer : this.boardInfo.writer,
        content : this.boardInfo.conetnt,
        updated_date : this.boardInfo.updated_date
      }

      let result = await axios.put(`/api/boards/${this.boardInfo.no}`, obj)
                              .catch(err => console.log(err));
      let updateRes = result.data;
      if(updateRes.result) {
        alert('정상적으로 수정되었습니다.');
        let bno = this.boardInfo.no;
        this.$router.push({ name : 'boardInfo', query : { no : bno } });
      } else {
        alert('수정사항이 없거나 수정되지 않았습니다.');
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