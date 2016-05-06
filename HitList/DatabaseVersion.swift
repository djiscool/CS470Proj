//
//  Version.swift
//  HitList
//
//  Created by student on 4/22/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import Foundation
import UIKit

class DatabaseVersion: NSObject {
    
    let version: AnyObject
    
    init(version: AnyObject) {
        self.version = version
        super.init()
    }
    
    
    func getVersion() -> Float? {
        let firstValue = version[0]
        if let ver = firstValue["version"] {
            print("ver = \(ver)")
            return ver as? Float
        }
        return nil
    }

    
}