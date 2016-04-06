//
//  CoursesDataSource.swift
//  HitList
//
//  Created by student on 4/6/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit

class CoursesDataSource: NSObject {
    
    var courses: [AnyObject]
    
    init(dataSource: [AnyObject]) {
        courses = dataSource
        super.init()
    }
    
    

}
