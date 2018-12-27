---
title: Swift 入门 第 11 课 枚举
---

Swift 的枚举 不像 C 语言的枚举值， 必须给原始值。 Swift 可以不指定原始值。也可以指定原始值， 原始值的类型可以是整形、字符串、字符、浮点数等。

Swift 的枚举可以添加关联值， 关联值可以是任意类型。就像其他语言的联合体 `Union` 和 变体 `variants` 。可以给每一个枚举成员定义不同或者相同的类型的关联值。

Swift 的枚举是一等（first-class）类型。它支持了很对传统上class（类）才支持的特性。例如计算性属性(computed properties)用于提供枚举值得附加信息。实例方法(instance methods)， 用于提供和枚举值相关联的功能。枚举也可以定义构造函数来提供一个初始值， 在原来的实现上扩展功能， 也可以实现协议， 提供标准的功能。

#### 枚举语法
使用 enum 关键字， 将枚举成员放在大括号内

下面是用枚举表示指南针四个方向的例子：

```
enum CompassPoint {
    case north
    case south
    case east
    case west
}
```

>注意：
>与 C 和 Objective-C 不同，Swift 的枚举成员在被创建时不会被赋予一个默认的整型值。在上面的 CompassPoint 例子中，north，south，east 和 west 不会被隐式地赋值为 0，1，2 和 3。相反，这些枚举成员本身就是完备的值，这些值的类型是已经明确定义好的 CompassPoint 类型。

多个成员值可以出现在同一行上，用逗号隔开：

```
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```

每个枚举都是一个全新的类型， 类型名的首字符大写， 且是单数名字。

```
var directionToHead = CompassPoint.west
```
如果声明 directionToHead 的类型，或者下面修改它的值，就可以使用点语法

```
directionToHead = .east
```

#### 使用 Switch 语句匹配枚举值
你可以使用 switch 语句匹配单个枚举值：

```
directionToHead = .south
switch directionToHead {
    case .north:
        print("Lots of planets have a north")
    case .south:
        print("Watch out for penguins")
    case .east:
        print("Where the sun rises")
    case .west:
        print("Where the skies are blue")
}
// 打印 "Watch out for penguins”
```
强制穷举确保了枚举成员不会被意外遗漏。 推荐穷举

当不需要匹配每个枚举成员的时候，你可以提供一个 default 分支来涵盖所有未明确处理的枚举成员：

```
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}
// 打印 "Mostly harmless”
```

#### 关联值
假设我们想存储商品的条形码和二维码

```
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
```
// upc 代表条形码  qrCode 代表二维码

创建一个新的条形码：

```
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
```
上面的例子创建了一个名为 productBarcode 的变量，并将 Barcode.upc 赋值给它，关联的元组值为 (8, 85909, 51226, 3)

创建一个新的二维码：

```
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
```

你可以在 switch 的 case 分支代码中提取每个关联值作为一个常量（用 let 前缀）或者作为一个变量（用 var 前缀）来使用：

```
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
// 打印 "QR code: ABCDEFGHIJKLMNOP."
```

如果一个枚举成员的所有关联值都被提取为常量，或者都被提取为变量，为了简洁，你可以只在成员名称前标注一个 let 或者 var：

```
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
// 输出 "QR code: ABCDEFGHIJKLMNOP."
```

#### 原始值
这是一个使用 ASCII 码作为原始值的枚举：

```
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
```
枚举类型 ASCIIControlCharacter 的原始值类型被定义为 Character，并设置了一些比较常见的 ASCII 控制字符。Character 的描述详见字符串和字符部分。

原始值可以是字符串、字符，或者任意整型值或浮点型值。每个原始值在枚举声明中必须是唯一的。

>注意：
>原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值，像上述三个 ASCII 码。对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化。

