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
    
    var animationBlock: MMTweenAnimationBlock?
    var fromValue: [CGFloat]?
    var toValue: [CGFloat]?
    var duration: Double = 0.3
    
    private var __functionBlock: MMTweenFunctionBlock?
    var functionBlock: MMTweenFunctionBlock? {
        get {
            return __functionBlock
        }
    }
    
    private var __functionType: MMTweenFunctionType = .Bounce
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
    
    private var __easingType: MMTweenEasingType = .Out
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

            let t = animation.currentTime - animation.beginTime
            let d = anim.duration

            assert(anim.fromValue!.count == anim.toValue!.count, "fromValue.count != toValue.count")

            if t < d {
                var values: [CGFloat] = [CGFloat]()

                for i in 0..<anim.fromValue!.count {

                    if let functionBlock = anim.functionBlock {
                        values.append(CGFloat(functionBlock(t: t, b: Double(anim.fromValue![i]), c: Double(anim.toValue![i]) - Double(anim.fromValue![i]), d: d)))
                    }
                }

                if let animationBlock = anim.animationBlock {
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
