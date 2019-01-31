extension UIViewController {
    
    /// 判断 controller 是否显示在当前窗口
    public var isVisibleOnCurrentWindow: Bool {
        if let _ = self.view.window, self.isViewLoaded {
            return true
        }
        return false
    }
}
