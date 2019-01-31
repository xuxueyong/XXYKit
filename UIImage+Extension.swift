
//let (images, duration) = showGif()!
//let animatedImage = UIImage.animatedImage(with: images, duration: duration)
//imageView = UIImageView.init(image: animatedImage)
//self.view.addSubview(imageView!)
//imageView?.center = self.view.center



private func showGif() ->([UIImage], TimeInterval)? {
    let path = Bundle.main.path(forResource: "course_player_loding", ofType: "gif")
    let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path!))
    let source = CGImageSourceCreateWithData(data as! CFData, nil)
    let count = CGImageSourceGetCount(source!)
    let options: NSDictionary = [kCGImageSourceShouldCache as String: true, kCGImageSourceTypeIdentifierHint as String: CFString.self]
    var gifDuration = 0.0
    var images = [UIImage]()
    func frameDuration(from gifInfo: NSDictionary) -> Double {
        let gifDefaultFrameDuration = 0.100
        let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
        let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
        let duration = unclampedDelayTime ?? delayTime
        guard let frameDuration = duration else { return gifDefaultFrameDuration }
        return frameDuration.doubleValue > 0.011 ? frameDuration.doubleValue : gifDefaultFrameDuration
    }
    for i in 0 ..< count {
        guard let imageRef = CGImageSourceCreateImageAtIndex(source!, i, options) else {
            return nil
        }
        if count == 1 {
            //只有一张图片时
            gifDuration = Double.infinity//无穷大
        }else {
            // Animated GIF
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source!, i, nil), let gifinfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary else {
                return nil
            }
            gifDuration += frameDuration(from: gifinfo)
        }
        images.append(UIImage.init(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up))
    }
    return (images, gifDuration)
}

