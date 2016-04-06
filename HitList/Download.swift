//
//  Download.swift
//  HitList
//
//  Created by student on 4/6/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import Foundation
import UIKit

class Download: NSObject {
    
    
    let fvc: CoursesTableViewController
    
    init(fvc: CoursesTableViewController) {
        self.fvc = fvc
        super.init()
    }
    
    func toDict(json: String) {
        let JSONData = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let courses = try! NSJSONSerialization.JSONObjectWithData(JSONData!, options: []) as! [AnyObject]
        fvc.acceptData(CoursesDataSource(dataSource: courses))
    }
    
    
    
}