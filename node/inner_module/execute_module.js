// execute_module.js

const cal = require('./calculator.js'); // 같은 경로의 calculator.js 파일을 읽어옴, require를 통해서 모듈로 인식
const {add} = require('./calculator.js');

let result = cal.add(10, 5); // claculator.js 에서 module.exeports로 허용한 것만 접근 가능
console.log(result);

result = add(20, 50); // const {add} 방식으로 사용하는 경우
console.log(result);










