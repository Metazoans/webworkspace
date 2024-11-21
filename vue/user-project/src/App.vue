<template>
  <nav>
    <HearderComponent/>
  </nav>
  <router-view/>
</template>


<script>
import HearderComponent from './layouts/HearderComponent.vue';

export default {
  components : {
    HearderComponent
  }
}
</script>
