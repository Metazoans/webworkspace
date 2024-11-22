<template>
  <div>
    <HeaderComponent />
    <router-view />
    <FooterComponent />
  </div>
</template>
<script>
  import HeaderComponent from './layouts/HeaderComponent.vue';
  import FooterComponent from './layouts/FooterComponent.vue';

  export default {
    components  : { 
      HeaderComponent, 
      FooterComponent 
    }
  }
</script>