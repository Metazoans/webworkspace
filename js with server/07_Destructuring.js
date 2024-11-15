// 07_Destructuring.js
// 1) Object
let person = {
    firstName : "John",
    lastName : "Doe",
    age : 37,
    email : "john@gamil.com",
    country : "USA"
};
let {lastName, email} = person;
console.log(lastName);
console.log(email);

function getFullName({firstName, lastName}) {
    console.log(`${lastName}, ${firstName}`);
}
getFullName(person);

// 2) Array -> 90만 따로 받는건 불가능(순서대로 들어감)
let scores = [70, 80, 90];

let [a, b, c] = scores;

console.log(a);
console.log(b);
console.log(c);

