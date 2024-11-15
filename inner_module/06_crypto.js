// 06_crypto.js

const crypto = require('crypto');
const data = 'pw1234';

let encData = crypto.createHash('sha512') // 암호화 알고리즘
                    .update(data)
                    .digest('base64'); // .digest('hex'); 입력시 더 길게 생성됨

console.log(encData);







