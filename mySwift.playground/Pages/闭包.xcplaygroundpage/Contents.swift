
//: # page23 BaseDataType
//: 侯伟杰 --: SwiftPlayground--https://github.com/kaqijiang
//: [previous](@previous)


import Foundation

var str = "Hello, playground"

/*
 闭包:
 函数是闭包的一种
 类似于OC语言的block
 闭包表达式(匿名函数) -- 能够捕获上下文中的值
 
 语法: in关键字的目的是便于区分返回值和执行语句
 闭包表达式的类型和函数的类型一样, 是参数加上返回值, 也就是in之前的部分
 {
 (参数) -> 返回值类型 in
 执行语句
 }
 
 一般形式：{
 (parameters) -> returnType in
 statements
 }
 */

//完整写法
let say:(String) -> Void = {
    
    (name:String) -> Void in
    print("hello \(name)")
}
say("LiLi")

//没有返回值写法
let say2:(String) -> Void = {
    
    (name: String) -> Void in
    print("hellp \(name)")
}
say2("liMing")

let say3:() -> Void = {
    print("hi")
}
say3()


//一般形式
let calAdd:(Int,Int)->(Int) = {
    (a:Int,b:Int) -> Int in
    return a + b
}
print(calAdd(100,150))

//Swift可以根据闭包上下文推断参数和返回值的类型，所以上面的例子可以简化如下
let calAdd2:(Int,Int)->(Int) = {
    a,b in  //也可以写成(a,b) in
    return a + b
}
print(calAdd2(150,100))
//上面省略了返回箭头和参数及返回值类型，以及参数周围的括号。当然你也可以加括号，为了好看点，看的清楚点。(a,b)

//单行表达式闭包可以隐式返回，如下，省略return
let calAdd3:(Int,Int)->(Int) = {(a,b) in a + b}
print(calAdd3(50,200))

//如果闭包没有参数，可以直接省略“in”
let calAdd4:()->Int = {return 100 + 150}
print("....\(calAdd4())")

//既没有参数也没返回值，所以把return和in都省略了
let calAdd5:()->Void = {print("我是23")}
calAdd5()

/** 闭包表达式作为回调函数 **/

func showArray(array:[Int]) {
    for num in array {
        print("\(num)")
    }
}
showArray(array: [1,2,3,4,5])


let cmp = {
    (a: Int, b: Int) -> Int in
    if a>b{
        return 1
    }else if a<b {
        return -1
    }else {
        return 0
    }
}

func bubbleSort(array: inout [Int], cmp: (Int ,Int) -> Int) {
    
    for _ in array {
        
        for j in 0 ..< (array.count - 1) {
            
            if array[j] > array[j + 1] {
                array.swapAt(j, j + 1)
            }
        }
    }
}

var arr:Array<Int> = [22,23,34,13]
bubbleSort(array: &arr, cmp: cmp)
showArray(array: arr)

// 闭包作为参数传递
bubbleSort(array: &arr, cmp: {
    (a: Int, b: Int) -> Int in
    if a > b {
        return 1
    }else if a < b{
        return -1
    }else {
        return 0
    }
})
print("----")
showArray(array: arr)

print("----")

// 如果闭包是最后一个参数, 可以直接将闭包写到参数列表后面, 这样可以提高阅读性, 称之为尾随闭包
bubbleSort(array: &arr){
    (a: Int, b: Int) -> Int in
    if a>b {
        return 1
    }else if a<b {
        return -1
    }else {
        return 0
    }
}

// 闭包表达式优化,
// 1.类型优化, 由于函数中已经声明了闭包参数的类型, 所以传入的实参可以不用写类型
// 2.返回值优化, 同理由于函数中已经声明了闭包的返回值类型,所以传入的实参可以不用写类型
// 3.参数优化, swift可以使用$索引的方式来访问闭包的参数, 默认从0开始

bubbleSort(array: &arr){
    if $0 > $1{
        return 1
    }else if $0 < $1{
        return -1
    }else {
        return 0
    }
}

// 如果只有一条语句可以省略 return
let hello = {
    "lllllll"
}
print(hello())

/*
 自动闭包:
 顾名思义，自动闭包是一种自动创建的闭包，封装一堆表达式在自动闭包中，然后将自动闭包作为参数传给函数。而自动闭包是不接受任何参数的，但可以返回自动闭包中表达式产生的值。
 
 自动闭包让你能够延迟求值，直到调用这个闭包，闭包代码块才会被执行。说白了，就是语法简洁了，有点懒加载的意思。
 */

var array = ["1","100","hi","hello"]
print(array.count) // 4

let removeBlock = {array.remove(at: 3)}
print(array.count) // 4

print("执行代码块移除\(removeBlock())")
print(array.count) // 3

/*
 逃逸闭包:
 当一个闭包作为参数传到一个函数中，需要这个闭包在函数返回之后才被执行，我们就称该闭包从函数种逃逸。一般如果闭包在函数体内涉及到异步操作，但函数却是很快就会执行完毕并返回的，闭包必须要逃逸掉，以便异步操作的回调。
 
 逃逸闭包一般用于异步函数的回调，比如网络请求成功的回调和失败的回调。语法：在函数的闭包行参前加关键字“@escaping”。
 */

//例1:
func doSomething(some: @escaping() -> Void) {
    //延时操作, 注意这里的单位是秒
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        // 1s后操作
         some()
    }
    print("函数体")
}
doSomething {
    print("逃逸闭包")
}


//例2:
var comletionHandle:() -> String = {"约吗?"}

func doSomthing2(some: @escaping() -> String) {
    comletionHandle = some
}
doSomthing2 { () -> String in
    return "还是不约吧!"
}
print(comletionHandle())

//将一个闭包标记为@escaping意味着你必须在闭包中显式的引用self。
//其实@escaping和self都是在提醒你，这是一个逃逸闭包，
//别误操作导致了循环引用！而非逃逸包可以隐式引用self。

//例子如下:
var completionHandlers: [() -> Void] = []
//逃逸
func someFuncionWithEscapingClosure(completionHandler: @escaping () -> Void ) {
    completionHandlers.append(completionHandler)
}
//非逃逸
func someFunctionWithNonescapingCloure(cloure: () -> Void)
{
    cloure()
}

class SomeClass{
    var x = 10
    func doSomething()
    {
        someFuncionWithEscapingClosure {
            self.x = 100
        }
        someFunctionWithNonescapingCloure {
            x = 200
        }
    }
}


//闭包捕获值

func getIncFunc(inc: Int) -> (Int) -> Int {
    var max = 10
    func incFunc(x: Int) -> Int {
        print("incFunc函数结束")
        max += 1
        return max + x
    }
    // 当执行到这一句时inc参数就应该被释放了, 但是由于在内部函数中使用到了它, 所以它被捕获了;
    // 同理, 当执行完这一句时max变量就被释放了, 但是由于在内部函数中使用到了它, 所以它被捕获了.
    print("getIncFunc函数结束")
    return incFunc
}
//当捕获的值回合与之对应的方法绑定在一起, 同意个方法中的变量会被绑定到不同的方法中
let incFunc = getIncFunc(inc: 5)

print(incFunc(5))
print(incFunc(5))

let incFunc2 = getIncFunc(inc: 5)
print(incFunc2(5))




//: [Next](@next)

