# Swift 入门 第 2 课 基础

####常量和变量
常量是一个不可修改的值，例如将一个数字10赋值给常量a，a的值以后都不能修改，否则会有编译错误。变量是赋值后可以随意修改的， 例如将一个 "hello"， 赋值给变量b， 再以后的代码编写中， 可以将值再次修改， 使得变量 b 可以被赋值为其他值。

####常量和变量的声明
关键字 let 修饰常量， 关键字 var 修饰变量

```
let maximumNumberOfLoginAttempts = 3
var currentLoginAttempt = 0
```
maximumNumberOfLoginAttempts, 可以理解为最大登录次数。currentLoginAttempt 可以理解为当前已登录的次数。
还可以将多个变量声明在同一行， 中间用逗号隔开：

```
var x = 0.0, y = 0.0, z = 0.0
``` 
> 注意：
> 只有在需要使用变化的量时才用 var，请尽量使用let。 

####类型标注
你可以在声明常量和变量的时候加上类型标注， 表明常量或变量要存储的值的类型。”:“ 代表的意思就是是... 的类型。

```
var welcomeMessage: String
```
这里表示， 声明了一个 welcomeMessage 变量， 且类型为 String， 存储的值只能为String类型。

welcomeMessage可以被设置成任意字符串

```
welcomeMessage = "Hello"
```
你可以在一行中声明多个变量， 用逗号分隔， 并在最后一个变量名后指定数据类型。

```
var red, green, blue: Double
```
>注意：
>常量和变量的声明， 我们一般很少用类型标注， 而是通过设置初始值的方法。Swift有很强的类型推断。上面的例子我们使用的是将welcomeMessage 标注为String类型，而不是使用初始值的类型推断的。 关于类型推断， 将在下面说到。

####常量和变量的命名
常量和变量可以命名为任何字符， 包括Unicode字符

```
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"
```
常量或变量名不能包含数学符号、箭头、保留的（或者非法的）Unicode 码位、连线、制表符等。且不能以数字开头。

一旦常量和变量被声明， 就确定了存储类型， 不能再次修改存储类型， 或者将常量和变量互转。
>注意：
>如果要使用与 Swift 保留关键字相同的名称， 作为变量或常量的名字， 需要使用到 ` 字符， 如 ‘self’。 你应当避免这种使用方法， 除非你别无选择。

变量可以被修改为其他同类型的值：

```
var friendlyWelcome = "Hello!"
friendlyWelcome = "Bonjour!"
// friendlyWelcome 现在是 "Bonjour!"
```
常量和变量不一样， 一旦被确定， 就不可以更改， 负责会编译错误！

```
let languageName = "Swift"
languageName = "Swift++"
// 这会报编译时错误 - languageName 不可改变
```

####输出常量和变量

使用下面的方法， 可以输出变量和常量的值到console

```
print(_ items: Any..., separator: String = default, terminator: String = default)
```
这个先可以不用理解需要传递的参数类型 Any， default， 后面的部分会讲解到**默认参数**。

eg：

```
print(friendlyWelcome)
// 输出 "Bonjour!"
```
默认分割符是空格” “， 如果想要在输出参数之间加其他分割符， 我们传入分割符 如 ”,“

```
let a = 1
let b = 2
print(a,b, separator: ",")
// 1,2
```
默认输出会换行”\n“， 我们给terminator 传入 ” “， 就没不会换行了。

```
print(a, terminator: "")
print(b)
// 12
```
String 会用**字符串插值**的方式， 将常量名和变量名以占位符的方式， 插入到字符串中。String 会用常量值和变量值替换这些占位符，将常量或变量放入圆括号中， 并用反斜杠将其转义。

```
print("The current value of a is \(a)")
// 输出 "The current value of a is 1!
```
>注意：
>字符串插值， 会在后续详细展开

####注释
你需要代码提高自己他他人的阅读性， 好的注释和提示必不可少。Swift会在编译时， 自动忽略掉注释部分。
`单行注释`

```
// 这是一条单行注释
```
`多行注释`

```
/*
	这是一条多行注释
*/
```
`嵌套注释`
Swift 可以嵌套注释，可以很方便的注释掉代码中已经包含部分注释的代码

```
/*这是多行注释
	/*这是嵌套注释*/
