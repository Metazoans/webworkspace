<template>
  <div class="about">
    <!-- template 태그 = 반복시킬 부분을 잡아서 DOM에 등록시키지 않는 태그 -->
    <template :key="info.id" v-for="(info, idx) in list">
      <p v-if="idx % 2 == 0">{{ info }}</p>
    </template>
  </div>
</template>


<script>
import axios from 'axios';

export default {
  data() {
    return {
      list : []
    }
  },
  created() {
    axios.get('/api/customers')
         .then(result => {
           this.list = result.data;
         })
         .catch(err => console.log(err));
  }
}
</script>


