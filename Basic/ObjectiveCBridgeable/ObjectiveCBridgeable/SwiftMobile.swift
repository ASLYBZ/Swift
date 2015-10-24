//
//  SwiftMobile.swift
//  ObjectiveCBridgeable
//
//  Created by hanhui on 15/10/21.
//  Copyright © 2015年 Minya Knoka. All rights reserved.
//

import Foundation

struct SwiftMobile {
    
    let brand: String
    let system: String
}

extension SwiftMobile: _ObjectiveCBridgeable {
    
    typealias _ObjectiveCType = Mobile
    
    static func _isBridgedToObjectiveC() -> Bool {
        return true
    }
    
    static func _getObjectiveCType() -> Any.Type {
        return _ObjectiveCType.self
    }
    
    func _bridgeToObjectiveC() -> _ObjectiveCType {
        return Mobile(brand: brand, system: system)
    }
    
    static func _forceBridgeFromObjectiveC(source: _ObjectiveCType, inout result: SwiftMobile?) {
        result = SwiftMobile(brand: source.brand, system: source.system)
    }
    
    static func _conditionallyBridgeFromObjectiveC(source: _ObjectiveCType, inout result: SwiftMobile?) -> Bool {
        
        _forceBridgeFromObjectiveC(source, result: &result)
        
        return true
    }
}