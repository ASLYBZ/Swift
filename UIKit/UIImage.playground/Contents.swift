//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

let image = UIImage(named: "swift0");

/*:
## Get the image data
*/

let imageData:NSData? = UIImageJPEGRepresentation(image!, 1.0)

let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
view.backgroundColor = UIColor.whiteColor()

/*:
## 图片拉伸
*/
let normalButtonImage = UIImage(named: "button")
let normalButtonImageView = UIImageView(image: normalButtonImage)
normalButtonImageView.frame = CGRectMake(0, 0, 300, 50)
view.addSubview(normalButtonImageView)

let resizedButtonImageView = UIImageView(image: normalButtonImage?.resizableImageWithCapInsets(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)))
resizedButtonImageView.frame = CGRectMake(0, 60, 300, 50)
view.addSubview(resizedButtonImageView)


/*:
## 动效图片对象
*/

let image2 = UIImage.animatedImageNamed("swift", duration: 1)
let imageView2 = UIImageView(image: image2);
imageView2.frame = CGRect(x: 0.0, y: 200, width: 100, height: 100)
view.addSubview(imageView2)

let image3 = UIImage.animatedImageWithImages([UIImage(named: "swift1")!, UIImage(named: "swift0")!], duration: 0.5);
let imageView3 = UIImageView(image: image3)
imageView3.frame = CGRect(x: 150, y: 200, width: 100, height: 100)
imageView3.backgroundColor = UIColor.redColor()
view.addSubview(imageView3)


XCPlaygroundPage.currentPage.liveView = view

