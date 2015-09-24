//
//  ViewController.swift
//  UIEffectDesignerView-Swift
//
//  Created by iosdev on 15/9/20.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let effectView = UIEffectDesignerView(fileName: "redorange.ped")
        self.view.addSubview(effectView)
    }
}

