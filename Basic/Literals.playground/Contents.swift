//: # Playground中的字面量

import UIKit

/*:
## 图片字面量
*/

let image = UIImage(named: "swift.png")

let image2 = [#Image(imageLiteral: "swift.png")#]


/*:
## 颜色字面量
*/
let template = [#Image(imageLiteral: "swift.png")#].imageWithRenderingMode(.AlwaysTemplate)
let imageView = UIImageView(image: template)
imageView.tintColor = [#Color(colorLiteralRed: 0.4571597450657895, green: 1, blue: 1, alpha: 1)#]

let gradientLayer = CAGradientLayer()
gradientLayer.colors = [[#Color(colorLiteralRed: 1, green: 0.4214124177631579, blue: 1, alpha: 1)#].CGColor, [#Color(colorLiteralRed: 0.3517937911184211, green: 1, blue: 0.3611996299342105, alpha: 1)#].CGColor]

let backgroundView = UIView(frame: imageView.bounds)
gradientLayer.frame = backgroundView.bounds

backgroundView.layer.addSublayer(gradientLayer)
backgroundView.addSubview(imageView)


/*:
## 文件字面量
*/


