# Swift 入门 第 3 课 基本运算符
运算符是检查、改变、合并值得特殊符号或短语。

Swift 支持 C 语言的基本运算符， 并做了改进， 避免错误。 例如： ”=“ 不返回值， 在编译时就可以检查出， 本来要使用 ”==“ ， 却使用了 ”=“ 的错误。算数运算符 +，-，*，/，% 等， 编译器会检测， 不允许值溢出。 这样可以避免使用变量时由于大于或者小于类型所能承受的返回而发生的异常情况。
 
Swift 还提供了 a..<b , a...b 这样的区间运算符。 后面会讲到 Swift 的高级运算符。

#### 术语（运算符的类型）
- 一元： 一元运算符针对单一操作对象， 有前置和后置两种， 例如 -a 表示改变变量a的正负情况；!b 表示非b 一般用在布尔值（Bool）； c! 表示强制解包。
- 二元：二元运算符会有两个操作对象，例如 2 + 3， 2 和 3 是两个操作对象， 运算符位于对象中间，也就中缀运算符。
- 三元：针对于三个对象，例如 a ? b : c。 Swift 和 C 一样，只有一个三元运算符（也叫三目运算）

#### 赋值运算符
a = b 表示用 b 的值来更新或初始化 a 的值。

```
let b = 3
var a = 5
a = b
// 现在 a 的值为 3
```
元组赋值， 将被分解为多个常量或变量

```
let (x, y) = (0, 1)
// x = 0, y = 1
```
Swift 和 Objective-C 、C 不一样， 赋值操作， 不会返回任何值。

```
if x = y {   // 编译报错
}
```

#### 算数运算符
- 加法 +
- 减法 -
- 乘法 *
- 除法 /

```
1 + 2       // 等于 3
5 - 3       // 等于 2
2 * 3       // 等于 6
10.0 / 2.5  // 等于 4.0
```
Swift 和 C 和 Objective-C 不同， 不允许数值运算溢出情况发生，但是可以用溢出运算符来实现溢出。 例如 a &+ b， 后面会讲到**溢出运算**

加法运算还可用于 String 和 Array 的拼接, 后面会讲到。

```
let say = ”hello“ + "world!"
```
#### 求余运算符
a % b 表示， b 的多少倍， 可以容入 a， 返回剩下的那部分值。

```
9 % 4 = 1
// 9 = (4 * 2) + 1  // 余数是 1
-9 % 4 = -1
// -9 = (4 * -2) + (-1)  // 余数是 -1
```
#### 一元负号运算符
符号写在操作数前面，中间没有空格。 切换数值的正负情况

```
let three = 3
let minusThree = -three       // minusThree 等于 -3
let plusThree = -minusThree   // plusThree 等于 3, 或 "负负3"
```
#### 一元正号运算符
不做任何改变， 还是原来的值。

```
let minusSix = -6
let alsoMinusSix = +minusSix  // alsoMinusSix 等于 -6
```
#### 组合赋值运算符
\(+，=) 组合

```
var a = 1
a += 2
// a 现在是 3
```
==表达式 a += 2 是 a = a + 2 的简写==


\(-，=) 组合

```
var a = 1
a -= 2
// a 现在是 -1
```

\(*，=) 组合

```
var a = 1
a *= 3
// a 现在是 3
```

#### 比较运算符（Comparison Operators）
- 等于 == 
- 不等于 !=
- 大于 > 
- 小于 < 
- 大于等于 >=
- 小于等于 <= 

>注意：
>Swift 也提供恒等 === 和 !== 判断两个对象是否引用同一个对象实例。 后面在结构体和类中会讲到。

每个比较运算符， 都会返回一个表达式是否成立的布尔值

```
1 == 1   // true, 因为 1 等于 1
2 != 1   // true, 因为 2 不等于 1
2 > 1    // true, 因为 2 大于 1
1 < 2    // true, 因为 1 小于2
1 >= 1   // true, 因为 1 大于等于 1
2 <= 1   // false, 因为 2 并不小于等于 1
```
比较运算符多用于 if 或 while 中

```
let name = "world"
if name == "world" {
    print("hello, world")
} else {
    print("I'm sorry \(name), but I don't recognize you")
}
// 输出 "hello, world", 因为 `name` 就是等于 "world"
```
如果是**元组比较是否相等**， 元组的长度必须相同，比较是按从左到右的顺序， 逐个元素进行比较 直到遇到不等的元素时停止，返回 false， 或者全部的元素相等， 返回 true。

```
let a = (0, 1)
let b = (0, 1)
if a == b {
	print(”\(a) and \(b) is equal“)
}
```
**元组比较大小**

```
(1, "zebra") < (2, "apple")   // true，因为 1 小于 2
(3, "apple") < (3, "bird")    // true，因为 3 等于 3，但是 apple 小于 bird
```
==不能比较里面包含有 Bool 值的元组大小， 是否相等时可以的==

