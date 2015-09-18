//
//  MMTweenAnimation.swift
//  MMTweenAnimation-Swift
//
//  Created by techset on 15/9/10.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import UIKit
import pop

typealias MMTweenAnimationBlock = (time: CFTimeInterval, duration: CFTimeInterval, values: [CGFloat], target: AnyObject, animation: MMTweenAnimation) -> Void

class MMTweenAnimation: POPCustomAnimation {
    
    var animationBlock: MMTweenAnimationBlock?          // 动画回调
    var fromValue: [CGFloat]?                           // 起点数组
    var toValue: [CGFloat]?                             // 终点数组
    var duration: Double = 0.3                          // 动画时长
    
    private var __functionBlock: MMTweenFunctionBlock?  // 动画插值算法
    var functionBlock: MMTweenFunctionBlock? {
        get {
            return __functionBlock
        }
    }
    
    private var __functionType: MMTweenFunctionType = .Bounce   // 动画插值算法类型
    var functionType: MMTweenFunctionType {
        get {
            return __functionType
        }
        
        set {
            __functionType = newValue
            let function = MMTweenFunction.sharedInstance
            __functionBlock = function.functionTable[Int(__functionType.rawValue)][Int(__easingType.rawValue)]
        }
    }
    
    private var __easingType: MMTweenEasingType = .Out          // 动画缓动类型
    var easingType: MMTweenEasingType {
        get {
            return __easingType
        }
        
        set {
            __easingType = newValue
            let function = MMTweenFunction.sharedInstance
            __functionBlock = function.functionTable[Int(__functionType.rawValue)][Int(__easingType.rawValue)]
        }
    }
    
    override init() {
        super.init()
    }
    
    class func animation() -> MMTweenAnimation? {
        
        let tweaner: MMTweenAnimation = MMTweenAnimation { (target, animation) -> Bool in

            let anim: MMTweenAnimation = animation as! MMTweenAnimation

            let t = animation.currentTime - animation.beginTime     // 当前时间与起始时间的差值
            let d = anim.duration

            assert(anim.fromValue!.count == anim.toValue!.count, "fromValue.count != toValue.count")

            if t < d {      // 确保在动画持续时间类才处理
                var values: [CGFloat] = [CGFloat]()

                for i in 0..<anim.fromValue!.count {

                    if let functionBlock = anim.functionBlock {     // 计算插值
                        values.append(CGFloat(functionBlock(t: t, b: Double(anim.fromValue![i]), c: Double(anim.toValue![i]) - Double(anim.fromValue![i]), d: d)))
                    }
                }

                if let animationBlock = anim.animationBlock {       // 动画回调，以实现绘制操作
                    animationBlock(time: t, duration: d, values: values, target: target, animation: anim)
                }
                
                return true
            } else {
                return false
            }
        }
        
        return tweaner
    }
}
