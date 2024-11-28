<template>
  <div class="card">
    <div class="card-header">댓글 목록</div>
    <div class="card-body">
      <ul class="list-group">
        <li class="list-group-item" :key="idx" v-for="(comment, idx) in commentList">
          <div class="container">
            <div class="row text-start">
              {{ comment.content }}
            </div>
            <div class="row">
              <div class="col-9 text-end">
                {{ comment.writer }}
              </div>
              <div class="col-3 text-center">
                {{ dateFormat(comment.created_date, 'yyyy-MM-dd') }}
              </div>
            </div>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>
<script>
//CommentList.vue
import userDateUtils from '@/utils/useDates.js';
import axios from 'axios';

export default {
  props: ['bno'],
  data() {
    return {
      commentList: []
    }
  },
  created() {
    this.getCommentList();
  },
  methods: {
    async getCommentList() {
      let result = await axios.get(`/api/boards/${this.bno}/comments`)
        .catch(err => console.log(err));
      this.commentList = result.data;
    },
    dateFormat(value, format) {
      return userDateUtils.dateFormat(value, format);
    }
  }
}
</script>
