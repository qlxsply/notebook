# JavaScript

## 函数声明

### 函数声明方式

```javascript
//函数名是必须的
function funName(p){
	console.log(p);
}
```

### 函数表达式方式

```javascript
//函数名不是必须的
var funName = function (p){
	console.log(p);
}

var funName = function funName (p){
	console.log(p);
}
```

### 立即执行的函数表达式

```javascript
(function (p) {
    console.log(p);
})("param");
```

## 基础概念

### var

var在函数内声明的变量是函数内的局部变量。如果声明是发生在任何函数外的顶层声明，那么这个变量就属于全局作用域。不初始化会输出undefined。var声明的变量会进行变量提升。

### let

块级作用域，同一作用域内不能重复声明，如果不同作用域同时声明同一名称的变量，就选择最近作用域的变量。和var一样，如果声明发生于任何函数之外，那么该变量也是全局作用域。不初始化会输出undefined。let 声明的变量不存在变量提升。

### const

声明一个只读的常量，一旦声明，常量的值就不能改变。必须初始化。

### 变量提升

使用 var 来声明变量的时候，会提到当前作用域的顶端，而赋值操作在原处不变。

```javascript
console.log(a);
var a = 1;// 输出 undefined
//上述代码经过变量提升后，相当于
var a;
console.log(a);
a = 1;
```

### 函数提升

将函数声明提升至作用域的顶端，只有函数声明方式的函数才能被提升。

```javascript
//运行结果：fun，提升成功
fun1();
function fun1() {
    console.log("fun");
}
//报异常：TypeError: fun2 is not a function，提升失败
fun2();
var fun2 = function () {
    console.log("fun2");
}
```

### 暂时性死区

var声明的变量由于存在变量提升，在其作用域内可以先使用后声明，只是变量的值为undefined。
但是对于let/const声明的变量，不能在声明变量前使用。运行流程进入作用域创建变量，到变量可以被访问之间的这一段时间，就称之为 **暂时性死区**。

```javascript
//此时打印结果为：undefined，是由于变量提升导致的。
console.log(a);
if (false) {
    var a = "abc";
}
//ReferenceError: Cannot access 'a' before initialization
console.log(a);
let a = "abc";
//较为隐蔽的暂时性死区
//ReferenceError: Cannot access 'y' before initialization
function fun(x = y, y = 1) {
    console.log(x);
}
fun();
```

