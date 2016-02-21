import Foundation
import UIKit

public class Triangle: NSObject {
    
    public var point1: CGPoint = CGPointZero
    public var point2: CGPoint = CGPointZero
    public var point3: CGPoint = CGPointZero
    
    
    public init(point1: CGPoint, point2: CGPoint, point3: CGPoint) {
        
        super.init()
        
        self.point1 = point1
        self.point2 = point2
        self.point3 = point3
    }
    
    func debugQuickLookObject () -> AnyObject? {
        
//        return "This is a triangle"
        
        let color = UIColor.blueColor()
        
        let bezier = UIBezierPath()
        bezier.moveToPoint(point1)
        bezier.addLineToPoint(point2)
        bezier.addLineToPoint(point3)
        
        color.setStroke()
        bezier.closePath()
        bezier.stroke()
        
        return bezier
    }
}