// 05_url.js

const url = require('url');

let whatwg = new URL('https://user:pass@sub.example.com:8080/p/a/t/h?query=string#hash');

console.log(whatwg);
let datas = whatwg.searchParams; // URLSearchParams 클래스
datas.forEach((val, key) => {
    console.log(key, val);
})






