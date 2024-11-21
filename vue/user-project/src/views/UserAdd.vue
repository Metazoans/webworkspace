<!-- views/UserAdd.vue -->

<template>
<div class="container">
  <table class="table">
    <tr>
      <th class="text-right">아이디</th>
      <td class="text-center"><input type="text" v-model="userInfo.user_id"></td>
    </tr>
    <tr>
      <th class="text-right">비밀번호</th>
      <td class="text-center"><input type="text" v-model="userInfo.user_pwd"></td>
    </tr>
    <tr>
      <th class="text-right">이름</th>
      <td class="text-center"><input type="text" v-model="userInfo.user_name"></td>
    </tr>
    <tr>
      <th class="text-right">성별</th>
      <td class="text-center">
        <input type="radio" value="M" v-model="userInfo.user_gender"> 남자
        <input type="radio" value="F" v-model="userInfo.user_gender"> 여자
      </td>
    </tr>
    <tr>
      <th class="text-right">나이</th>
      <td class="text-center"><input type="number" v-model="userInfo.user_age"></td>
    </tr>
    <tr>
      <th class="text-right">가입일자</th>
      <td class="text-center"><input type="date" v-model="userInfo.join_date"></td>
    </tr>
  </table>
  <div>
    <button class="btn btn-info" @click="addUserInfo">등록</button>
  </div>
</div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      // userInfo : {}
      userInfo : {
        user_id : "",
        user_pwd : "",
        user_name : null,
        user_gender : null,
        user_age : 0,
        join_date : null
      }
    }
  },
  // computed : {
  //   inputCheck() {
  //     let check = true;
  //     for(key in this.userInfo){
  //       check = check && this.userInfo[key] != null && this.userInfo
  //       if(this.userInfo[key] != null)
  //     }
  //   }
  // },
  methods : {
    async addUserInfo() {
      // 전제조건 : 모든 데이터가 입력
      let result = await axios.post('/api/users', this.userInfo)
                              .catch(err => console.log(err));
      if(result.data.user_no > 0) {
        alert('등록되었습니다.');
        this.$router.push({name : 'userInfo', query : {no : result.data.user_no}});
      } else {
        alert('등록되지 않았습니다.');
      }
    }
  }
}
</script>