```
("blue", false) < ("purple", true) // 错误，因为 < 不能比较布尔类型
```
>注意：
> Swift 标准库支持最多7个元素的元组比较函数， 超过7个元素的元组， 需要自己实现比较运算符函数。

#### 三元运算符（Ternary Conditional Operator）
可以这样看待三元运算符： `问题 ? 答案 1 : 答案 2`

用 if 条件表示
```
if 问题 {
    答案 1
} else {
    答案 2
}
```
这里有个计算表格行高的例子。如果有表头，那行高应比内容高度要高出 50 点；如果没有表头，只需高出 20 点：

```
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 20)
// rowHeight 现在是 90
```
上面比下面的代码看起来更简洁

```
let contentHeight = 40
let hasHeader = true
var rowHeight = contentHeight
if hasHeader {
    rowHeight = rowHeight + 50
} else {
    rowHeight = rowHeight + 20
}
// rowHeight 现在是 90
```
>注意：
>三元运算符使用的 条件一般都是二选一的场景。 使用过多的三元运算符， 可能降低代码的可读性， 尽量不要在一行中使用多个三元运算符。

#### 空合运算符（Nil Coalescing Operator）
空合运算符 （a ?? b），对 可选类型 a 进行判空操作， 如果 a 有值， 就解封。 如果没值， 就返回默认的 b。条件是 a 必须是可选类型， 且 b 是一个和 a 存储类型相同的值。

空合运算符的实现

```
a != nil ? a! : b
// 如果 a != nil, 那么 b 将不会被计算， 这里使用了短路求值的思想
```
eg: 可选颜色名和默认颜色名的使用

```
let defaultColorName = "red"
var userDefinedColorName: String?   //默认值为 nil

var colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName 的值为空，所以 colorNameToUse 的值为 "red"
```

```
userDefinedColorName = "green"
colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName 非空，因此 colorNameToUse 的值为 "green"
```

#### 区间运算符（Range Operators）

a...b 顶一个从 a 到 b 的所有值的区间。 包含 a 和 b。 a 必须 小于等于 b，否则运行时会报错

区间运算符在迭代一个区间的值时， 非常有用。 for in 循环会在控制流讲到
```
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}
// 1 * 5 = 5
// 2 * 5 = 10
// 3 * 5 = 15
// 4 * 5 = 20
// 5 * 5 = 25
```

#### 半开区间运算符
a..<b 顶一个从 a 到 b 的所有值的区间。 包含 a 但不含 b。 a 必须 小于等于 b，否则运行时会报错

用在数组时， 非常合适。

```
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
    print("第 \(i + 1) 个人叫 \(names[i])")
}
// 第 1 个人叫 Anna
// 第 2 个人叫 Alex
// 第 3 个人叫 Brian
// 第 4 个人叫 Jack
```
#### 单侧区间
往一侧无限延伸的区间， 例如 [2...] 从索引 2 到结尾的所有值。

```
for name in names[2...] {
    print(name)
}
// Brian
// Jack

for name in names[...2] {
    print(name)
}
// Anna
// Alex
// Brian
```
单侧半开区间

```
for name in names[..<2] {
    print(name)
}
// Anna
// Alex
```
>注意
>使用索引时， 要先判断索引值是否在区间内，避免运行时错误（崩溃）。

单侧区间不止可以在下标里使用

```
let range = ...5
range.contains(7)   // false
range.contains(4)   // true
range.contains(-1)  // true
```

#### 逻辑运算符（Logical Operators）
Swift 和 C 一样， 支持三种逻辑运算符

- 逻辑非 !  (!a) 的意思是 a 如果是 true， 表达式的值为 false， 否则为 true.
- 逻辑与 &&  (a && b) 只有 a 和 b 都为 true 的时候， 表达式的值为 true。
- 逻辑或 || (a || b) 只要 a 或者 b 的值为 true，表达式的值就为 true， 否则为 false。

>注意：
>逻辑或和逻辑与， 会执行短路运算， 针对于逻辑与， a 如果为 false， 不会执行 b。 针对逻辑或， a 为 true 不会再执行 b。

eg: 逻辑非

```
let allowedEntry = false
if !allowedEntry {
    print("ACCESS DENIED")
}
// 输出 "ACCESS DENIED"
```
eg: 逻辑与

```
let enteredDoorCode = true
let passedRetinaScan = false
if enteredDoorCode && passedRetinaScan {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
// 输出 "ACCESS DENIED"
```
eg: 逻辑或

```
let hasDoorKey = false
let knowsOverridePassword = true
if hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
// 输出 "Welcome!"
```

#### 逻辑运算符组合计算

```
if enteredDoorCode && passedRetinaScan || hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
// 输出 "Welcome!"
```
从这个例子可以看出， 懵逼了， 最后的逻辑值是 true 还是 false 呢？
所以针对于组合逻辑运算， 我们要加括号， 明确运算优先级。

```
if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
// 输出 "Welcome!"
```
这次就很明白了， 先输入门禁密码且通过视网膜扫描， 或者有门的钥匙， 或者我们知道怎么重置密码， 就会输出 true, 否则为 false










