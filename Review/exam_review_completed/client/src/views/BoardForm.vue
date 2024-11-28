<template>
    <div class="container">
        <form @submit.prevent >

            <label for="no">No.</label>
            <input type="text" id="no" v-model="boardInfo.no" readonly>

            <label for="title">제목</label>
            <input type="text" id="title"  v-model="boardInfo.title">

            <label for="writer">작성자</label>
            <input type="text" id="writer" v-model="boardInfo.writer">    

            <label for="content">내용</label>
            <textarea id="content" style="height:200px" v-model="boardInfo.content"></textarea>

            <label for="regdate">작성일자</label>
            <input type="text" id="regdate" v-model="boardInfo.created_date" >

            <button type="button" class="btn btn-xs btn-info" @click="isUpdated? boardUpdate() : boardInsert()">저장</button>

        </form>
    </div>
</template>
<script>
import axios from 'axios';

export default {
    data() {
        return {
            boardInfo: {
                no : '',
                title : '',
                writer : '',
                content : '',
                created_date : ''
            },
            isUpdated : false
        };
    },
    created() {
        let searchNo = this.$route.query.bno;
        if(searchNo > 0){
            //수정
            this.getBoardInfo(searchNo);
            this.isUpdated = true;
        }else{
            //등록
            this.boardInfo.created_date = this.getToday();  
        }
    },
    methods: {
        async getBoardInfo(searchNo) {
            // 서버에 데이터를 요청
            let result = await axios.get(`/api/boards/${searchNo}`)
                                    .catch(err => console.log(err));
            this.boardInfo = result.data;

            this.boardInfo.created_date = 
                this.dateFormat(this.boardInfo.created_date, 'yyyy-MM-dd');    
        },
        getToday(){
            return this.dateFormat(null, 'yyyy-MM-dd');
        },
        async boardInsert(){
            let obj = {
                title : this.boardInfo.title,
                writer : this.boardInfo.writer,
                content : this.boardInfo.content,
                created_date : this.boardInfo.created_date
            }

            let result = await axios.post("/api/boards", obj)
                               .catch(err => console.log(err));
            let addRes = result.data;
            if(addRes.board_no > 0){
                alert('등록되었습니다.');
                this.boardInfo.no = addRes.board_no;
            }
        },
        async boardUpdate(){
            let obj = {
                title : this.boardInfo.title,
                writer : this.boardInfo.writer,
                content : this.boardInfo.content,
                created_date : this.boardInfo.created_date,
                updated_date : this.dateFormat(this.boardInfo.updated_date, 'yyyy-MM-dd')
            }

            let result = await axios.put(`/api/boards/${this.boardInfo.no}`, obj)
                               .catch(err => console.log(err));
            let updateRes = result.data;
            if(updateRes.result){
                alert('수정되었습니다.');
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
<style scoped>
/* Style inputs with type="text", select elements and textareas */
input[type=text], select, textarea {
  width: 100%; /* Full width */
  padding: 12px; /* Some padding */ 
  border: 1px solid #ccc; /* Gray border */
  border-radius: 4px; /* Rounded borders */
  box-sizing: border-box; /* Make sure that padding and width stays in place */
  margin-top: 6px; /* Add a top margin */
  margin-bottom: 16px; /* Bottom margin */
  resize: vertical /* Allow the user to vertically resize the textarea (not horizontally) */
}

/* Style the submit button with a specific background color etc */
button[type=button] {
  background-color: #04AA6D;
  color: white;
  padding: 12px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

/* When moving the mouse over the submit button, add a darker green color */
button[type=button]:hover {
  background-color: #45a049;
}

/* Add a background color and some padding around the form */
.container {
  border-radius: 5px;
  background-color: #f2f2f2;
  padding: 20px;
}
</style>