// calculator.js
// 간단한 사칙연산 기능을 가진 모듈

const defaultNum = 1;

function add(x, y) {
    return x + y;
}

function minus(x, y) {
    return x - y;
}

function multi(x, y) {
    return x * y;
}

function divide(x, y) {
    return x / y;
}

module.exports = {
    add, // 필드명과 변수명이 같으면 생략 가능 ( == "add" : add )
    "mul" : multi // 다른 이름을 사용하려면 변경 가능
};










