// 02_declare_fun.js
// 1) 함수선언문 => var

/*
// 함수 호이스팅
var plus = function(x,y,z) {
    return (x + y + z);
}
*/

function plus(x, y) {
    return (x + y);
}
console.log(plus(1,2,3));

function plus(x, y, z) {
    return (x + y + z);
}


console.log(plus(1,2,3));


// 2) 함수표현식 => let, const 방식으로 함수를 선언
const printMsg = function(keyword) {
    return "result : " + keyword;
}

// 3) 화살표 함수 =>    () => {} //자바스크립트 방식    ()->{} //자바 방식(람다 방식)
let aray = [1, 2, 3, 4, 5];
aray.forEach( val => console.log(val) );

aray.forEach( (val, idx, array) => {
    let msg = `${idx} : ${val} , ${array}`; //템플릿 리터럴
    console.log(msg);
});

const multi = (x, y) => x * y;
console.log(multi(10, 5));









