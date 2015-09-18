//
//  OverlayView.swift
//  TinderSimpleSwipeCards-Swift
//
//  Created by iosdev on 15/9/16.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import UIKit

enum OverlayViewMode {
    case Left
    case Right
}

class OverlayView: UIView {

    private var __imageView: UIImageView
    
    private var __mode: OverlayViewMode = .Left
    var mode: OverlayViewMode {
        get {
            return __mode
        }
        set {
            if __mode == newValue {
                return
            }
            
            __mode = newValue
            
            __imageView.image = UIImage(named: (newValue == .Left ? "noButton" : "yesButton"))
        }
    }
    
    override init(frame: CGRect) {
        
        __imageView = UIImageView(image: UIImage(named: "noButton"))
        __imageView.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        
        super.init(frame: frame)
        
        addSubview(__imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
