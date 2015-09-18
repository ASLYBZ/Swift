//
//  ViewController.swift
//  TinderSimpleSwipeCards-Swift
//
//  Created by iosdev on 15/9/16.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let draggableView: SwipeCardContainer = SwipeCardContainer(frame: self.view.bounds)
        self.view.addSubview(draggableView)
    }
}

