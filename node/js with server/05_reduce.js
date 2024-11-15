// 05_reduce.js

let points = [40, 100, 1, 5, 25, 10];
let sum = points.reduce((total, currentVal) => {
    return total + currentVal; // 0 + 40 ...
}, 0);

console.log(sum);

let total = 0;
for(let point of points ){
    total = total + point;
}

console.log(total);











