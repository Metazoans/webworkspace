<!-- components/PropsComponent.vue -->
<template>
  <div>
    <h2>PageTitle</h2>
    <PageTitle v-bind:title-data="titleData"/>
    <!-- 
      자식에게 넘겨줄 값 
     / 변수 값을 넘겨줄 거면 v-bind:변수명="" 으로 전달  ("'문자열'")로 전달도 가능
     / 리터럴 값으로 넘겨줄 경우 변수명="" 으로 v-bind 생략 가능
     / v-bind: 생략하면 단순 문자열로 인식
     / v-bind="객체명" 으로 전달 가능
     -->
    <p>부모 컴포넌트의 데이터</p>
    <p>Created 와 Mounted 순서의 차이 비교</p>
    <hr>
    <hr>
    <h2>PageContent</h2>
    <PageContent v-bind="info" v-on:update-info="handler"/>
    <!-- $emit 단순 함수만 넘기면 정보만 전달하고 event 객체가 넘어오지 않는다.
    자식 컴포넌트의 데이터를 넘기면 부모 컴포넌트의 매개변수로 넘어온다.-->
    <!-- 
      <PageContent v-bind:title="header"
      v-bind:count="10"
      v-bind:writer="['Adward']"
      v-bind:regdate="20231205"
      v-bind:content="{first : 'Node.js', second : 'Vue.js'}" />
      -->
    <hr>
    <hr>
    <h2>RefComponent</h2>
    <RefComponent ref="child"/>
    <hr>
    <label>부모데이터 : <input type="number" v-model="num"></label>
    <button type="button" @click="childHandler">자식제어</button>
    </div>
  </template>

<script>
import PageTitle from './PageTitle.vue';
import PageContent from './PageContent.vue';
import RefComponent from './RefComponent.vue';

export default {
  data(){
    return {
      titleData : "Hello, Vue.js!! PageTitle",
      header : "게시글 조회",
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
  components : {    // 자식 컴포넌트 등록
    PageTitle,
    PageContent,
    RefComponent
  },
  created(){
    console.log('PropsComponent.vue Create');
  },
  mounted(){
    console.log('PropsComponent.vue Mounted');
  },
  methods: {
    handler(info){    // 자식 컴포넌트의 emit을 기반으로 넘긴 데이터가 매개변수로 넘어옴
      console.log(info);
      alert('자식 컴포넌트 요청');
    },
    childHandler(){
      let RefCom = this.$refs.child;
      RefCom.$refs.btn.click();
      // △ 원래 목적 => 실제 태그에 직접적인 접근을 허용하기 위해
      // this.$refs.child.plusCount();
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