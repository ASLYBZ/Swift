import Foundation


public class MyTimer: NSObject {
    
    public var index: Int = 0
    
    override public init() {
        
        super.init()
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "handlerTimer", userInfo: nil, repeats: true)
    }
    
    func handlerTimer() {
        
        index++
        print("index = \(index)")
    }
}