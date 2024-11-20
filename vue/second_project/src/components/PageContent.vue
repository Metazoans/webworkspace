<!-- components/PageContent.vue -->
<template>
  <table>
    <tr>
      <th>제목</th>
      <td>{{ title }}</td>
      <th>조회수</th>
      <td>{{ readInfo }}</td>
    </tr>
    <tr>
      <th>작성자</th>
      <td>{{ writer }}</td>
      <th>작성일자</th>
      <td>{{ regdate }}</td>
    </tr>
    <tr>
      <th>내용</th>
      <td width="200px;" height="100px">{{ content }}</td>
    </tr>
    <tr>
      <button type="button" v-on:click="updateInfo">업데이트</button>
    </tr>
  </table>
</template>
<script>
export default {
  //props : ['title', 'count', 'writer', 'regdate', 'content'],
  props : {
    title : String,
    count : {
      type : Number,
      default : 0
    },
    writer : {
      type : [String, Object],
      default : function(){
        return { first : 'Adward', second : 'Ian'}
      }
    },
    regdate : {
      required : true,
      validator : function(value){
        // yyyy-MM-dd
        let format = /[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]/
        return format.test(value);
      }
    },
    content : String
  },
  computed : {
    readInfo(){
      return this.count + 1;
    }
  },
  methods : {
    updateInfo(){
      // 이벤트 전달
      this.$emit('update-info', this.readInfo);
    }
  }
}
</script>