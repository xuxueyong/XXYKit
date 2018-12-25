# Swift 入门 第 4 课 字符串和字符 

Swift 的 String 和 Character 类型提供了快速和兼容 Unicode 的方式供你的代码使用。
每一个字符串都是由编码无关的 Unicode 字符组成，并支持访问字符的多种 Unicode 表示形式。

>注意：
>Swift 的 String 类型 与 NSString 进行了无缝桥接， 可以扩展 String 类型， 对 NSString 中暴露的方法进行调用。 后面举例说明

#### 字符串字面量
字符串字面量是有一对双引号包裹着的一对有序的字符集合组成。

字符串字面量可以初始化常量或变量

```
let someString = "Some string literal value"
```
someString 通过 "Some string literal value" 字面量进行初始化， Swift 推断类型为 String

#### 多行字符串字面量
如果你需要一个跨越多行的字符串字面量， 使用三队双引号包裹即可实现

```
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
```
如果你不想在打印和显示后换行， 但是编辑的时候想换行， 我们可以使用一个续行符反斜杠（\）.

```
let softWrappedQuotation = """
The White Rabbit put on his spectacles.  "Where shall I begin, \
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on \
till you come to the end; then stop."
"""
```

如果想在行首和行尾各留出一行

```
let lineBreaks = """

This string starts with a line break.
It also ends with a line break.

"""
```

#### 字符串字面量的特殊字符
字符串字面量可以包含以下特殊字符

- 转义字符 \0(空字符)、\\(反斜线)、\t(水平制表符)、\n(换行符)、\r(回车符)、\"(双引号)、\'(单引号)。
- Unicode 标量，写成 \u{n}(u 为小写)，其中 n 为任意一到八位十六进制数且可用的 Unicode 位码。

下面的代码为各种特殊字符的使用示例。 wiseWords 常量包含了两个双引号。 dollarSign、blackHeart 和 sparklingHeart 常量演示了三种不同格式的 Unicode 标量：

```
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
// "Imageination is more important than knowledge" - Enistein
let dollarSign = "\u{24}"             // $，Unicode 标量 U+0024
let blackHeart = "\u{2665}"           // ♥，Unicode 标量 U+2665
let sparklingHeart = "\u{1F496}"      // 💖，Unicode 标量 U+1F496
```

在多行字符串字面量中，使用双引号不需要转义符 `\` 但是要在里面使用三个引号， 就需要使用转义符 `、` 了。

```
let threeDoubleQuotes = """
Escaping the first quote \"""
Escaping all three quotes \"\"\"
"""
```

#### 初始化空字符串
可以通过一个空字符串字面量， 或者使用String 实例来初始化一个字符串变量或常量

```
var emptyString = ""               // 空字符串字面量
var anotherEmptyString = String()  // 初始化方法
// 两个字符串均为空并等价。
```
可以通过判断 String 类型的 isEmpty 属性来判断是否为空

```
if emptyString.isEmpty {
    print("Nothing to see here")
}
// 打印输出："Nothing to see here"
```

#### 字符串可变性 
用 var 声明将可变， let 声明将不可变

```
var variableString = "Horse"
variableString += " and carriage"
// variableString 现在为 "Horse and carriage"

let constantString = "Highlander"
constantString += " and another Highlander"
// 这会报告一个编译错误（compile-time error） - 常量字符串不可以被修改。
```

#### 字符串是值类型
Swift 的 String 类型是值类型。在函数或者方法中传递时， 都是重新拷贝一份副本， 和原来的值不会有关系。

在实际编译时， Swift 会优化字符串的使用， 使实际的复制， 只发生在绝对必要的情况下， 这将极大的提高了程序的性能。

#### 使用字符
可以通过 `for in` 来遍历出每一个字符

```
for character in "Dog!🐶" {
    print(character)
}
// D
// o
// g
// !
// 🐶
```

声明一个字符类型 通过 `Character` 关键字

```
let exclamationMark: Character = "!"
```
通过传入一个字符数组来初始化一个 `String`

```
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString)
// 打印输出："Cat!🐱"
```

#### 连接字符串和字符
通过 `+` 号 连接

```
let string1 = "hello"
let string2 = " there"
var welcome = string1 + string2
// welcome 现在等于 "hello there"
```
通过 `+=` 链接

```
var instruction = "look over"
instruction += string2
// instruction 现在等于 "look over there"
```

通过 `append` 将一个字符或字符串添加在尾部

```
let exclamationMark: Character = "!"
welcome.append(exclamationMark)
// welcome 现在等于 "hello there!"
```

>注意：
>你不能将一个字符和字符串，添加在一个已经存在的字符变量上。

#### 字符串插值
字符串插值， 是一种新建字符串的方式， 可以在其中包含 常量、变量、字面量、表达式等。 字符串字面量和多行字符串字面量都可以使用字符串插值。

```
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message 是 "3 times 2.5 is 7.5"
```

#### Unicode
Unicode是一个国际标准，用于文本的编码和表示。 它使您可以用标准格式表示来自任意语言几乎所有的字符，并能够对文本文件或网页这样的外部资源中的字符进行读写操作。 Swift 的 String 和 Character 类型是完全兼容 Unicode 标准的。

#### Unicode 标量
Swift 的 String 类型是基于 Unicode 标量 建立的。 Unicode 标量是对应字符或者修饰符的唯一的21位数字，例如 U+0061 表示小写的拉丁字母（LATIN SMALL LETTER A）（"a"），U+1F425 表示小鸡表情（FRONT-FACING BABY CHICK）（"🐥"）。

>注意
>Unicode 码位（code poing） 的范围是 U+0000 到 U+D7FF 或者 U+E000 到 U+10FFFF。Unicode 标量不包括 Unicode 代理项（surrogate pair） 码位，其码位范围是 U+D800 到 U+DFFF。

注意不是所有的21位 Unicode 标量都代表一个字符，因为有一些标量是留作未来分配的。已经代表一个典型字符的标量都有自己的名字，例如上面例子中的 LATIN SMALL LETTER A 和 FRONT-FACING BABY CHICK。

#### 可扩展的字形群集
Swift 的 Character 类型 代表一个可扩展的子形群。
一个可扩展的字形群是一个或多个可生成人类可读的字符 Unicode 标量的有序排列。
eg： e 和  ́

```
字符串写法
let x = "\u{0065}"
let y = "\u{301}"
let welcome = x + y
print(x, y)
print(welcome)
// e  ́
// é

