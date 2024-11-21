<!-- views/UserInfo.vue -->

<template>
<div class="container">
  <table class="table">
    <tr>
      <th class="text-right">NO</th>
      <td class="text-center">{{ userInfo.user_no }}</td>
    </tr>
    <tr>
      <th class="text-right">아이디</th>
      <td class="text-center">{{ userInfo.user_id }}</td>
    </tr>
    <tr>
      <th class="text-right">비밀번호</th>
      <td class="text-center">{{ userInfo.user_pwd }}</td>
    </tr>
    <tr>
      <th class="text-right">이름</th>
      <td class="text-center">{{ userInfo.user_name }}</td>
    </tr>
    <tr>
      <th class="text-right">성별</th>
      <td class="text-center">{{ userInfo.user_gender == null ? null : userGender }}</td>
    </tr>
    <tr>
      <th class="text-right">나이</th>
      <td class="text-center">{{ userInfo.user_age }}</td>
    </tr>
    <tr>
      <th class="text-right">가입일자</th>
      <td class="text-center">{{ dateFormat(userInfo.join_date, 'yyyy-MM-dd') }}</td>
    </tr>
  </table>
  <div>
    <button class="btn btn-info" @click="goToUpdateForm(userInfo.user_no)">수정</button>
    <!-- router-link는 a태그로 변하는데 클래스를 입혀서 버튼처럼 보이게 만듬 -->
    <router-link to="/userList" class="btn btn-light">목록</router-link>

    <!-- 같은 내용이지만 @click이 함수의 독립성이 강화됨 -->
    <button class="btn btn-warning" @click="delUserInfo(userInfo.user_no)">삭제</button>
    <!-- <button class="btn btn-warning" v-on:click="delUserInfo(userInfo.user_no)">삭제</button> -->
    
  </div>
</div>
</template>


<script>
import axios from 'axios';

export default {
  data() {
    return {
      userInfo : {}
    }
  },
  computed : {
    userGender() {
      return this.userInfo.user_gender == 'M' ? '남' : '여';
    }
  },
  created() {
    // 1) 사용자가 선택한 대상을 확인
    // this.$router.push({ name : 'userInfo', query : {no : userNo} });
    let selected = this.$route.query.no;

    // 2) 실제 데이터를 서버에서 가져옴
    this.getUserInfo(selected);
    
  },
  methods : {
    async getUserInfo(userNo) {
      let result = await axios.get(`/api/users/${userNo}`)
                              .catch(err => console.log(err));
      this.userInfo = result.data;
    },
    async delUserInfo(userNo) {
      let result = await axios.delete(`/api/users/${userNo}`)
                              .catch(err => console.log(err));

      let delRes = result.data;
      if(delRes.result == 'success') {
        alert('삭제 성공');
        this.$router.push({ name : 'userList' });
      } else {
        alert('삭제 실패');
      }
    },
    dateFormat(value, format) {
      let date = value == null ? new Date() : new Date(value);

      let year = date.getFullYear();
      let month = ('0' + (date.getMonth() + 1)).slice(-2);
      let day = ('0' + date.getDate()).slice(-2);

      let result = format.replace('yyyy', year)
                         .replace('MM', month)
                         .replace('dd', day);
      
      return result;
    },
    /*
    {
      path : '/userUpdate/:user_no', // params 사용
      name : 'userUpdate',
      component : UserUpdate
    }
    여기서의 user_no를 기준으로 params 작성
    */
    goToUpdateForm(userNo) {
      this.$router.push({ name : 'userUpdate', params : {user_no : userNo} });
    }
  }
}
</script>


