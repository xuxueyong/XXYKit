---
title: Swift-入门-第-12-课-类和结构体
---

类和结构体对比
结构体和枚举是值类型
类是引用类型
类和结构体的选择
字符串、数组、和字典类型的赋值与复制行为

与其他语言不同的是： Swift 不需要提供一个声明文件和实现文件来分别定义类和结构体的声明和实现， 在一个文件内， 就可以完成。

>注意：
>通常一个类的实例被称作对象， Swift 中类和结构体的关系比较密切， 类中很多的特性，在结构体中也支持， 所以我们都称作实例。

#### 类和结构体对比
Swift 中类和结构体有很多共同点。共同处在于：

1. 定义属性用于存储值
2. 定义方法用于提供功能
3. 定义下标操作通过下标语法可以访问它们的值
4. 定义构造器用于生成初始化值
5. 通过扩展以增加默认实现的功能
6. 遵循协议以提供某种标准功能

与结构体相比，类还有如下的附加功能：

1. 继承允许一个类继承另一个类的特征
2. 类型转换允许在运行时检查和解释一个类实例的类型
3. 析构器允许一个类实例释放任何其所被分配的资源
4. 引用计数允许对一个类的多次引用

#### 定义语法
我们通过关键字 class 和 struct 来分别表示类和结构体，并在一对大括号中定义它们的具体内容：

```
class SomeClass {
    // 在这里定义类
}
struct SomeStructure {
    // 在这里定义结构体
}
```
>注意：
>Swift 定义一个类或者结构体的时候， 相当于自定义了一个类型， 和 String Bool 等一样， 命名时， 应该使用首字符大写的驼峰命名法 `UpperCamelCase`。相应的属性和方法的命名 `UpperCamelCase`。

定义结构体和类的示例：

```
struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}
```
Resolution 结构体定义了两个存储型属性， 表示分辨率。
VideoMode 类定义了 分辨率、帧率、名字等属性， 表示视频模式。

#### 类和结构体实例
描述一个特定分辨率和视频模式， 需要生成一个实例

```
let someResolution = Resolution()
let someVideoMode = VideoMode()
```
构造器语法生产成新的实例， 构造器语法最简单的形式是在结构体和类后面加上括号，通过这种构造方式， 其属性都会被初始化为默认值。 构造过程，会在后面讲到。

#### 属性访问
通过在实例后面使用点语法的形式， 访问属性。

访问 someResolution 的属性
```
print("The width of someResolution is \(someResolution.width)")
// 打印 "The width of someResolution is 0"
```

通过访问 someVideoMode 的属性， 再访问 分辨率的属性

```
print("The width of someVideoMode is \(someVideoMode.resolution.width)")
// 打印 "The width of someVideoMode is 0"
```

也可以使用点语法为属性赋值：

```
someVideoMode.resolution.width = 1280
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")
// 打印 "The width of someVideoMode is now 1280"
```


