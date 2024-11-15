// 02_timers.js

const timeout = setTimeout(() => {
    let today = new Date();
    let year = today.getFullYear();
    let month = ('0' + (today.getMonth() + 1)).slice(-2);
    let day = ('0' + today.getDay()).slice(-2);

    let hour = ('0' + today.getHours()).slice(-2);
    let minute = ('0' + today.getMinutes()).slice(-2);

    let current = `${year}년 ${month}월 ${day}일 ${hour}시 ${minute}분`;
    console.log(current);
}, 2000);

let count = 0;
const interval = setInterval(() => {
    console.log('interval %d', count++);
    if(count == 3) {
        clearInterval(interval);
    }
}, 1000);

const immediate = setImmediate(() => {
    console.log('즉시 실행 요청');
});

console.log('마지막 코드');