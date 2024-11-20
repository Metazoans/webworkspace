<!-- components/PropsComponent.vue -->
<template>
  <div>
    <PageTitle title="Hello, Vue.js!!!" />
    <hr>
    <!-- <PageContent v-bind:title="header"
                 v-bind:count="10"
                 :writer="['Adward']"
                 :regdate="20231205"
                 :content="{first : 'Node.js', second : 'Vue.js'}" /> -->
    <PageContent v-bind="info" v-on:update-info="handler"/>
    <hr>
    <RefCom ref="child"/>
    <hr>
    <label> 부모 데이터 : <input type="number" v-model="num"></label>
    <button type="button" @click="childHandler">자식 제어</button>
  </div>
</template>
<script>
import PageTitle from './PageTitle.vue';
import PageContent from './PageContent.vue';
import RefCom from './RefComponent.vue';

export default {
  data(){
    return {
      header : '게시글 조회',
      info : {
       title : 'Today is',
       count : 5,
       writer : 'Adward',
       regdate : '2024-11-19',
       content : 'No Content' 
      },
      num : 0
    }
  },
  components : { // 자식 컴포넌트 등록
    PageTitle,
    PageContent,
    RefCom
  },  
  created(){
    console.log('PropsComponent.vue Created');
  },
  mounted(){
    console.log('PropsComponent.vue Mounted');
  },
  methods : {
    handler(info){ // 자식 컴포넌트의 emit을 기반으로 넘긴 데이터가 매개변수로 넘어옴
      console.log(info);
      alert('자식 컴포넌트 요청');
    },
    childHandler(){
      //this.$refs.child.plusCount();
      let RefCom = this.$refs.child;
      RefCom.$refs.btn.click();
    }
  },
  watch : {
    num(){
      console.log(this.$refs);
      this.$refs.child.content = this.num;
    }
  }
}
</script>