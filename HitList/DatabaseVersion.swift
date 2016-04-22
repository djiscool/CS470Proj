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
        if let ver = version["version"] {
            return ver as? Float
        }
        return nil
    }

    
}