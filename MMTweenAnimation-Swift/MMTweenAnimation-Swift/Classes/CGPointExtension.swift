//
//  CGPointExtension.swift
//  MMTweenAnimation-Swift
//
//  Created by techset on 15/9/10.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import Foundation
import UIKit

// Creates a CGPoint
func ccp(x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

// Returns opposite of point.
func ccpNeg(v: CGPoint) -> CGPoint {
    return ccp(-v.x, -v.y)
}

// Calculates sum of two points.
func ccpAdd(v1 v1: CGPoint, v2: CGPoint) -> CGPoint {
    return ccp(v1.x + v2.x, v1.y + v2.y)
}

// Calculates difference of two points.
func ccpSub(v1 v1: CGPoint, v2: CGPoint) -> CGPoint {
    return ccp(v1.x - v2.x, v1.y - v2.y)
}

// Returns point multiplied by given factor.
func ccpMult(v v: CGPoint, s: CGFloat) -> CGPoint {
    return ccp(v.x * s, v.y * s)
}

// Calculates midpoint between two points.
func ccpMidpoint(v1 v1: CGPoint, v2: CGPoint) -> CGPoint {
    return ccpMult(v: ccpAdd(v1: v1, v2: v2), s: 0.5)
}

// Calculates dot product of two points.
func ccpDot(v1 v1: CGPoint, v2: CGPoint) -> CGFloat {
    return v1.x * v2.x + v1.y * v2.y
}

// Calculates cross product of two points.
func ccpCross(v1 v1: CGPoint, v2: CGPoint) -> CGFloat {
    return v1.x * v2.y - v1.y * v2.x
}

// Calculates perpendicular of v, rotated 90 degrees counter-clockwise -- cross(v, perp(v)) >= 0
func ccpPerp(v: CGPoint) -> CGPoint {
    return ccp(-v.y, v.x)
}

// Calculates perpendicular of v, rotated 90 degrees clockwise -- cross(v, rperp(v)) <= 0
func ccpRPerp(v: CGPoint) -> CGPoint {
    return ccp(v.y, -v.x)
}

// Calculates the projection of v1 over v2.
func ccpProject(v1 v1: CGPoint, v2: CGPoint) -> CGPoint {
    return ccpMult(v: v2, s: ccpDot(v1: v1, v2: v2) / ccpDot(v1: v2, v2: v1))
}

// Rotates two points.
func ccpRotate(v1 v1: CGPoint, v2: CGPoint) -> CGPoint {
    return ccp(v1.x * v2.x - v1.y * v2.y, v1.x * v2.y + v1.y * v2.x)
}

// Unrotates two points.
func ccpUnrotate(v1 v1: CGPoint, v2: CGPoint) -> CGPoint {
    return ccp(v1.x * v2.x + v1.y * v2.y, v1.y * v2.x - v1.x * v2.y)
}

// Calculates the square length of a CGPoint (not calling sqrt() )
func ccpLengthSQ(v: CGPoint) -> CGFloat {
    return ccpDot(v1: v, v2: v)
}

// Calculates the square distance between two points (not calling sqrt() )
func ccpDistanceSQ(p1 p1: CGPoint, p2: CGPoint) -> CGFloat {
    return ccpLengthSQ(ccpSub(v1: p1, v2: p2))
}

// Calculates distance between point an origin
func ccpLength(v: CGPoint) -> CGFloat {
    return sqrt(ccpLengthSQ(v))
}

// Calculates the distance between two points
func ccpDistance(v1 v1: CGPoint, v2: CGPoint) -> CGFloat {
    return ccpLength(ccpSub(v1: v1, v2: v2))
}

// Returns point multiplied to a length of 1.
func ccpNormalize(v: CGPoint) -> CGPoint {
    return ccpMult(v: v, s: 1.0 / ccpLength(v))
}

// Converts radians to a normalized vector.
func ccpForAngle(a: CGFloat) -> CGPoint {
    return ccp(cos(a), sin(a))
}

// Converts a vector to radians.
func ccpToAngle(v: CGPoint) -> CGFloat {
    return atan2(v.y, v.x)
}

// Clamp a value between from and to.
func clampf(value value: CGFloat, var minInclusive: CGFloat, var maxInclusive: CGFloat) -> CGFloat {
    if minInclusive > maxInclusive {
        let tmp = minInclusive
        minInclusive = maxInclusive
        maxInclusive = tmp
    }
    return value < minInclusive ? minInclusive : (value < maxInclusive ? value : maxInclusive)
}

// Clamp a point between from and to.
func ccpClamp(p: CGPoint, from: CGPoint, to: CGPoint) -> CGPoint {
    return ccp(clampf(value: p.x, minInclusive: from.x, maxInclusive: to.x), clampf(value: p.y, minInclusive: from.y, maxInclusive: to.y))
}

// Quickly convert CGSize to a CGPoint
func ccpFromSize(s: CGSize) -> CGPoint {
    return ccp(s.width, s.height)
}

/* 
 * Run a math operation function on each point component
 * absf, fllorf, ceilf, roundf
 * any function that has the signature: float func(float);
 * For example: let's try to take the floor of x,y
 * ccpCompOp(p,floorf);
 */
func ccpCompOp(p p: CGPoint, opBlock: (CGFloat) -> CGFloat) -> CGPoint {
    return ccp(opBlock(p.x), opBlock(p.y))
}

// Linear Interpolation between two points a and b
func ccpLerp(a a: CGPoint, b: CGPoint, alpha: CGFloat) -> CGPoint {
    return ccpAdd(v1: ccpMult(v: a, s: 1.0 - alpha), v2: ccpMult(v: b, s: alpha))
}

// if points have fuzzy equality which means equal with some degree of variance.
func ccpFuzzyEqual(a a: CGPoint, b: CGPoint, value: CGFloat) -> Bool {
    if a.x - value <= b.x && b.x <= a.x + value {
        if a.y - value <= b.y && b.y <= a.y + value {
            return true
        }
    }
    return false
}

// Multiplies a nd b components, a.x*b.x, a.y*b.y
func ccpCompMult(a a: CGPoint, b: CGPoint) -> CGPoint {
    return ccp(a.x * b.x, a.y * b.y)
}

let kCGPointEpsilon = FLT_EPSILON

// the signed angle in radians between two vector directions
func ccpAngleSigned(a a: CGPoint, b: CGPoint) -> CGFloat {
    let a1 = ccpNormalize(a)
    let b1 = ccpNormalize(b)
    let angle = atan2(a1.x * b1.y - a1.y * b1.x, ccpDot(v1: a1, v2: b1))
    
    if fabs(angle) < CGFloat(kCGPointEpsilon) {
        return 0.0
    }
    
    return angle
}

// the angle in radians between two vector directions
func ccpAngle(a a: CGPoint, b: CGPoint) -> CGFloat {
    let angle = acos(ccpDot(v1: ccpNormalize(a), v2: ccpNormalize(b)))
    if fabs(angle) < CGFloat(kCGPointEpsilon) {
        return 0.0
    }
    
    return angle
}

// Rotates a point counter clockwise by the angle around a pivot
func ccpRotateByAngle(v v: CGPoint, pivot: CGPoint, angle: CGFloat) -> CGPoint {
    var r = ccpSub(v1: v, v2: pivot)
    let cosa = cos(angle)
    let sina = sin(angle)
    let t = r.x
    
    r.x = t * cosa - r.y * sina + pivot.x
    r.y = t * sina + r.y * cosa + pivot.y
    
    return r
}

// A general line-line intersection test
func ccpLineIntersect(A A: CGPoint, B: CGPoint, C: CGPoint, D: CGPoint, inout S: CGFloat, inout T: CGFloat) -> Bool {
    
    // FAIL: Line undefined
    if (A.x == B.x && A.y == B.y) || (C.x == D.x && C.y == D.y) {
        return false
    }
    
    let BAx = B.x - A.x
    let BAy = B.y - A.y
    let DCx = D.x - C.x
    let DCy = D.y - C.y
    let ACx = A.x - C.x
    let ACy = A.y - C.y
    
    let denom = DCy * BAx - DCx * BAy
    
    S = DCx * ACy - DCy * ACx
    T = BAx * ACy - BAy * ACx
    
    if denom == 0 {
        if S == 0 || T == 0 {
            // Lines incident
            return true
        }
        
        // Lines parallel and not incident
        return false
    }
    
    S /= denom
    T /= denom
    
    return true
}

// ccpSegmentIntersect returns YES if Segment A-B intersects with segment C-D
func ccpSegmentIntersect(A A: CGPoint, B: CGPoint, C: CGPoint, D: CGPoint) -> Bool {
    var S: CGFloat = 0.0
    var T: CGFloat = 0.0
    
    if ccpLineIntersect(A: A, B: B, C: C, D: D, S: &S, T: &T) && (S >= 0.0 && S <= 1.0 && T >= 0.0 && T <= 1.0) {
        return true
    }
    
    return false
}

func ccpIntersectPoint(A A: CGPoint, B: CGPoint, C: CGPoint, D: CGPoint) -> CGPoint {
    var S: CGFloat = 0.0
    var T: CGFloat = 0.0
    
    if ccpLineIntersect(A: A, B: B, C: C, D: D, S: &S, T: &T) {
        // Point of intersection
        var P: CGPoint = CGPointZero
        P.x = A.x + S * (B.x - A.x)
        P.y = A.y + S * (B.y - A.y)
        return P
    }
    
    return CGPointZero
}
