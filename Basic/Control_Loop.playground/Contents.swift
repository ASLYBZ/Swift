//: # 如何在 Swift 2.0 中实现从非零下标遍历数组
//: http://swift.gg/2015/09/25/ask-erica-how-do-i-loop-from-non-zero-n-swiftlang/

import UIKit

var array: [String] = Array(count: 10, repeatedValue: "0")

//: ## for ;;; {}

for var index = 5; index < 10; index++ {
    array[index] = "\(index)"
}

array

//: ## for in
for index in 0..<5 {
    array[index] = "\(index)"
}

array

//: ## forEach
(5..<array.count).forEach { index in
    array[index] = "\(index * 2)"
}

array

//: ## for in .enumerate

for (index, _) in array[0..<5].enumerate() {
    array[index] = "\(index * 3)"
}

array

//: ## zip
let range = 5..<array.count
for (index, _) in zip(range, array[range]) {
    array[index] = "\(index)"
}

array

//: ## zip.forEach
zip(range, array[range]).forEach { (index, _) in
    array[index] = "a"
}

array

//: ## map
func multipler(factor: Int)(currentNum: String) -> String {
    return "\(factor)"
}

let arr1 = array[range].map(multipler(5))

arr1

//: ## dropFirst

var arr2 = [String]()
for value in array.dropFirst(5) {
    arr2.append(value)
}

arr2

var slice = array.dropFirst(5)
while !slice.isEmpty {
    slice.removeFirst()
}

slice
