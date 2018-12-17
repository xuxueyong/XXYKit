//
//  ZLaunchAdVC.swift
//  ZLaunchAdDemo
//
//  Created by mengqingzheng on 2017/4/5.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit


enum SkipButtonType {
    case none                   /// 无跳过按钮
    case timer                  /// 跳过+倒计时
    case circle                 /// 圆形跳过
}
enum SkipButtonPosition {
    case rightTop               /// 屏幕右上角
    case rightBottom            /// 屏幕右下角
    case rightAdViewBottom      /// 广告图右下角
}

enum TransitionType {
    case none
    case rippleEffect           /// 波纹
    case fade                   /// 交叉淡化
    case flipFromTop            /// 上下翻转
    case filpFromBottom
    case filpFromLeft           /// 左右翻转
    case filpFromRight
}

class ZLaunchAdVC: UIViewController {
    
    /// 默认3s
    /// ===========================
    fileprivate var defaultTime = 3
    
    /// 广告图距底部距离
    ///  ===========================
    fileprivate let bottomLogoHeight: CGFloat = 148
    
    fileprivate var transitionType: TransitionType = .fade
    
    /// 跳过按钮位置
    /// ===========================
    fileprivate var skipBtnPosition: SkipButtonPosition = .rightTop
    
    /// 跳过按钮类型
    /// ===========================
    fileprivate var skipBtnType: SkipButtonType = .timer {
        didSet {
            
            let btnWidth: CGFloat = 60
            
            let btnHeight: CGFloat = 30
            
            var y: CGFloat = 0
            
            switch skipBtnPosition {
                
            case .rightBottom:
                
                y = mainScreenHeight - 50
                
            case .rightAdViewBottom:
                
                y = mainScreenHeight - bottomLogoHeight - 50
                
            default:
                
                y = 30
                
            }
            
            let timerRect = CGRect(x: mainScreenWidth - 70, y: y, width: btnWidth, height: btnHeight)
            
            let circleRect = CGRect(x: mainScreenWidth - 50, y: y, width: btnHeight, height: btnHeight)
            
            skipBtn.frame = self.skipBtnType == .timer ? timerRect : circleRect
            
            skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: self.skipBtnType == .timer ? 13.5 : 12)
            
            skipBtn.setTitle(self.skipBtnType == .timer ? "\(self.adDuration) 跳过" : "跳过", for: .normal)
        }
    }
    
    /// 广告时间
    /// ===========================
    fileprivate var adDuration: Int = 0
    
    /// 默认定时器
    /// ===========================
    fileprivate var originalTimer: DispatchSourceTimer?
    
    /// 图片显示定时器
    /// ===========================
    fileprivate var dataTimer: DispatchSourceTimer?
    
    /// 图片点击闭包
    /// ===========================
    fileprivate var adImgViewClick: (()->())?
    
    /// 图片倒计时完成闭包
    /// ===========================
    fileprivate var completion:(()->())?
    
    /// layer
    fileprivate var animationLayer: CAShapeLayer?
    
    /// 广告图
    /// ===========================
    fileprivate lazy var launchAdImgView: UIImageView = {

        let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: mainScreenWidth, height: mainScreenHeight - self.bottomLogoHeight))
        imgView.contentMode = .scaleAspectFill
        imgView.isUserInteractionEnabled = true
        imgView.alpha = 0.2
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(launchAdTapAction(sender:)))
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    
    /// 跳过按钮
    /// ===========================
    fileprivate lazy var skipBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 点击事件
    /// 广告点击
    @objc fileprivate func launchAdTapAction(sender: UITapGestureRecognizer) {
        dataTimer?.cancel()
        launchAdVCRemove {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
                if self.adImgViewClick != nil {
                    self.adImgViewClick!()
                }
            })
        }
    }
    @objc fileprivate func skipBtnClick() {
        dataTimer?.cancel()
        launchAdVCRemove(completion: nil)
    }
    
    /// 关闭广告
    /// ==============================================================================================================================================================================================================================================================================================================================================================
    fileprivate func launchAdVCRemove(completion: (()->())?) {
        
        if self.originalTimer?.isCancelled == false {
            self.originalTimer?.cancel()
        }
        if self.dataTimer?.isCancelled == false {
            self.dataTimer?.cancel()
        }
        
        let trans = CATransition()
        trans.duration = 0.5
        switch transitionType {
            
        case .rippleEffect:
            trans.type = CATransitionType(rawValue: "rippleEffect")
        case .filpFromLeft:
            trans.type = CATransitionType(rawValue: "oglFlip")
            trans.subtype = CATransitionSubtype.fromLeft
        case .filpFromRight:
            trans.type = CATransitionType(rawValue: "oglFlip")
            trans.subtype = CATransitionSubtype.fromRight
        case .flipFromTop:
            trans.type = CATransitionType(rawValue: "oglFlip")
            trans.subtype = CATransitionSubtype.fromTop
        case .filpFromBottom:
            trans.type = CATransitionType(rawValue: "oglFlip")
            trans.subtype = CATransitionSubtype.fromBottom
        default:
            trans.type = CATransitionType(rawValue: "fade")
        }
        UIApplication.shared.keyWindow?.layer.add(trans, forKey: nil)
        
        if self.completion != nil {
            self.completion!()
            if completion != nil {

                completion!()
            }
        }
    }
    
    //MARK: - XXXXXXXX
    
    
    /// 初始化    设置默认显示时间
    ///
    /// - Parameter defaultDuration: 默认显示时间，如果不设置，默认3s
    convenience init(defaultDuration: Int = 3, completion: (()->())?) {
        self.init(nibName: nil, bundle: nil)
        if defaultDuration >= 1 {
            self.defaultTime = defaultDuration
        }
        self.completion = completion
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLogoView()
        
        startTimer()
    }
    
    func setupLogoView() {
        let logo = assetsLaunchImage()
        let logoView = UIImageView(image: logo)
        self.view.addSubview(logoView)
    }
    
    deinit {
        print("byebye")
    }
    
}

