<!-- components/PageContent.vue -->
<template>
  <table>
    <tr>
      <th>제목</th>
      <th>{{ title }}</th>
      <th>조회수</th>
      <th>{{ readInfo }}</th>
    </tr>
    <tr>
      <th>작성자</th>
      <th>{{ writer }}</th>
      <th>작성일자</th>
      <th>{{ regdate }}</th>
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
export default{
  // props : ['title', 'count', 'writer', 'regdate', 'content'],
  props : {
    title : String,
    count : {
      type : Number,
      default : 0
    },
    writer : {
      type : [String, Object],
      default : function() {
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
      return this.count +1 ;
    }
  },
  methods : {
    updateInfo(){
      // 이벤트 전달
      this.$emit('update-info', this.readInfo );
    }
  }
}
</script>

<style>

</style>