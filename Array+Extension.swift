extension Array {
    
    /// 计算满足条件的元素个数
    func count(where predicate:(Element) -> Bool) -> Int {
        var count = 0
        for element in self {
            if predicate(element) {
                count += 1
            }
        }
        return count
    }
    
    /// 累积操作(+ - * /)  记录每一次累积的值, 产生一个新的数组
    func accumulate<T>(_ initial: T, _ nextSum: (T, Element) -> T) -> [T] {
        var sum = initial
        return map { next in
            sum = nextSum(sum, next)
            return sum
        }
    }
    
    /// 累积操作(+ - * /)  原生本来就有, 写在这里是为了更好的理解 accumulate 是怎样玩的
    func reduce<T>(_ initialResult: T,_ nextPartialResult: (T, Element) -> T) -> T {
        var result = initialResult
        for x in self{
            result = nextPartialResult(result, x)
        }
        return result
    }
    
    /// 原生有, 学习用
    func map2<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) {
            $0 + [transform($1)]
        }
    }
    
    /// 原生有, 学习用
    func filter2(_ isIncluded: (Element) -> Bool) -> [Element] {
        return reduce([]) {
            isIncluded($1) ? $0 + [$1] : $0
        }
    }
    
    /// 原生有, 学习用
    func filter3(_ isInclude: (Element) -> Bool) -> [Element] {
        return reduce(into: [], { (result, element) in
            if isInclude(element) {
                result.append(element)
            }
        })
    }
    
    /// 原生有, 学习用
    func flatMap1<T>(_ transForm: (Element) -> [T]) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(contentsOf: transForm(x))
        }
        return result
    }
}

extension Array where Element: Equatable {
    /// 原生有, 学习用
    func index1(of element: Element) -> Int? {
        for idx in self.indices where self[idx] == element {
            return idx
        }
        return nil
    }
}