*/
```

####分号
Swift 可以在语句后面不写分号 ；， 但是如果你已经习惯了写分号， 也可以， 推荐不写。有一种情况必须写分号， 那就是多条语句放在同一行。

```
let a = 1
let b = 2; let c = 3
```
####整数
整数可以理解为没有小数部分的数字， 例如 12 -32， 包括`有符号`(正整数、 负整数、零)和`无符号`(正整数、零)
Swift 提供了8，16， 32， 64等有符号和无符号整数类型， 例如：8位无符号整数类型 UInt8。 32位有符号整数类型 Int32。

####整数范围
你可以通过访问各个类型的 min 和 max 属性来获得该类型的最大值和最小值

```
let minValue = UInt8.min  // minValue 为 0，是 UInt8 类型
let maxValue = UInt8.max  // maxValue 为 255，是 UInt8 类型
```
min 和 max 所传回的类型， 就是其对应的类型。（如上例中， UInt8 的 min 类型是UInt8 类型）

#####Int 、 UInt
你一般不需要定义整数类型的长度，Int 类型会根据平台的原生字长，对应一样的长度。
32 位平台的 Int 类型，对应的类型是 Int32
64 位平台的 Int 类型，对应的类型是 Int64

指定一样的类型， 可以保证代码的一致和复用性。Int 类型，即使是32位， 一般也足够满足使用场景。
UInt 和 Int 是一样的规则， 只是 UInt 是无符号的，有时候你想数字确定是正整数， 想指定为UInt。
> 注意：
> 一般不推荐指定整数类型长度， 或者无符号整数类型

####浮点数
浮点数是指有小数部分的数字， 如： 3.1415926， 0.1， -21.23

浮点数可以表示的范围更广， Swift 提供了两种有符号的浮点数类型。
`Double`: 表示 64 位有符号的浮点数类型， 一般用于精确度要求很高的场景。
`Float`: 表示 32 位有符号的浮点数类型， 一般用于精确度要求不高的场景。

Double 的小数部分有15位， Float 的小数部分 6 位， 根据使用场景选择。一般推荐使用 Double 类型。

####类型安全和类型推断
Swift 是一个类型安全语言， 它会在编译时确定常量和变量的类型， 不会允许一个 Int 类型的数值传入 String 类型的变量。

因为 Swift 有类型推断，所以编码的时候， 一般不需要去指定数据的类型，Swift 会根据字面量推断出类型，字面量就是指 42， “hello”, 3.2323 等数值

例如 32 赋值给一个常量， 你并没有表明该常量的类型， 但是 Swift 会推断是该常量的类型为 Int

```
let contantValue = 32
print(type(of: contantValue))
// Int
```
如果将浮点类型的字面量赋值给一个常量或变量， Swift 会推断为 Double ,这也是推荐浮点数优先使用 Double 的理由。

```
let doubleValue = 3.14343
print(type(of: doubleValue))
// Double
// 
```
将一个整数和浮点数的表达式， 赋值给一个常量或变量， Swift 还是推断为 Double

```
let anotherPi = 3 + 0.14159
// anotherPi 会被推测为 Double 类型
```
因为表达式中出现了一个浮点数， 表达式的值会被计算为浮点数， 相当于赋值了一个浮点数字面量， 类型推断为 Double

####数值型字面量
整数字面量可以被写作：

- 一个十进制数，没有前缀
- 一个二进制数，前缀是 0b
- 一个八进制数，前缀是 0o
- 一个十六进制数，前缀是 0x
下面的所有整数字面量的十进制值都是 17:

```
let decimalInteger = 17
let binaryInteger = 0b10001       // 二进制的17
let octalInteger = 0o21           // 八进制的17
let hexadecimalInteger = 0x11     // 十六进制的17
```

浮点数十进制表示法：

```
1.25e2 表示 1.25 × 10^2，等于 125.0。
1.25e-2 表示 1.25 × 10^-2，等于 0.0125。
```
浮点数16进制表示法：

```
0xFp2 表示 15 × 2^2，等于 60.0。
0xFp-2 表示 15 × 2^-2，等于 3.75
```

下面的这些浮点字面量都等于十进制的 12.1875：

```
let decimalDouble = 12.1875
let exponentDouble = 1.21875e1
let hexadecimalDouble = 0xC.3p0   // (12 + 3 * 1 / 16) * 2^0
```
数字字面量可以添加额外的下划线来增加可读性。整数和浮点数都可以。

```
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1
```

####整数转换
twoThousand 是一个 UInt16 类型的常量， 而 one 是 UInt8 类型的常量， 他们类型不同， Swift 是不允许类型不同常量和变量运算的。这里要区分出一个整数字面量和浮点数字面量可以相加的区别。

```
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)
```
通过 UInt16(one) 加括号的形式， 将 UInt8 类型转换为 UInt16， 之所以能顾这样转换， 是因为 UInt16 里面有相应的构造器可以完成这一过程。通过扩展， 可以支持更过类型的数据转换， 后面将说到**扩展**

####整数和浮点数转换
整数转浮点数不会有什么影响， 但是浮点数转整数，要考虑精度丢失的问题。

> 字面量本身没有明确的类型， 只是编译器在求值的时候， 需要确定类型， 这也就解释了， 为什么整数字面量和浮点字面量可以相加， 而变量或常量不可以。

####类型别名
就是给现有类型起另外一个名字， 使它更符合场景的用途。用 typealias <#type name#> = <#type expression#>

```
typealias Speed = Double
let carSpeed: Speed = 2.33
let biycleSpeed: Speed = 2.00
```
####布尔值
Swift 有两个布尔字面量， true false。

```
let isFirstLaunch = false
```
不需要指定类型为 Bool， Swift 类型推断可以做到。

一般用于 if **控制流** （会在后面说到）

```
if isFirstLaunch {
	print("yes, app is first Launch")
} else {
	print("app is not first Launch")
}
```

####元组
元组（tuples）是一个复合值。元组内的值可以是任意类型，不需要使用相同的类型。
例如 （404，“Not found”）是一个描述网络请求返回状态码 http status code 的元组。
当你请求的网页或者说地址不存在时， 就会返回一个 404.

```
let http404Error =（404，“Not found”）
```
可以把 http404Error 看成是一个 （Int, String）类型的元组变量。
我们可以定义任何组合 （Int, String, Bool）, (String, Int, String) 等。

我们可以将定义的元组值分解出来使用

```
let (statusCode, description) = http404Error
print(statusCode)
print(description)
```
如果只想要部分值，用 _ 忽略就好

```
let (statusCode, _) = http404Error
print(statusCode)
```
通过下标来访问元组的元素, 下标从零开始

```
let statusCode = http404Error.0
let description = http404Error.1
```
还可以定义的时候给单个元素命名, 直接通过名字访问元素

```
let http200Ok = (status: 200, description: "OK")
print(http200Ok.status)
```
>注意：
>元组在临时组织值的时候非常有用， 不适合创建复杂的数据结构。如果要用复杂数据结构， 还是使用类和结构体较好。

####可选类型
可选类型用来表示值可能缺失的情况， 可选类型表示有两种可能， 有值， 通过可选解析出值来使用， 另一种就是值缺失。 使用的方式是： 在类型后面添加 ？。

> 注意：
> Objective-C 和 C 语言并没有可选类型这个概念。 Objective-C 中如果没有对象返回时， 会有nil 表示的情况。 这只针对于对象， 对于结构体、基本数据类型、枚举等，是不可用的。Objective-C 中会有NotFound 特殊值的情况。 但是对于 Swift的可选类型， 可以暗示为任何类型的值缺失。

####nil
你可以给可选变量赋值为nil

```
var serverResposeCode:nil
serverResposeCode = 404
serverResposeCode = nil
// serverResposeCode 现在不包含值
```
声明常量为可选的时候， 必须赋值。（赋值为 nil， 或者给定一个值）
声明变量为可选的时候， 不指定值， 会默认赋值为 nil.

```
var hht: Int?
// hht 会被自动置为 nil
```
> 注意：
> Objective-C 中 nil 是指向对象的指针不存在。 Swift 中不是用来表示指针的， 而是表示一种值缺失的情况， 不只是对象， 其他类型也一样。

####if 语句以及强制解析
你可以使用 if 和 nil 来判断一个可选量是否有值。 使用”相等“（==）或者 ”不等“（!=）。

如果可选有值， 它将不等于 nil

```
var conNumber: Int? = 12
if conNumber != nil {
	print("\(conNumber!) is not nil value")
	// ! 是强制解包
} else {
 conNumber is equal nil
}
```
>注意：
> ！的使用， 一定要确保有值的时候使用， 否则会造成运行时错误（崩溃）。 ！也叫做强制解析 （forced unwrapping）

####可选绑定
可选绑定（optional binding）不仅可以用来将可选类解包出来， 而且可以将解包出来的值赋值给临时变量或者常量。一般用于 `if` 和 `while` 语句中。


```
var optionalValue: String? 
optionalValue = "hello"
if let constantName = optionalValue {
// 在这里可以使用 临时常量 constantName 的值
// 也可以将 let 改为 var 声明的就是临时变量了
// 这里是已经解包出来的 值 constantName，所以不再需要 ！
} els {
	// 这里是 值缺失的情况
}
```
可以使用多个可选绑定， 中间用 , 号隔开

```
var optionValue1: Int?
var optionValue2: String?
var optionValue3: Bool?
var optionValue4: Bool?
        
