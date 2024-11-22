<!-- <template>
  <div class="commentDiv">
    <table class="table">
      <tbody>
        <tr :key="commentInfo.no" v-for="commentInfo in commentList"
            v-on:click="goToDetailInfo(commentInfo.no)">
          <td>{{ commentInfo.content }}</td>
          <td>{{ commentInfo.writer }}</td>
          <td>{{ dateFormat(boardInfo.created_date, 'yyyy-MM-dd') }}</td>
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
      commentList : []
    }
  },
  created() {
    this.getCommentList(bno);
  },
  methods : {
    async getCommentList(bno) {
      let result = await axios.get(`/api/comments/${bno}`)
                              .catch(err => console.log(err));
      this.boardList = result.data;
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
    }
  }
}
</script> -->