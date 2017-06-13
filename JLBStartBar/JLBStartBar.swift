//
//  JLBStartBar.swift
//  Mentoring
//
//  Created by andehang on 2017/4/28.
//  Copyright © 2017年 zhouke. All rights reserved.
//

import UIKit

fileprivate let countOfStarts:NSInteger = 5
fileprivate let defaultStartSize:CGSize = CGSize(width: 21, height: 21)
fileprivate let defaultPadding:CGFloat = 10

//是否开启隐式动画
fileprivate let isAnimatable = true

//MARK:- 代理
protocol JLBStartBarDelegate
{
    /// 计算星数
    ///
    /// - Parameters:
    ///   - count: 整数位
    ///   - half: 小数位
    func score(count:NSInteger,half:NSInteger)
}

//MARK:- 评星工具条
class JLBStartBar: UIView {
    
    var delegate:JLBStartBarDelegate?

    @IBInspectable var grayStartImage:UIImage?
    {
        willSet
        {
            for startView in startViews
            {
                startView.grayStartImage = newValue
            }
        }
    }
    @IBInspectable var highLightedStartImage:UIImage?
    {
        willSet
        {
            for startView in startViews
            {
                startView.highLightedStartImage = newValue
            }
        }
    }

    
    lazy var startViews:Array = Array<JLBStartView>()
    @IBInspectable var score:CGFloat = 5.0
        {
        willSet{
            let scoreInt:NSInteger = NSInteger(newValue * 10)
            let count = NSInteger(scoreInt / 10)
            let half = NSInteger(scoreInt % 10)
            score(count: count, half: half)
        }
    }
    
    
    @IBInspectable var startSize:CGSize = defaultStartSize
    @IBInspectable var padding:CGFloat = defaultPadding
    
    fileprivate override init(frame: CGRect)
    {
        super.init(frame: frame)
        setUpStartBarUI()
    }
    
    fileprivate init(){super.init(frame:CGRect.zero)}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpStartBarUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpFrame()
    }
    
    /// 工厂方法
    ///
    /// - Parameters:
    ///   - x: 控件x
    ///   - y: 控件y
    ///   - startSize: 星大小
    ///   - padding: 星之间的间距
    /// - Returns: 评星控件
    public class func startBar(x:CGFloat,
                               y:CGFloat,
                               startSize:CGSize = defaultStartSize,
                               padding:CGFloat = defaultPadding,grayStartImage:UIImage?,highLightedStartImage:UIImage?)->JLBStartBar
    {
        let height:CGFloat = startSize.height
        let width:CGFloat = CGFloat(countOfStarts) * startSize.width + CGFloat(countOfStarts - 1) * padding
        
        let _startBar:JLBStartBar = JLBStartBar(frame: CGRect(x: x, y: y, width: width, height: height))
        _startBar.grayStartImage = grayStartImage
        _startBar.highLightedStartImage  = highLightedStartImage
        
        return _startBar
    }
}

//MARK: UI搭建
extension JLBStartBar
{
    /// 初始化UI
    fileprivate func setUpStartBarUI()
    {
        isUserInteractionEnabled = false
        
        var i:NSInteger = 1
        
        for _ in 0..<countOfStarts
        {
            let startImageView:JLBStartView = JLBStartView(frame: CGRect.zero)
            startViews.append(startImageView)
            startImageView.isUserInteractionEnabled = true
            startImageView.tag = i
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(click(tap:)))
            startImageView.addGestureRecognizer(tap)
            addSubview(startImageView)
            i += 1
        }
    }

    /// 设置子控件的frame
    fileprivate func setUpFrame()
    {
        let startImageViewH:CGFloat = startSize.height
        let startImageViewW:CGFloat = startSize.width
        let startImageViewY:CGFloat = 0
        var startImageViewX:CGFloat = 0
        var i:CGFloat = 0
        
        for startImageView in startViews
        {
            startImageViewX = (padding + startImageViewW) * i
            startImageView.frame = CGRect(x: startImageViewX, y: startImageViewY, width: startImageViewW, height: startImageViewH)
            i += 1
        }
    }
}

//MARK: 逻辑处理
extension JLBStartBar
{
    /// 根据浮点数计算星数
    ///
    /// - Parameters:
    ///   - count: 整数位
    ///   - half: 小数位
    fileprivate func score(count:NSInteger,half:NSInteger)
    {
        if let delegate = delegate
        {
            delegate.score(count: count, half: half)
            return
        }
        
        let count = count
        let half = half
        
        var i:NSInteger = 0
        
        for startImageView in startViews {
            if i < count
            {
                startImageView.ratio = 1
            }
            else if i == count
            {
                startImageView.ratio = CGFloat(half) / 10.0
            }
            else
            {
                startImageView.ratio = 0
            }
            i += 1
        }
    }
    
