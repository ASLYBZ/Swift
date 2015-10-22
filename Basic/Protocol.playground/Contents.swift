//: # Protocol

import UIKit

/*:
## 属性
*/

protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    
    var fullName: String
}

let john = Person(fullName: "John Appleseed")
john.fullName

class Starship: FullyNamed {
    
    var prefix: String?
    var name: String
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}

var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
ncc1701.fullName

/*:
## 方法
*/

protocol RandomNumberGenerator {
    
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    
    func random() -> Double {
        lastRandom = ((lastRandom * a + c) % m)
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
generator.random()

/*:
## Mutating方法
*/

protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case Off, On
    
    mutating func toggle() {
        switch self {
        case Off:
            self = On
        case On:
            self = Off
        }
    }
}

var lightSwitch = OnOffSwitch.Off
lightSwitch.toggle()


/*:
## 协议类型
*/

class Dice {
    
    let sides: Int
    let generator: RandomNumberGenerator
    
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())

for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}

/*:
## 在扩展中添加协议
*/

protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

/*:
## 通过扩展补充协议声明
*/

struct Hamster {
    
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}

extension Hamster: TextRepresentable {}


/*:
## 类专属协议
*/
protocol SomeClassOnlyProtocol: class {
    
}

/*:
## 协议合成
*/

protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person1: Named, Aged {
    
    var name: String
    var age: Int
}

func wishHappyBirthday(celebrator: protocol<Named, Aged>) {
    print("Happy birthday \(celebrator.name) - you're \(celebrator.age)!")
}

let birthdayPerson = Person1(name: "Malcolm", age: 21)
wishHappyBirthday(birthdayPerson)

/*:
## 可选协议
*/

@objc protocol CounterDataSource {
    optional func incrementForCount(count: Int) -> Int
    optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    
    func increment() {
        
        if let amount = dataSource?.incrementForCount?(count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: CounterDataSource {
    @objc let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

class TowardsZeroSource: CounterDataSource {
    
    @objc func incrementForCount(count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

counter.count = -1
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}


/*:
## 协议扩展
*/
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

let generator2 = LinearCongruentialGenerator()
print("Here's a random boolean: \(generator.randomBool())")


/*:
## 为协议扩展添加限制条件
*/

























