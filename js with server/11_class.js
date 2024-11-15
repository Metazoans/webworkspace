// 11_class.js

// 생성자 함수
function User(name, age, city) {
    this.name = name;
    this.age = age;
    this.city = city;
    this.getInfo = () => {
        return `${this.name}, ${this.age}, ${this.city}`;
    }
}

let hong = new User("Hong", 30, "Daegu");
console.log(hong.getInfo());

let Kim = new User("Kim", 25, "Jeju");
console.log(Kim.getInfo());


// class
class Emp {
    constructor(id, name, dept) {
        // 해당 클래스가 가지는 필드 등록
        // _붙은 변수는 암묵적으로 private 취급, 직접 변경 하지 않고 get set로 접근
        this._id = id;
        this._name = name;
        this._dept = dept;
    }

    // get set은 필드 선언, 하지만 자체적인 값을 가지진 않음
    get id() {
        return this._id;
    }

    set name(name) {
        this._name = name;
    }
    get name() {
        return this._name;
    }

    //getter setter도 가능
    setDept(dept) {
        this._dept = dept;
    }
    getDept() {
        return this._dept;
    }




}

let kang = new Emp(100, "Kang", "Sales");
kang.id = 200;  // set 없어서 값을 전달하는 시도는 가능, 하지만 값이 전달되지는 않음
// kang._id = 200; // 직접 접근이 가능함, 암묵적 규칙
kang.name = "King";
kang.setDept("Marketing");
console.log(kang);




