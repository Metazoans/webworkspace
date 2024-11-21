<template>
  <div>
    <!-- header component -->
    <!-- <router-link to="/customerList">전체조회</router-link>
    <router-link to="/customerAdd">등록</router-link> -->

    <DefaultHeader/>

    <!-- content component -->
    <router-view/>
    
    <!-- footer component -->
    
  </div>
</template>


<script>
import DefaultHeader from './layouts/DefaultHeader.vue';

export default {
  components : {
    DefaultHeader
  }
}
</script>


<style>
</style>