if let contant1 = optionValue1, let contant2 = optionValue2, let contant3 = optionValue3, let contant1 = optionValue4 {
       // 只有全部的值都解析出来， 才可以走到这里。     
} else {
            
}
```

#####隐式解析可选类型
当一个可选类型被第一次赋值之后， 就可以保证以后都有值， 就可以声明隐式解析可选类型。（implicitly unwrapped optionals）隐式解析可选类型主要被用于来的构造过程中。

一个隐式解析可选类型声明时， 用！替换？。使用时， 不需要可选解析， 直接可以获取到值。

下面解释了可选类型 String？ 和隐式解析可选类型 String！ 之间的区别

```
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // 需要感叹号来获取值

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString  // 不需要感叹号
```
隐式解析可选类型， 可以被当做是自动解析的可选类型。
>注意：
>如果隐式解析可选类型没有被赋值， 然后取值得时候， 会发生运行时错误（崩溃）， 和使用强制解包 ！一样。

当然你也可以使用 if 来判断它是否有值

```
if assumedString != nil {
    print(assumedString)
}
// 输出 "An implicitly unwrapped optional string."
```
也可用普通可选类型的可选绑定来解析它的值

```
if let definiteString = assumedString {
    print(definiteString)
}
// 输出 "An implicitly unwrapped optional string."
```

>注意：
>如果一个变量要在使用过程中被置为 nil 的话， 请不要使用隐式解析可选类型。如果一个变量的生命周期中，需要判断为 nil， 也优先使用普可选类型。

####错误处理
你可以使用 错误处理（error handling） 来应对程序执行中可能会遇到的错误条件。

```
func canThrowAnError() throws {
    // 这个函数有可能抛出错误
}
```
一个函数可以通过在声明中添加 throws 关键词来抛出错误消息。当你的函数能抛出错误消息时，你应该在表达式中前置 try 关键词。

```
do {
    try canThrowAnError()
    // 没有错误消息抛出
} catch {
    // 有一个错误消息抛出
}
```

一个 do 语句创建了一个新的包含作用域，使得错误能被传播到一个或多个 catch 从句。

这里有一个错误处理如何用来应对不同错误条件的例子。

```
func makeASandwich() throws {
    // ...
}

