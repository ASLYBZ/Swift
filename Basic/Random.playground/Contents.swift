//: # Swift 随机数

import UIKit

//: ## arc4random

arc4random()
arc4random()
arc4random() % 10

//: ## rand

srand(UInt32(time(nil)))            // 种子

rand()
rand() % 10

RAND_MAX

//: ## random

srandom(UInt32(time(nil)))
random()
random() % 10
//: ## arc4random_uniform
arc4random_uniform(10)
let max: UInt32 = 100
let min: UInt32 = 5
arc4random_uniform(max - min) + 3
//: ## UInt64/Int64 random
func arc4random1 <T: IntegerLiteralConvertible> (type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, Int(sizeof(T)))
    return r
}

sizeof(UInt64)
sizeof(UInt32)

extension UInt64 {
    static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
        var m: UInt64
        let u = upper - lower
        var r = arc4random1(UInt64)
        
        if u > UInt64(Int64.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        
        while r < m {
            r = arc4random1(UInt64)
        }
        
        return (r % u) + lower
    }
}

UInt64.random()
UInt64.random()

extension Int64 {
    static func random(lower: Int64 = min, upper: Int64 = max) -> Int64 {
        let (s, overflow) = Int64.subtractWithOverflow(upper, lower)
        let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
        let r = UInt64.random(upper: u)
        
        if r > UInt64(Int64.max)  {
            return Int64(r - (UInt64(~lower) + 1))
        } else {
            return Int64(r) + lower
        }
    }
}

Int64.random()
Int64.random()

//: ## drand48
srand48(Int(time(nil)))
drand48()
drand48()


//: ## 数组随机排序
let arr = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

let numbers = arr.sort { (_, _) -> Bool in
    arc4random() < arc4random()
}

