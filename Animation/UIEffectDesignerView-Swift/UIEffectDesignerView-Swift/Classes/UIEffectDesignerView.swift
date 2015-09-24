//
//  UIEffectDesignerView.swift
//  UIEffectDesignerView-Swift
//
//  Created by iosdev on 15/9/20.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import UIKit

// the version this view is compatible with
let kFileFormatVersionExpected: Float = 0.1

// MARK: UIEffectDesignerView

class UIEffectDesignerView: UIView {
    
    // MARK: Private Properties
    
    private var _effect: [String: AnyObject]?           // emitter and effect data

    var emitter: CAEmitterLayer?

    override class func layerClass() -> AnyClass {
        return CAEmitterLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // custom initializer
    convenience init(fileName: String) {
        
        self.init()
        
        // flip the view on the iPhone
        self.transform = CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height)
        
        // load the file
        _effect = __loadFile(fileName)
        
        guard let effect = _effect else { return }
        
        let valueFromEffect = { (key: String) -> Float in
            effect[key]?.floatValue ?? 0
        }
        
        // check for file version compatibility
        let fileVersion: Float = valueFromEffect("version")
        let isValidFileFormat: Bool = fileVersion <= kFileFormatVersionExpected
        
        assert(isValidFileFormat, "File version not compatible with effect view. Please update the view class UIEffectDesignerView source code")
        
        // set the effect view frame
        let width: CGFloat  = CGFloat(valueFromEffect("width"))
        let height: CGFloat = CGFloat(valueFromEffect("height"))
        let x: CGFloat      = CGFloat(valueFromEffect("x"))
        let y: CGFloat      = CGFloat(valueFromEffect("y"))
        self.frame = CGRectMake(x - width / 2, y - height / 2, width, height)
        
        // initialize the emitter
        self.emitter = self.layer as? CAEmitterLayer
        
        guard let emitter = self.emitter else { return }

        // setup the emitter metrics
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.height / 2)
        emitter.emitterSize = self.bounds.size
        
        // setup the emitter type and mode
        let kEmitterModes = [ kCAEmitterLayerUnordered, kCAEmitterLayerAdditive, kCAEmitterLayerOldestLast, kCAEmitterLayerOldestFirst ]
        emitter.emitterMode = kEmitterModes[ Int(valueFromEffect("emitterMode")) ]
        
        let kEmitterTypes = [ kCAEmitterLayerRectangle, kCAEmitterLayerLine, kCAEmitterLayerPoint ]
        emitter.emitterShape = kEmitterTypes[ Int(valueFromEffect("emitterType")) ]
        
        // create new emitter cell
        let emitterCell: CAEmitterCell = CAEmitterCell()
        
        // load the texture image
        let imgData: CFDataRef? = NSData.dataFromBase64String(effect["texture"] as! String)
        let imgDataProvider: CGDataProviderRef? = CGDataProviderCreateWithCFData(imgData)
        let image: CGImageRef? = CGImageCreateWithPNGDataProvider(imgDataProvider, nil, true, .RenderingIntentDefault)
        emitterCell.contents = image as? AnyObject
        
        emitterCell.name = "cell"
        
        // get the particles start color
        var color: UIColor = UIColor(rgba: (effect["color"] ?? "#FFFFFF") as! String)
        color = color.colorWithAlphaComponent(CGFloat(valueFromEffect("alpha")))
        
        emitterCell.color = color.CGColor
        
        emitterCell.birthRate           = valueFromEffect("birthRate")
        emitterCell.lifetime            = valueFromEffect("lifetime")
        emitterCell.lifetimeRange       = valueFromEffect("lifetimeRange")
        emitterCell.velocity            = CGFloat(valueFromEffect("velocity"))
        emitterCell.velocityRange       = CGFloat(valueFromEffect("velocityRange"))
        
        emitterCell.redRange            = valueFromEffect("redRange")
        emitterCell.redSpeed            = valueFromEffect("redSpeed")
        emitterCell.greenRange          = valueFromEffect("greenRange")
        emitterCell.greenSpeed          = valueFromEffect("greenSpeed")
        emitterCell.blueRange           = valueFromEffect("blueRange")
        emitterCell.blueSpeed           = valueFromEffect("blueSpeed")
        
        emitterCell.emissionLatitude    = CGFloat(valueFromEffect("latitude"))
        emitterCell.emissionLongitude   = CGFloat(valueFromEffect("longitude"))
        
        emitterCell.xAcceleration       = CGFloat(valueFromEffect("xAcceleration"))
        emitterCell.yAcceleration       = CGFloat(valueFromEffect("yAcceleration"))
        emitterCell.zAcceleration       = CGFloat(valueFromEffect("zAcceleration"))
        
        emitterCell.alphaRange          = valueFromEffect("alphaRange")
        emitterCell.alphaSpeed          = valueFromEffect("alphaSpeed")
        
        emitterCell.scale               = CGFloat(valueFromEffect("scale"))
        emitterCell.scaleRange          = CGFloat(valueFromEffect("scaleRange"))
        emitterCell.scaleSpeed          = CGFloat(valueFromEffect("scaleSpeed"))
        
        emitterCell.spin                = CGFloat(valueFromEffect("spin"))
        emitterCell.spinRange           = CGFloat(valueFromEffect("spinRange"))
        
        // add the cell to the emitter layer
        emitter.emitterCells = [ emitterCell ]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    
    // just read json file and return a dictionary
    private func __loadFile(fileName: String) -> [String: AnyObject]? {
        
        let filePath = NSString.pathWithComponents([ NSBundle.mainBundle().resourcePath!, fileName ])
        
        guard let fileData = NSData(contentsOfFile: filePath) else { return nil }
        
        do
        {
            let dict: NSDictionary = try NSJSONSerialization.JSONObjectWithData(fileData, options: .MutableContainers) as! NSDictionary
            return dict as? [String : AnyObject]
        } catch {
            print("error loading the .ped file")
        }
        
        return nil
    }
}
