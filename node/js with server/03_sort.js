// 03_sort.js

let fruits = ["Banana", "Orange", "Appple", "Mango"];
fruits.sort(); //원본 배열 변경
console.log(fruits);

let points = [40, 100, 1, 5, 25, 10];
points.sort();
console.log(points); // [ 1, 10, 100, 25, 40, 5 ]

points.sort(function(a, b) {
    return a - b;
});
console.log(points);

let emps = [
    {
        eid: 200,
        name : "King"
    },
    {
        eid : 100,
        name : "Edward"
    },
    {
        eid : 300,
        name : "Han"
    }
];

emps.sort((pre, next) => {
    return pre.eid - next.eid;
});
console.log(emps);







