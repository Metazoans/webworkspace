const { defineConfig } = require('@vue/cli-service')
const server = 'http://localhost:3000'

module.exports = defineConfig({
  transpileDependencies: true,
  // cors 무력화 위한 설정 => proxy setting 
  devServer : {
    port : 8099,
    proxy : {
      '^/api' : {
        target : server,
        changeOrigin : true,
        pathRewrite : { '^/api' : '/'},
        ws : false
      }
    }
  }
})