// 第二种 Character 写法  eAcute 的值 和 z 的值一样 都是一个 `Character` 类型的 é
let eAcute: Character = "\u{E9}" 
let z: Character = "\u{0065}\u{301}"
print(type(of: z))
print(z)
// Character
// é
```

可扩展的字符群集是一个灵活的方法，用许多复杂的脚本字符表示单一的 Character 值。 例如，来自朝鲜语字母表的韩语音节能表示为组合或分解的有序排列。 在 Swift 都会表示为同一个单一的 Character 值：

```
let precomposed: Character = "\u{D55C}"                  // 한
let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"   // ᄒ, ᅡ, ᆫ
print(precomposed,decomposed, separator: ",")
// 한,한
```

可拓展的字符群集可以使包围记号

```
let enclosedEAcute: Character = "\u{E9}\u{20DD}"
// enclosedEAcute 是 é⃝
```
地域性指示符号的 Unicode 标量可以组合成一个单一的 Character 值

```
let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"
// regionalIndicatorForUS 是 🇺🇸
// \u{1F1FA} 🇺
// \u{1F1F8} 🇸
```
#### 计算字符数量
使用 String 类型的属性 count 可以计算出 Character 的个数

```
let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
print("unusualMenagerie has \(unusualMenagerie.count) characters")
// 打印输出 "unusualMenagerie has 40 characters"
```
>注意
>在 Swift 中，使用可拓展的字符群集作为 Character 值来连接或改变字符串时，并不一定会更改字符串的字符数量。

```
 let gg: Character = "\u{1F1FA}"
let hh: Character = "\u{1F1F8}"
let s1 = String([gg, hh])

let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"
let s2 = String(regionalIndicatorForUS)
print(s1.count)
print(s2.count)
// s1 的count 值为 1
// s2 的count 值为 1 
```

给末尾的字符加音标， 字符数量个数没有增加

```
var word = "cafe"
print("the number of characters in \(word) is \(word.count)")
// 打印输出 "the number of characters in cafe is 4"

word += "\u{301}"    // 拼接一个重音，U+0301

print("the number of characters in \(word) is \(word.count)")
// 打印输出 "the number of characters in café is 4"
```

>注意
>可扩展的字符群集可以组成一个或者多个 Unicode 标量。这意味着不同的字符以及相同字符的不同表示方式可能需要不同数量的内存空间来存储。所以 Swift 中的字符在一个字符串中并不一定占用相同的内存空间数量。因此在没有获取字符串的可扩展的字符群的范围时候，就不能计算出字符串的字符数量。如果您正在处理一个长字符串，需要注意 count 属性必须遍历全部的 Unicode 标量，来确定字符串的字符数量。另外需要注意的是通过 count 属性返回的字符数量并不总是与包含相同字符的 NSString 的 length 属性相同。NSString 的 length 属性是利用 UTF-16 表示的十六位代码单元数字，而不是 Unicode 可扩展的字符群集。

#### 字符串索引
String 类型是由 Unicode 标量建立的， 不同Unicode 标量表示的方式， 会造成内存使用也不一样， 所以， String 不能以整数类型 Int 值作为索引值。 String 的索引时以 String.Index 类型来表示的， 它能够遍历完每一个 Unicode 标量。

通过调用 String 的 index(before:) 或 index(after:) 方法，可以立即得到前面或后面的一个索引。您还可以通过调用 index(_:offsetBy:) 方法来获取对应偏移量的索引。

你可以使用下标语法来访问 String 特定索引的 Character。

```
let greeting = "Guten Tag!"
greeting[greeting.startIndex]
// G
greeting[greeting.index(before: greeting.endIndex)]
// !
greeting[greeting.index(after: greeting.startIndex)]
// u
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index]
// a
```

如果索引值越界， 将会产生运行时错误。

```
greeting[greeting.endIndex] // error
greeting.index(after: endIndex) // error
```

使用 indices 属性会创建一个包含全部索引的范围（Range），用来在一个字符串中访问单个字符。

```
let str = "hello world!!"
for index in str.indices {
	print(str[index])
}
```

####  插入和删除 
调用 insert(_:at:) 方法可以在一个字符串的指定索引插入一个字符，调用 insert(contentsOf:at:) 方法可以在一个字符串的指定索引插入一个段字符串。

```
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex)
// welcome 变量现在等于 "hello!"

welcome.insert(contentsOf:" there", at: welcome.index(before: welcome.endIndex))
// welcome 变量现在等于 "hello there!"
```
调用 remove(at:) 方法可以在一个字符串的指定索引删除一个字符，调用 removeSubrange(_:) 方法可以删除一个区间内的子字符串。

```
welcome.remove(at: welcome.index(before: welcome.endIndex))
// welcome 现在等于 "hello there"

let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range)
// welcome 现在等于 "hello"
```
#### 子字符串




