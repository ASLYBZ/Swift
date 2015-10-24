//: Playground - noun: a place where people can play

import Foundation
import UIKit

let mobile = ["iPhone", "Nokia", "小米Note"]
let mobile1 = (mobile as NSArray).objectAtIndex(1)

let animalArray = NSArray(objects: "lion", "tiger", "monkey")
var animal = (animalArray as NSArray).count

let mobileSet: Set<String> = ["iPhone", "Nokia", "小米Note"]
let mobile2 = (mobileSet as NSSet).count

/*:
##
*/

//class SwiftClass {
//    
//}
//
//var objects = [NSObject(), NSObject(), NSObject()]
//var objectArray = (objects as NSMutableArray)

var objectArray = NSMutableArray()
objectArray.addObject(NSObject())
objectArray.addObject(NSObject())

var objects = objectArray as Array

//
//var swiftClasses = [SwiftClass(), SwiftClass(), SwiftClass()]
//var classArray = (swiftClasses as NSMutableArray)

//var numbers = [1, 29, 40]
//var numberArray = (numbers as NSMutableArray).objectAtIndex(2)
//
//print(numberArray.dynamicType)