// MARK: - 参数设置

extension ZLaunchAdVC {
    
    /// 设置广告参数
    ///
    /// - Parameters:
    ///   - url: 路径
    ///   - adDuartion:             显示时间
    ///   - skipBtnType:            跳过按钮类型，默认 倒计时+跳过
    ///   - skipBtnPosition:        跳过按钮位置，默认右上角
    ///   - bottomLogoHeight:   图片距底部的距离，默认100
    ///   - transitionType:         过渡的类型，默认没有
    ///   - adImgViewClick:         点击广告回调
    ///   - completion:             完成回调
    func setAdParams(url: String, adDuartion: Int, skipBtnType: SkipButtonType = .timer, skipBtnPosition: SkipButtonPosition = .rightTop, transitionType: TransitionType = .none, adImgViewClick: (()->())?) {
        
        self.skipBtnPosition = skipBtnPosition
        self.transitionType = transitionType
        self.adDuration = adDuartion
        self.skipBtnType = skipBtnType
        if AATAccountManager.shared.isGuest() {
            self.skipBtnType = .none
        }
        if adDuration < 1 {
            self.adDuration = 1
        }
        
        if url != "" {
            view.addSubview(launchAdImgView)
            view.backgroundColor = UIColor.white

            self.launchAdImgView.kf.setImage(with: URL(string: url)) { (_, _, _, _) in
                /// 如果带缓存，并且需要改变按钮状态
                self.skipBtn.removeFromSuperview()
                if self.animationLayer != nil {
                    self.animationLayer?.removeFromSuperlayer()
                    self.animationLayer = nil
                }
                
                if self.skipBtnType != .none {
                    self.view.addSubview(self.skipBtn)
                    if self.skipBtnType == .circle {
                        self.addLayer()
                    }
                }
                
                if self.originalTimer?.isCancelled == true {
                    return
                }
                
                self.adStartTimer()
                
                UIView.animate(withDuration: 0.8, animations: {
                    self.launchAdImgView.alpha = 1
                })
            }
        }
        self.adImgViewClick = adImgViewClick
    }
    
    /// 添加动画
    fileprivate func addLayer() {
        let bezierPath = UIBezierPath.init(ovalIn: skipBtn.bounds)
        animationLayer = CAShapeLayer()
        animationLayer?.path = bezierPath.cgPath
        animationLayer?.lineWidth = 2
        animationLayer?.strokeColor = UIColor.red.cgColor
        animationLayer?.fillColor = UIColor.clear.cgColor
        let animation = CABasicAnimation.init(keyPath: "strokeStart")
        animation.duration = Double(adDuration)
        animation.fromValue = 0
        animation.toValue = 1
        animationLayer?.add(animation, forKey: nil)
        skipBtn.layer.addSublayer(animationLayer!)
    }
}

//MARK: - GCD定时器
/// APP启动后开始默认定时器，默认3s
/// 3s内若网络图片加载完成，默认定时器关闭，开启图片倒计时
/// 3s内若图片加载未完成，执行completion闭包
/// =============================================================================================================================================================================================================================================

extension ZLaunchAdVC {
    
    /// 默认定时器
    fileprivate func startTimer() {
        
        originalTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        
        originalTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(defaultTime))
        
        originalTimer?.setEventHandler(handler: {
            
            if self.defaultTime == 0 {
                
                DispatchQueue.main.async {
                    self.launchAdVCRemove(completion: nil)
                }
                
            }
            self.defaultTime -= 1
        })
        
        originalTimer?.resume()
    }
    
    /// 图片倒计时
    fileprivate func adStartTimer() {
        
        if self.originalTimer?.isCancelled == false {
            self.originalTimer?.cancel()
        }
        
        dataTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        
        dataTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(adDuration))
        
        dataTimer?.setEventHandler(handler: {
            DispatchQueue.main.async(execute: {
                self.skipBtn.setTitle(self.skipBtnType == .timer ? "\(self.adDuration) 跳过" : "跳过", for: .normal)
            })
            
            
            if self.adDuration == 0 {
                
                
                DispatchQueue.main.async {
                    self.launchAdVCRemove(completion: nil)
                }
                
            }
            
            self.adDuration -= 1
            
        })
        dataTimer?.resume()
    }
}

// MARK: - 状态栏相关
/// 状态栏显示、颜色与General -> Deployment Info中设置一致
extension ZLaunchAdVC {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

// MARK: - 获取启动页图片
extension ZLaunchAdVC {
    
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
    
}



