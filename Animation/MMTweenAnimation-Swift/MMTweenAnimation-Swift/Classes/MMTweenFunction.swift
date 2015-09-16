//
//  MMTweenFunction.swift
//  MMTweenAnimation-Swift
//
//  Created by techset on 15/9/9.
//  Copyright (c) 2015年 iosdev. All rights reserved.
//

import Foundation

enum MMTweenEasingType: UInt {
    case In         = 0
    case Out        = 1
    case InOut      = 2
    case Max        = 3
}

enum MMTweenFunctionType: UInt {
    case Back       = 0
    case Bounce     = 1
    case Circ       = 2
    case Cubic      = 3
    case Elastic    = 4
    case Expo       = 5
    case Quad       = 6
    case Quard      = 7
    case Quint      = 8
    case Sine       = 9
    case Max        = 10
}

typealias MMTweenFunctionBlock = (t: CFTimeInterval,                // time
                                  b: Double,                        // begining
                                  c: Double,                        // change
                                  d: CFTimeInterval) -> Double      // duration

private let instance = MMTweenFunction()

/*
 *
 */
class MMTweenFunction: NSObject {
    
    private var __functionTable: [ [ MMTweenFunctionBlock ] ]
    var functionTable: [ [MMTweenFunctionBlock] ] {
        get {
            return __functionTable
        }
    }
    
    private var __functionNames: [ String ]
    var functionNames: [ String ] {
        get {
            return __functionNames
        }
    }
    
    private var __easingNames: [ String ]
    var easingNames: [ String ] {
        get {
            return __easingNames
        }
    }
    
    class var sharedInstance: MMTweenFunction {
        return instance
    }
    
    class func blockWithFunctionType(functionType: MMTweenFunctionType, easingType: MMTweenEasingType) -> MMTweenFunctionBlock? {
        return nil
    }
    
    // MARK: Life Cycle
    override init() {
        __functionTable = [[MMTweenFunctionBlock]]()
        
        __functionNames = ["Back",
                           "Bounce",
                           "Circ",
                           "Cubic",
                           "Elastic",
                           "Expo",
                           "Quad",
                           "Quard",
                           "Quint",
                           "Sine"]
        
        __easingNames = ["EaseIn",
                         "EaseOut",
                         "EaseInOut"]
        
        super.init()
        
        setupBlocks()
    }
    
    // MARK: Private Methods
    private func setupBlocks() {
        
        // Back
        let backIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let s: Double = 1.70158
            let t1 = t / d
            return c * t1 * t1 * ((s + 1) * t1 - s) + b
        }
        
