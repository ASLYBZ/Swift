//
//  MMAnimationController.swift
//  MMTweenAnimation-Swift
//
//  Created by techset on 15/9/14.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import UIKit

class MMAnimationController: UIViewController {
    
    var functionType: MMTweenFunctionType = .Back
    var easingType: MMTweenEasingType = .In
    
    private var __dummy: UIView?
    private var __ball: UIView?
    private var __anim: MMTweenAnimation?

    private var __paintView: MMPaintView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "\(MMTweenFunction.sharedInstance.functionNames[Int(self.functionType.rawValue)]) - \(MMTweenFunction.sharedInstance.easingNames[Int(self.easingType.rawValue)])"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        __paintView = MMPaintView(frame: self.view.bounds)
        __paintView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(__paintView!)
        
        __dummy = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
        __dummy!.layer.cornerRadius = 15.0
        __dummy!.backgroundColor = UIColor.darkGrayColor()
        __dummy!.center = CGPoint(x: CGRectGetMaxX(UIScreen.mainScreen().bounds) - 50.0, y: 150.0)
        
        let centerMark: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0))
        centerMark.backgroundColor = UIColor.redColor()
        centerMark.layer.cornerRadius = 5.0
        centerMark.center = CGPoint(x: 15.0, y: 15.0)
        
        __dummy!.addSubview(centerMark)
        __paintView!.addSubview(__dummy!)
        
        __ball = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0))
        __ball!.layer.cornerRadius = 5.0
        __ball!.backgroundColor = UIColor.redColor()
        __ball!.center = CGPoint(x: CGRectGetMinX(UIScreen.mainScreen().bounds) + 50.0, y: 150.0)
        
        __paintView!.addSubview(__ball!)
        
        __anim = MMTweenAnimation.animation()
        __anim!.functionType = functionType
        __anim!.easingType = easingType
        __anim!.duration = 2.0
        __anim!.fromValue = [ __dummy!.center.y ]
        __anim!.toValue = [ __dummy!.center.y + CGFloat(200.0) ]
        __anim!.animationBlock = { [unowned self] (diff: CFTimeInterval, duration: CFTimeInterval, values: [CGFloat], target: AnyObject, animation: MMTweenAnimation) -> Void in
            let value: CGFloat = values[0]          // 获取当前时间结束点的值
            
            self.__dummy!.center = CGPoint(x: self.__dummy!.center.x, y: value)     // 计算小红点的中心位置
            self.__ball!.center = CGPoint(x: 50.0 + (CGRectGetWidth(UIScreen.mainScreen().bounds) - 150.0) * CGFloat(diff / duration), y: value)
            
            self.__paintView!.addDot(self.__ball!.center)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        __paintView!.clearPaint()
        __dummy!.pop_addAnimation(__anim, forKey: "center")
    }
    
    deinit {
        __dummy!.pop_removeAllAnimations()
    }
}
