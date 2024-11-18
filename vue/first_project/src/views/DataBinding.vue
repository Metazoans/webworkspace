<!-- views/DataBinding.vue -->

<template>
  <div>
    <!-- tag의 속성 -->
    <!-- 데이터 바인딩 방법, 이중 괄호 안은 자바스크립트 영역으로 되서 변수명 써도 됨 -->
    <h1>{{ title + ' !!!! ' }}</h1>
    <!-- directive : Vue의 명령 수행, 'v-' 접두어를 사용하는 경우 -->
    <h2 v-text="title" id="home"/>

    <p v-html="tagList"/>
    <p v-text="tagList" v-bind:class="textStyle"/>
    <!-- v-bind 디렉티브 : 단방향(변수가 변경되었을 경우 태그에 일방적으로 입력하는 것) -->


    <hr>


    <!-- v-model 디렉티브 : 양방향(사용자가 입력하는 값에 따라 즉각적 반응) -->
    <input type="text" v-model="valueModel">
    <p>{{ valueModel }}, {{ typeof valueModel }}</p>
    <input type="number" v-model.lazy="numberModel"> <!-- .lazy == 값 인식 딜레이(enter 치기 전에 반응 안함) => 수식어(보조적으로 사용) -->
    <p>{{ numberModel }}, {{ numberModel + 10000 }}</p>
    <!-- 수식어 : v-model.number / v-model.lazy / v-model.trim => vue.js홈페이지 'form 입력 바인딩'에 설명 있음 -->
    
    <select v-model="selectModel">
      <option value="summer">여름</option>
      <option value="winter">겨울</option>
    </select>
    <p>{{ selectModel }}</p>

    <textarea v-model="textModel"></textarea>

    <hr>
    
    <!-- 체크박스 1개인 경우 기본적으로 true/false 값을 반환 -->
    <input type="checkbox" v-model="chData"  
      true-value="여" false-value="부">  <!-- vue가 가지고 있는 체크박스 속성 true/false에 따라 value 변경 -->
    <p>{{ chData }}</p>
    <div>
      <input type="checkbox" value="서울" v-model="city">서울
      <input type="checkbox" value="대구" v-model="city">대구
      <p>{{ city }}</p>
    </div>

    <div>
      <input type="radio" value="독서" v-model="hobby">독서
      <input type="radio" value="영화" v-model="hobby">영화
      <input type="radio" value="운동" v-model="hobby">운동
      <p>{{ hobby }}</p>
    </div>

    <hr>

    <img v-bind:style="styleData" v-bind:src="imgUrl">
    <div class="container" v-bind:class="{'active' : isActive, 'text-red' : hasError}">
      Class Binding First
    </div>
    <div class="container" v-bind:class="myClass">
      Class Binding Second
    </div>
  </div>
</template>


<script>
// html tag에 연결할 변수 선언
export default {
  data() { // 데이터 바인딩에 사용하는 모든 데이터들(CRUD)
    return {
      // v-bind
      title : 'Hello, Vue.js',
      tagList : '<strong>Today is ... </strong>',
      textStyle : 'text-red',
      
      // v-model
      valueModel : 'Korea',
      numberModel : '0',
      selectModel : 'winter',
      textModel : '백견불여일타',

      chData : '',
      city : [],  // 여러 값이 들어가야 해서 배열로 들어감, null 처리 가능
      hobby : '',

      styleData : {
        // backgroundColor : 'skyblue',
        'background-color' : 'skyblue',
        width : '200px'
      },
      // styleData : 'background-color : skyblue; width:200px;',
      imgUrl : 'https://kr.vuejs.org/images/logo.png',
      isActive : false,
      // hasError : !this.isActive,
      myClass : 'active'
    }
  },
  // data외의 요소는 필수는 아님(data도 필수는 아님)
  computed : {      // 이미 존재하는 데이터 기반으로 계산한 결과값(Read Only) / 데이터 바인딩에 사용하는 데이터들(R)
    hasError : function() {
      return !this.isActive;
    }
  },
  methods : {},     // 컴포넌트 내부에서 사용하는 기능 및 함수
  watch : {},       // 감시자 -> 변수들을 감시, 바인딩된 데이터의 변경을 감지하고 연속적 동작 처리
  components : {},  // 하위 컴포넌트 목록
  props : [],       // 부모로부터 넘겨받은 데이터들

}
</script>


<style>
.text-red {
  color : red;
}
.text-blue {
  color : blue;
}

.container {
  width : 100%;
  height : 200px;
}
.active {
  background-color: aquamarine;
  font-weight: bold;
}
</style>









