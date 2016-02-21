//: [Previous](@previous)

import Foundation


/*:



## Auto Layout通用概念

### 1.经验法则：每个维度至少有两个约束

在每个维度(水平与竖直)上，一个视图的位置和大小由三个值来定义：头部空间(leading space)，大小和尾部空间(trailing space)[注释1]。一个视图的leading和trailing空间可以相对于父视图来定义，也可以相对于视图层级架构中的兄弟视图来定义。一般来说，我们的布局约束必须满足这两个值，以便计算第三个值(size)。其结果是，一个标准的视图在每个维度上必须至少有两个约束，以明确视图的布局。

### 2.拥抱固有大小(Intrinsic Size)

一些控件，如标签和按钮，都有一个所谓的固有大小(Intrinsic Size)。视控件的不同，固有大小可以在水平或竖直或同时两个方向上有效。当一个控件没有明确的宽度和高度约束时，就会使用它的固有大小作为约束。这允许我们在每个方向上只使用一个显式约束就可以创建明确的布局(相对于上面第1条规则)，并让控件可以根据自身的内容来自动调整大小。这是在本地化中创建一个最佳布局的关键。

## Interface Builder中的Auto Layout

*更新于2014.3.3：当我写这篇文章时，Xcode的版本是4.x。到了Xcode 5时，Interface Builder对Auto Layout的处理已以有了显著的改变，所以下面的一些内容已经不再有效(特别是第3、4条)。Xcode现在允许Interface Builder在创建模棱两可的布局，并在编译时添加missing constraints来明确一个布局。这使得在开发过程中，原型的设计和快速变更来得更加简单。第5、6条在Xcode 5中仍然是有效的。*

Interface Builder中的Auto Layout编辑器似乎有自己的想法。理解Xcode的工程师为什么这样设计，可以让我们使用它是不至于太过沮丧。

![image](http://oleb.net/media/interface-builder-constraints-editor-context-menu.png)

图1：如果某个约束会导致模棱两可的布局，IB是不允许我们删除它的



*/





//: [Next](@next)
