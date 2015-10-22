//: # Swift字符串功能演示

import UIKit


//: ## 文件路径处理

let directory: String = "/var"
let path = NSString.pathWithComponents([ directory, "lib" ])
let filePath = NSString(string: path).stringByAppendingPathComponent("test")
let fullFilePath = NSString(string: filePath).stringByAppendingPathExtension("py")
//: ## String与CChar数组的转换

let str: String = "abc1个"
str.characters.count
//: ### String转换为CChar数组

let charArray1: [CChar] = str.cStringUsingEncoding(NSUTF8StringEncoding)!

// Error: Cannot convert value of type '[CChar]' to specified type 'UnsafePointer<CChar>'
//let charArray2: UnsafePointer<CChar> = str.cStringUsingEncoding(NSUTF8StringEncoding)!

func length(s: UnsafePointer<CChar>) {
    print(strlen(s))
}

length(str)

func length2(s: [CChar]) {
    print(strlen(s))
}

// Error: Cannot convert value of type 'String' to expected argument type '[CChar]'
//length2(str)


//: ### CChar数组转换为String

let chars: [CChar] = [99, 100, 101, 0]
//let chars: [CChar] = [99, 100, 101]
let str2: String = String.fromCString(chars)!


