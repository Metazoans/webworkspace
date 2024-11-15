// 04_filter_map.js

let persons = [
    {
        name : "유재석",
        point : 78,
        city : "서울"
    },
    {
        name : "김종국",
        point : 92,
        city : "서울"
    },
    {
        name : "양세찬",
        point : 76,
        city : "제주"
    },
    {
        name : "하하",
        point : 81,
        city : "서울"
    }
];

// 1) filter, 원본 배열이 가지는 데이터타입과 같음, 배열의 크기가 줄어들 가능성 있음
let scores = persons.filter(function(val, idx) {
    return val.point > 80; // boolean 타입
});
console.log(scores);

// 2) map, 원본 배열과 데이터 타입이 다를 수 있음, 배열의 크기는 동일
let newList = persons.map(function(val, idx) {
    return {
        no : ((idx + 1) * 100),
        name : val.name,
        city : val.city
    }; // 새로운 배열이 가지는 값 / 원본 배열 연동 안되고 새로운 객체 생성 후 입력

    // val.no = (idx + 1) * 100;
    // return val;
    // 이런 형식으로 하지 말것 -> 원본 배열 값에 연동이 됨
});
console.log(newList);





