<!-- views/UserList.vue -->

<template>
<div class="container">
  <table class="table">
    <caption>Total : {{ count }}</caption>
    <thead>
      <tr>
        <th>NO</th>
        <th>아이디</th>
        <th>이름</th>
        <th>성별</th>
        <th>가입날짜</th> <!-- yyyy-MM-dd-->
      </tr>
    </thead>
    <tbody>
      <tr :key="userInfo.user_no" v-for="userInfo in userList"
          v-on:click="goToDetailInfo(userInfo.user_no)">
        <td>{{ userInfo.user_no }}</td>
        <td>{{ userInfo.user_id }}</td>
        <td>{{ userInfo.user_name }}</td>
        <td>{{ userInfo.user_gender }}</td>
        <td>{{ dateFormat(userInfo.join_date, 'yyyy-MM-dd') }}</td>
      </tr>
    </tbody>
  </table>
</div>
</template>


<script>
import axios from 'axios';

export default {
  data() {
    return {
      userList : []
    }
  },
  computed : {
    count() {
      return this.userList.length;
    }
  },
  created() { // 객체 생성완료 시점 => 초기화 데이터 호출
    this.getUserList();
  },
  methods : {
    async getUserList() {
      let result = await axios.get('/api/users')
                              .catch(err => console.log(err));
      this.userList = result.data;
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
    goToDetailInfo(userNo) {
      this.$router.push({ name : 'userInfo', query : { no : userNo } });
    }
  }
}
</script>

