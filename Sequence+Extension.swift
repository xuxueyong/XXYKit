extension Sequence where Element: Hashable {
    
    /// 使得每个元素唯一, 且顺序不变
    func unique() -> [Element] {
        var seen: Set<Element> = []
        return filter { (element) -> Bool in
            if seen.contains(element) {
                return false
            } else {
                seen.insert(element)
                return true
            }
        }
    }
}