        let backOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let s: Double = 1.70158
            let t1 = t / d - 1
            return c * (t1 * t1 * ((s + 1) * t1 + s) + 1) + b
        }
        
        let backInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let s: Double = 1.70158
            let k: Double = 1.525
            var t1 = t / (d / 2)
            let s1 = s * k
            if t1 < 1 {
                return c / 2 * (t1 * t1 * ((s1 + 1) * t1 - s1)) + b
            } else {
                t1 -= 2
                return c / 2 * (t1 * t1 * ((s1 + 1) * t1 + s1) + 2) + b
            }
        }
        
        __functionTable.append([ backIn, backOut, backInOut ])
        
        // Bounce
        let bounceOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let k: Double = 2.75
            var t1 = t / d
            if t1 < (1 / k) {
                return c * (7.5625 * t1 * t1) + b
            } else if t1 < (2 / k) {
                t1 -= 1.5 / k
                return c * (7.5625 * t1 * t1 + 0.75) + b
            } else if t1 < (2.5 / k) {
                t1 -= 2.25 / k
                return c * (7.5625 * t1 * t1 + 0.9375) + b
            } else {
                t1 -= 2.625 / k
                return c * (7.5625 * t1 * t1 + 0.984375) + b
            }
        }
        
        let bounceIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            return c - bounceOut(t: d - t, b: 0, c: c, d: d) + b
        }
        
        let bounceInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            if t < (d * 0.5) {
                return bounceIn(t: t * 2, b: 0, c: c, d: d) * 0.5 + b
            } else {
                return bounceOut(t: t * 2 - d, b: 0, c: c, d: d) * 0.5 + c * 0.5 + b
            }
        }
        
        __functionTable.append([ bounceIn, bounceOut, bounceInOut ])
        
        // Circ
        let circIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d
            return -c * (sqrt(1 - t1 * t1) - 1) + b
        }
        
        let circOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d - 1
            return c * sqrt(1 - t1 * t1) + b
        }
        
        let circInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            var t1 = t / (d / 2)
            if t1 <= 1 {
                return -c / 2 * (sqrt(1 - t1 * t1) - 1) + b
            } else {
                t1 -= 2
                return c / 2 * (sqrt(1 - t1 * t1) + 1) + b
            }
        }
        
        __functionTable.append([ circIn, circOut, circInOut ])
        
        // Cubic
        let cubicIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d
            return c * t1 * t1 * t1 + b
        }
        
        let cubicOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d - 1
            return c * (t1 * t1 * t1 + 1) + b
        }
        
        let cubicInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            var t1 = t / (d / 2)
            if t < 1 {
                return c / 2 * t1 * t1 * t1 + b
            }
            
            t1 -= 2
            return c / 2 * (t1 * t1 * t1 + 2) + b
        }
        
        __functionTable.append([ cubicIn, cubicOut, cubicInOut ])
        
        // Elastic
        let elasticIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            var s: Double = 1.70158
            var p: Double = 0
            var a: Double = c
            
            if t == 0 {
                return b
            }
            
            var t1 = t / d
            
            if t1 == 1 {
                return b + c
            }
            
            if p == 0 {
                p = d * 0.3
            }
            
            if a < fabs(c) {
                a = c
                s = p / 4
            } else {
                s = p / (2 * 3.1419) * asin(c / a)
            }
            
            t1--
            
            return -(a * pow(2, 10 * t1) * sin((t1 * d - s) * (2 * 3.1419) / p)) + b
        }

        let elasticOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            var s: Double = 1.70158
            var p: Double = 0
            var a: Double = c
            
            if t == 0 {
                return b
            }
            
            let t1 = t / d
            if t1 == 1 {
                return b + c
            }
            
            if p == 0 {
                p = d * 0.3
            }
            
            if a < fabs(c) {
                a = c
                s = p / 4
            } else {
                s = p / (2 * 3.1419) * asin(c / a)
            }
            
            return a * pow(2, -10 * t1) * sin((t1 * d - s) * (2 * 3.1419) / p) + c + b
        }

        let elasticInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            var s: Double = 1.70158
            var p: Double = 0
            var a: Double = c
            
            if t == 0 {
                return b
            }
            
            var t1 = t / (d / 2)
            if t1 == 2 {
                return b + c
            }
            
            if p == 0 {
                p = d * (0.3 * 1.5)
            }
            
            if a < fabs(c) {
                a = c
                s = p / 4
            } else {
                s = p / (2 * 3.1419) * asin(c / a)
            }
            
            if t1 < 1 {
                t1--
                return -0.5 * (a * pow(2, 10 * t1) * sin((t1 * d - s) * (2 * 3.1419) / p)) + b
            }
            
            t1--
            return a * pow(2, -10 * t1) * sin((t1 * d - s) * (2 * 3.1419) / p) * 0.5 + c + b;
        }
        
        __functionTable.append([ elasticIn, elasticOut, elasticInOut ])
        
        // Expo
        let expoIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            return (t == 0) ? b : c * pow(2, 10 * (t / d - 1)) + b
        }
        
        let expoOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            return (t == d) ? b + c : c * (-pow(2, -10 * t / d) + 1) + b
        }
        
        let expoInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            if t == 0 {
                return b
            } else if t == d {
                return b + c
            }
            
            var t1 = t / (d / 2)
            
            if t1 < 1 {
                return c / 2 * pow(2, 10 * (t1 - 1)) + b;
            } else {
                return c / 2 * (-pow(2, -10 * --t1) + 2) + b;
            }
        }
        
        __functionTable.append([ expoIn, expoOut, expoInOut ])
        
        // Quad
        let quadIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d
            return c * t1 * t1 + b
        }
        
        let quadOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d
            return -c * t1 * (t1 - 2) + b
        }
        
        let quadInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            
            var t1 = t / (d / 2)
            if t1 < 1 {
                return c / 2 * t1 * t1 + b;
            }
            
            t1--
            
            return -c / 2 * (t1 * (t1 - 2) - 1) + b
        }
        
        __functionTable.append([ quadIn, quadOut, quadInOut ])
        
        // Quart
        let quartIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d
            return c * t1 * t1 * t1 * t1 + b
        }
        
        let quartOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d - 1
            return -c * (t1 * t1 * t1 * t1 - 1) + b
        }
        
        let quartInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            var t1 = t / (d / 2)
            if t1 < 1 {
                return c / 2 * t1 * t1 * t1 * t1 + b
            }
            
            t1 -= 2
            return -c / 2 * (t1 * t1 * t1 * t1 - 2) + b
        }
        
        __functionTable.append([ quartIn, quartOut, quartInOut ])
        
        // Quint
        let quintIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d
            return c * t1 * t1 * t1 * t1 * t1 + b
        }
        
        let quintOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            let t1 = t / d - 1
            return c * (t1 * t1 * t1 * t1 * t1 + 1) + b
        }
        
        let quintInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            var t1 = t / (d / 2)
            if t1 < 1 {
                return c / 2 * t1 * t1 * t1 * t1 * t1 + b;
            }
            
            t1 -= 2
            return c / 2 * (t1 * t1 * t1 * t1 * t1 + 2) + b
        }
        
        __functionTable.append([ quintIn, quintOut, quintInOut ])
        
        // Sine
        let sineIn: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            return -c * cos(t / d * (M_PI / 2)) + c + b
        }
        
        let sineOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            return c * sin(t / d * (M_PI / 2)) + b
        }
        
        let sineInOut: MMTweenFunctionBlock = { (t, b, c, d) -> Double in
            return -c / 2 * (cos(M_PI * t / d) - 1) + b;
        }
        
        __functionTable.append([ sineIn, sineOut, sineInOut ])
    }
}
