<!-- views/CustomerUpdate.vue -->

<template>
  <div class="container">
    <div class="row">
      <label>아이디</label>
      <input type="text" v-model="info.id" readonly>
    </div>

    <div class="row">
      <label>이름</label>
      <input type="text" v-model.trim="info.name">
      <div class="form-text" :class="{'warning' : nameOk }">
        이름이 입력되지 않았습니다.
      </div>
      <div class="form-text" :class="{'warning' : !nameOk }">
        사용 가능한 이름입니다.
      </div>
    </div>
    <div class="row">
      <label>이메일</label>
      <input type="email" v-model="info.email">
    </div>
    <div class="row">
      <label>연락처</label>
      <input type="tel" v-model="info.phone">
    </div>
    <div class="row">
      <label>주소</label>
      <input type="text" v-model="info.address">
    </div>
    <div class="row">
      <button type="button" v-on:click="updateCustomer"
              :disabled="!(nameOk&&phoneOk)">저장</button>
    </div>
  </div>
</template>


<script>
import axios from 'axios';

export default {
  data() {
    return {
      info : {
        id : null,
        name : null,
        email : null,
        phone : null,
        address : null
      }
    }
  },
  created() {
    // 1) 사용자가 선택한 대상의 원래 데이터 조회
    // => 단건조회
    let selected = this.$route.params.customerId;
    this.getCustomerInfo(selected);
  },
  methods : {
    async getCustomerInfo(id) {
      let result = await axios.get(`/api/customers/${id}`)
                        .catch(err => console.log(err));
      this.info = result.data;
    },
    // 2) 사용자가 버튼을 클릭했을 때 서버에 전송
    // => 등록
    // => mapper에서 update는 배열로 보내야 했지만 서버 내부 동작이기 때문, 클라이언트 부분인 vue에서는 신경쓸 필요 없음
    async updateCustomer() {
      let updateDta = {
        name : this.info.name,
        email : this.info.email,
        phone : this.info.phone,
        address : this.info.address,
        
      }
      let result = await axios.put(`/api/customers/${this.info.id}`, updateDta)
                              .catch(err => console.log(err));
      let sqlRes = result.data;
      if(sqlRes.changedRows > 0) {
        alert('수정되었습니다.');
        this.$router.push({ name : 'customerInfo', query : {customerId : this.info.id} });
      } else {
        alert('수정되지 않았습니다');
      }
    }
    
  },
  computed : {
    nameOk() {
      return this.info.name != null && this.info.name != '';
    },
    phoneOk() {
      return this.info.phone != null && this.info.phone != '';
    }
  },

}
</script>


<style>
.warning {
  display: none;
}
</style>

