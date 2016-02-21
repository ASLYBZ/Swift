//: [Previous](@previous)

import Foundation
import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: ## Example : 异步代码执行 --> 网络请求
//let url = NSURL(string: "http://tp3.sinaimg.cn/3321824014/180/40020528087/1")
//let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
//    data, _, _ in
//    
////    sleep(6)
//    
//    let image = UIImage(data: data!)
//    
//    XCPlaygroundPage.currentPage.captureValue(image, withIdentifier: "Show an image")
//}
//task.resume()


//: ## Example : Timer
let timer = MyTimer()
//: [Next](@next)
