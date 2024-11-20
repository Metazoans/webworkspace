const { defineConfig } = require('@vue/cli-service')
const serverOrigin = 'http://localhost:3000';

module.exports = defineConfig({
  transpileDependencies: true,
  devServer : {
    proxy : {
      '^/api' : { // 정규표현식, ^/api == /api로 시작하는 모든 요청에 대해 처리
        target : serverOrigin, // 변경하고자 하는 오리진
        changeOrigin : true,
        ws : false,
        pathRewrite : {'^/api' : '/'}
      }
    }
  }
})
