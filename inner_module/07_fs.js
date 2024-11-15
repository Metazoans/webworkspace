// 07_fs.js

const fs = require('fs');

const data = 'Hello, World!!';

fs.writeFile('./sample.txt', data, 'utf8', (err) => {
    if(err) {
        throw err;
    }
    console.log('파일쓰기 완료!');
});

fs.readFile('./sample.txt', 'utf8', (err, result) => {
    if(err) {
        throw err;
    }
    console.log(result);
})

console.log('작업 종료');