do {
    try makeASandwich()
    eatASandwich()
} catch SandwichError.outOfCleanDishes {
    washDishes()
} catch SandwichError.missingIngredients(let ingredients) {
    buyGroceries(ingredients)
}
```
在此例中，makeASandwich()（做一个三明治）函数会抛出一个错误消息如果没有干净的盘子或者某个原料缺失。因为 makeASandwich() 抛出错误，函数调用被包裹在 try 表达式中。将函数包裹在一个 do 语句中，任何被抛出的错误会被传播到提供的 catch 从句中。

如果没有错误被抛出，eatASandwich() 函数会被调用。如果一个匹配 SandwichError.outOfCleanDishes 的错误被抛出，washDishes() 函数会被调用。如果一个匹配 SandwichError.missingIngredients 的错误被抛出，buyGroceries(_:) 函数会被调用，并且使用 catch 所捕捉到的关联值 [String] 作为参数。

抛出，捕捉，以及传播错误会在**错误处理**章节详细说明。

#####断言和先决条件
断言 assert 和先决条件都为 为 true 程序继续执行， 为 false 的时候， 中断

断言和先决条件是保证程序必须为 true 的条件下去执行的操作， 是帮助开发者， 写出更更安全的代码。和错误处理不一样， 错误处理是程序产生的一些无法避免的异常情况。执行中断，是为了防止无效的状态导致系统进一步的造成伤害。

断言和先决条件的不同点在于， 它们什么时候进行状态监测， 断言是只在调试环境进行， 而先决条件是在调试和生产环境都进行的。在生产环境， 不会对断言进行评估， 这意味着可以在开发阶段可以使用很短断言， 在生产环境不受影响。

####使用断言进行调试

```
let age = -3
assert(age >= 0, "A person's age cannot be less than zero")
// 因为 age < 0，所以断言会触发
```
####强制执行先决条件

```
// 在一个下标的实现里...
precondition(index > 0, "Index must be greater than zero.")
```
>注意
>如果你使用 unchecked 模式（-Ounchecked）编译代码，先决条件将不会进行检查。编译器假设所有的先决条件总是为 true（真），他将优化你的代码。然而，fatalError(_:file:line:) 函数总是中断执行，无论你怎么进行优化设定。
>你能使用 fatalError(_:file:line:) 函数在设计原型和早期开发阶段，这个阶段只有方法的声明，但是没有具体实现，你可以在方法体>中写上 fatalError("Unimplemented")作为具体实现。因为 fatalError 不会像断言和先决条件那样被优化掉，**所以你可以确保当代码执行到一个没有被实现的方法时，程序会被中断。**

























