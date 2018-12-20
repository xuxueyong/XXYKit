
/// 累加
/// let numbers = [30, 40, 20, 30, 30, 60, 10]
/// let hh = numbers.accumulate(1, *)
/// print(hh)
/// // [31, 71, 91, 121, 151, 211, 221]
extension Array {
    func accumulate<T>(_ initial: T, _ nextSum: (T, Element) -> T) -> [T] {
        var sum = initial
        return map { next in
            sum = nextSum(sum, next)
            return sum
        }
    }
}
