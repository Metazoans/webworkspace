<!-- components/StoreComponent.vue -->
<template>
  <div>
    <form>
      <label>
        제품ID :
        <input type="text" v-model="prodInfo.product_id">
      </label>
      <br>
      <label>
        제품명 :
        <input type="text" v-model="prodInfo.product_name">
      </label>
      <br>
      <label>
        카테고리 :
        <input type="radio" value="A" v-model="prodInfo.category"> A
        <input type="radio" value="B" v-model="prodInfo.category"> B
      </label>
      <br>
      <button type="button" @click="addCart">추가</button>
    </form>
    <table>
      <thead>
        <caption>total : {{ total }}</caption>
        <tr>
          <th>카테고리</th>
          <th>제품ID</th>
          <th>제품명</th>
        </tr>
      </thead>
      <tbody>
        <tr :key="info.product_id" 
            v-for="info in products">
          <td>{{ info.category }}</td>
          <td>{{ info.product_id }}</td>
          <td>{{ info.product_name }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>

export default{
  data(){
    return{
      prodInfo : {
        product_id : '',
        product_name : '',
        category : 'A'
      }
    }
  },
  computed : {
    products(){
      return this.$store.state.cart;
    },
    total(){
      return this.$store.getters.cartCount;
    }
  },
  methods : {
    addCart(){
      let obj = {
        product_id : this.prodInfo.product_id,
        product_name : this.prodInfo.product_name,
        category : this.prodInfo.category
      }
      // actions에 등록된 함수를 호출
      this.$store.dispatch('addProduct', obj);
    }
  }
}
</script>