    /// 四舍五入计算星数
    ///
    /// - Parameters:
    ///   - count: 整数位
    ///   - half: 小数位
    fileprivate func scoreHalfadjust(count:NSInteger,half:NSInteger)
    {
        var count = count
        let half = half
        
         if  half >= 5
         {
            count += 1
         }
        
        var i:NSInteger = 0
        
        for startImageView in startViews
        {
            startImageView.ratio = i < count ? 1 : 0
            i += 1
        }
    }

    /// 大于等于0.3算半星 大于等于0.5算一星
    ///
    /// - Parameters:
    ///   - count: 整数位
    ///   - half: 小数位
    fileprivate func scoreThreeHalfadjust(count:NSInteger,half:NSInteger)
    {
        var count = count
        var half = half
        
        if  half >= 3
        {
            half += 1
        }
        
        if  count >= 5
        {
            count += 1
        }
        score(count: count, half: half)
    }
    
    @objc fileprivate func click(tap:UITapGestureRecognizer)
    {
        if let startImageView = tap.view {
            score = CGFloat(startImageView.tag)
        }
    }
}

//MARK:- 星控件
class JLBStartView: UIView
{
    var ratio:CGFloat = 1
    {
        didSet
        {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    @IBInspectable var grayStartImage:UIImage?
    {
        willSet
        {
            guard newValue != nil else {return}
            grayStartLayer.contents = newValue?.cgImage
        }
    }
    @IBInspectable var highLightedStartImage:UIImage?
    {
        willSet
        {
            guard newValue != nil else {return}
            highLightedStartLayer.contents = newValue?.cgImage
        }
    }
    
    lazy var grayStartImageView:UIImageView = {
        let _grayStartImageView = UIImageView()
        _grayStartImageView.contentMode = .right
        _grayStartImageView.clipsToBounds = true
        return _grayStartImageView
    }()
    
    lazy var highLightedStartImageView:UIImageView = {
        let _highLightedStartImageView = UIImageView()
        _highLightedStartImageView.contentMode = .left
        _highLightedStartImageView.clipsToBounds = true
        return _highLightedStartImageView
    }()
    
    lazy var grayStartLayer:CALayer = {
        let _grayStartLayer = CALayer()
        _grayStartLayer.contentsGravity = kCAGravityCenter
        _grayStartLayer.contentsScale = UIScreen.main.scale
        return _grayStartLayer
    }()
    
    lazy var highLightedStartLayer:CALayer = {
        let _highLightedStartLayer = CALayer()
        _highLightedStartLayer.contentsGravity = kCAGravityCenter
        _highLightedStartLayer.contentsScale = UIScreen.main.scale
        return _highLightedStartLayer
    }()
    
    
    /// 工厂方法创建🌟组建
    ///
    /// - Parameters:
    ///   - grayStartImage: 灰色的星图片
    ///   - highLightedStartImage: 点亮的星图片
    /// - Returns: 🌟组建
    class func startView(grayStartImage:UIImage?,highLightedStartImage:UIImage?)->JLBStartView
    {
        let startView = JLBStartView(frame: CGRect.zero)
        startView.grayStartLayer.contents = grayStartImage?.cgImage
        startView.highLightedStartLayer.contents = highLightedStartImage?.cgImage
        return startView
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        layer.addSublayer(grayStartLayer)
        layer.addSublayer(highLightedStartLayer)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        layer.addSublayer(grayStartLayer)
        layer.addSublayer(highLightedStartLayer)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if !isAnimatable
        {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
        }
        
        var grayStartLayerFrame = bounds
        var highLightedStartLayerFrame = bounds
        let width = bounds.size.width
        
        highLightedStartLayerFrame.size.width = width * ratio
        grayStartLayerFrame.origin.x = width * ratio
        grayStartLayerFrame.size.width = width * (1 - ratio)
        
        grayStartLayer.frame = grayStartLayerFrame
        highLightedStartLayer.frame = highLightedStartLayerFrame
        
        grayStartLayer.contentsRect = CGRect(x: ratio, y: 0, width: 1 - ratio, height: 1)
        highLightedStartLayer.contentsRect = CGRect(x: 0, y: 0, width: ratio, height: 1)
        
        if !isAnimatable
        {
            CATransaction.commit()
        }
    }
}
