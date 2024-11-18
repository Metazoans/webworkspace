<!-- views/OnEvent.vue -->
 
<template>
<div>
  <!-- v-on:click == @click -->
  <form @click.self="msg('form')"> <!-- .self == 자기 자신을 클릭했을때만 동작(자신의 하위 태그에서 발생한 이벤트에는 발생하지 않음) -->
    Form
    <div @click.once="msg('div')"> <!-- .once == 한번만 동작 -->
      Div
      <p @click.stop="msg('p')"> <!-- stop == 해당 이벤트 처리 후 멈춤(이벤트 버블링 막음) -->
        P
        <a @click.prevent="msg('a')" href="http://www.naver.com"> <!-- .prevent == default handler 무력화 -->
          네이버
        </a>
      </p>
    </div>
  </form>

  <hr>

  <button type="button" v-on:click="increaseCounter">Add 1</button>
  <input v-model.number="num"> <!-- Number(), parseInt() -->
  <!-- $event == 현재 이벤트가 발생한 객체 / vue가 제공하는 일종의 전역변수 -->
  <button type="button" @click="setCount(num, $event)">Add {{ num }}</button>
  <p>The Counter is : {{ counter }}</p>

</div>
</template>


<script>
export default {
  data() {
    return {
      counter : 0,
      num : 7
    }
  },
  methods : {
    msg(tag) {
      alert(`${tag}, 선택!`);
    },
    increaseCounter(event) {
      console.log('increase', event);
      this.counter++; // this.counter += this.num;
    },
    setCount(value, event) {
      console.log('setCount', event);
      this.counter += value;
    }
  }
}
</script>

<!-- scoped는 해당 컴포넌트에만 적용 -->
<style scoped>
form, form * {
  margin: 10px;
  border: 1px solid skyblue;
}
</style>
