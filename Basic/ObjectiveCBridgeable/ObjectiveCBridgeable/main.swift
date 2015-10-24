//
//  main.swift
//  ObjectiveCBridgeable
//
//  Created by hanhui on 15/10/21.
//  Copyright © 2015年 Minya Knoka. All rights reserved.
//

import Foundation

let mobile = Mobile(brand: "iPhone", system: "iOS 9.0")

let swiftMobile = mobile as SwiftMobile
print("\(swiftMobile.brand): \(swiftMobile.system)")

let swiftMobile2 = SwiftMobile(brand: "Galaxy Note 3 Lite", system: "Android 5.0")
let mobile2 = swiftMobile2 as Mobile
print("\(mobile2.brand): \(mobile2.system)")

let sm1 = SwiftMobile(brand: "iPhone", system: "iOS 9.0")
let sm2 = SwiftMobile(brand: "Galaxy Note 3", system: "Android 5.0")
let sm3 = SwiftMobile(brand: "小米", system: "Android 4.0")

let mobiles = [sm1, sm2, sm3]

let mobileArray = mobiles as NSArray
print(mobileArray)
for i in 0..<mobiles.count {
    print("\(mobileArray.objectAtIndex(i).brand): \(mobileArray.objectAtIndex(i).system)")
}
