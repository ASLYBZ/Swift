//
//  MMPaintView.swift
//  MMTweenAnimation-Swift
//
//  Created by techset on 15/9/12.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import UIKit

class MMPaintView: UIView {
    
    private var __path: UIBezierPath?
    private var __dots: [ CGPoint ]
    
    private var controlPoint1: CGPoint?
    private var controlPoint2: CGPoint?
    
    override init(frame: CGRect) {
        
        __dots = [ CGPoint ]()
        
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func clearPaint() {
        __dots.removeAll()
//        __path = __interpolateCGPointsWithHermite(__dots)
        __path = __interpolateCGPointsWithCatmullRom(__dots)
        setNeedsDisplay()
    }
    
    func addDot(point: CGPoint) {
        __dots.append(point)
//        __path = __interpolateCGPointsWithHermite(__dots)
        __path = __interpolateCGPointsWithCatmullRom(__dots)
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        __path?.stroke()
    }
    
    // MARK: Private Methods
    private func __interpolateCGPointsWithCatmullRom(points: [CGPoint]) -> UIBezierPath? {
        
//        print("================================================================================")
//        print("【point count : \(points.count)】")
//        print("\(points)")
        
        if points.count < 4 {
            return nil
        }
        
        let closed = false
        let alpha: CGFloat = 1.0
        
        let endIndex = points.count - 2
        
        let path: UIBezierPath = UIBezierPath()
        let startIndex = closed ? 0 : 1
        path.lineWidth = 1.0
        for i in startIndex..<endIndex {
            
            let nextii = (i + 1) % points.count
            let nextnextii = (nextii + 1) % points.count
            let previi = i - 1 < 0 ? points.count - 1 : i - 1
            
            let p1: CGPoint = points[i]
            let p0: CGPoint = points[previi]
            let p2: CGPoint = points[nextii]
            let p3: CGPoint = points[nextnextii]
            
            let d1 = ccpLength(ccpSub(v1: p1, v2: p0))
            let d2 = ccpLength(ccpSub(v1: p2, v2: p1))
            let d3 = ccpLength(ccpSub(v1: p3, v2: p2))
            
            var b1 = ccpMult(v: p2, s: pow(d1, 2 * alpha))
            b1 = ccpSub(v1: b1, v2: ccpMult(v: p0, s: pow(d2, 2 * alpha)))
            b1 = ccpAdd(v1: b1, v2: ccpMult(v: p1, s: (2 * pow(d1, 2 * alpha) + 3 * pow(d1, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha))))
            b1 = ccpMult(v: b1, s: 1.0 / (3 * pow(d1, alpha) * (pow(d1, alpha) + pow(d2, alpha))))
            
            var b2 = ccpMult(v: p1, s: pow(d3, 2 * alpha))
            b2 = ccpSub(v1: b2, v2: ccpMult(v: p3, s: pow(d2, 2 * alpha)))
            b2 = ccpAdd(v1: b2, v2: ccpMult(v: p2, s: (2 * pow(d3, 2 * alpha) + 3 * pow(d3, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha))))
            b2 = ccpMult(v: b2, s: 1.0 / (3 * pow(d3, alpha) * (pow(d3, alpha) + pow(d2, alpha))))
            
            if i == startIndex {
                path.moveToPoint(p1)
            }
            
            path.addCurveToPoint(p2, controlPoint1: b1, controlPoint2: b2)
        }
        
        return path
    }
    
    private func __interpolateCGPointsWithHermite(points: [CGPoint]) -> UIBezierPath? {
        if points.count < 2 {
            return nil
        }
        
        let closed = false
        
        let countOfCurves = points.count - 1
        
        let path: UIBezierPath = UIBezierPath()
        path.lineWidth = 1.0
        for i in 0..<countOfCurves {
            
            var curPt = points[i]
            
            if i == 0 {
                path.moveToPoint(curPt)
            }
            
            var nextii = (i + 1) % points.count
            var previi = i - 1 < 0 ? points.count - 1 : i - 1
            
            var prevPt = points[previi]
            var nextPt = points[nextii]
            let endPt = nextPt
            
            var mx: CGFloat
            var my: CGFloat
            if closed || i > 0 {
                mx = (nextPt.x - curPt.x) * 0.5 + (curPt.x - prevPt.x) * 0.5
                my = (nextPt.y - curPt.y) * 0.5 + (curPt.y - prevPt.y) * 0.5
            } else {
                mx = (nextPt.x - curPt.x) * 0.5
                my = (nextPt.y - curPt.y) * 0.5
            }
            
            let ctrlPt1: CGPoint = CGPoint(x: curPt.x + mx / 3.0, y: curPt.y + my / 3.0)
            
            curPt = points[nextii]
            
            nextii = (nextii + 1) % points.count
            previi = i
            
            prevPt = points[previi]
            nextPt = points[nextii]
            
            if closed || i < countOfCurves - 1 {
                mx = (nextPt.x - curPt.x) * 0.5 + (curPt.x - prevPt.x) * 0.5
                my = (nextPt.y - curPt.y) * 0.5 + (curPt.y - prevPt.y) * 0.5
            } else {
                mx = (curPt.x - prevPt.x) * 0.5
                my = (curPt.y - prevPt.y) * 0.5
            }
            
            let ctrlPt2: CGPoint = CGPoint(x: curPt.x - mx / 3.0, y: curPt.y - my / 3.0)
            
            path.addCurveToPoint(endPt, controlPoint1: ctrlPt1, controlPoint2: ctrlPt2)
        }
        
        if closed {
            path.closePath()
        }
        
        return path
    }
}
