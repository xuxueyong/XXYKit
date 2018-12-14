
/**
    获取launchImage 加载广告图时使用
 */
fileprivate func assetsLaunchImage() -> UIImage? {
    
    let size = UIScreen.main.bounds.size
    
    let orientation = "Portrait" //横屏 "Landscape"
    
    guard let launchImages = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] else {
        return nil
    }
    
    for dict in launchImages {
        
        let imageSize = NSCoder.cgSize(for: dict["UILaunchImageSize"] as! String)
        
        if __CGSizeEqualToSize(imageSize, size) && orientation == (dict["UILaunchImageOrientation"] as! String) {
            
            let launchImageName = dict["UILaunchImageName"] as! String
            let image = UIImage.init(named: launchImageName)
            return image
        }
    }
    return nil
}
