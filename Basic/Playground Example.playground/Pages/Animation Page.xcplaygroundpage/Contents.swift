//: [Previous](@previous)

import Foundation
import UIKit
import XCPlayground

//: Example : UIView Animation
//let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
//containerView.backgroundColor = UIColor.whiteColor()
//
//XCPlaygroundPage.currentPage.liveView = containerView
//
//let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
//circle.center = containerView.center
//circle.layer.cornerRadius = 25.0
//
//let startingColor = UIColor(red: (253.0/255.0), green: (159.0/255.0), blue: (47.0/255.0), alpha: 1.0)
//circle.backgroundColor = startingColor
//
//containerView.addSubview(circle);
//
//let rectangle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
//rectangle.center = containerView.center
//rectangle.layer.cornerRadius = 5.0
//
//rectangle.backgroundColor = UIColor.whiteColor()
//
//containerView.addSubview(rectangle)
//
//UIView.animateWithDuration(10.0, animations: { () -> Void in
//    let endingColor = UIColor(red: (255.0/255.0), green: (61.0/255.0), blue: (24.0/255.0), alpha: 1.0)
//    circle.backgroundColor = endingColor
//    
//    let scaleTransform = CGAffineTransformMakeScale(5.0, 5.0)
//    
//    circle.transform = scaleTransform
//    
//    let rotationTransform = CGAffineTransformMakeRotation(3.14)
//    
//    rectangle.transform = rotationTransform
//})

//: Example : Core animation
//let view: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375, height: 677))
//view.backgroundColor = UIColor.whiteColor()
//
//let menuItemImage = UIImage(named: "bg-menuitem")!
//let menuItemHighlitedImage = UIImage(named: "bg-menuitem-highlighted")!
//
//let starImage = UIImage(named: "icon-star")!
//
//let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
//
//let starMenuItem2 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
//
//let starMenuItem3 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
//
//let starMenuItem4 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
//
//let starMenuItem5 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
//
//let items = [starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5]
//
//let startItem = PathMenuItem(image: UIImage(named: "bg-addbutton")!,
//    highlightedImage: UIImage(named: "bg-addbutton-highlighted"),
//    contentImage: UIImage(named: "icon-plus"),
//    highlightedContentImage: UIImage(named: "icon-plus-highlighted"))
//
//let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
//menu.startPoint     = CGPointMake(view.frame.width/2, view.frame.height / 2)
//menu.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/5)
//menu.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/5) * 1/2
//menu.timeOffset     = 0.0
//menu.farRadius      = 160.0
//menu.nearRadius     = 120.0
//menu.endRadius      = 150.0
//menu.animationDuration = 5.0
//
//view.addSubview(menu)
//
//XCPlaygroundPage.currentPage.liveView = view
//
//menu.handleTap()

let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 480.0))
view.backgroundColor = UIColor.whiteColor()

XCPlaygroundPage.currentPage.liveView = view

let effectView = UIEffectDesignerView(fileName: "redorange.ped")
view.addSubview(effectView)


//: [Next](@next)
