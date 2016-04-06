//
//  Course.swift
//  HitList
//
//  Created by student on 4/6/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit

class Course: NSObject {
    var course: AnyObject
    
    init(course:AnyObject) {
        self.course = course
        super.init()
    }
    
    func courseName() -> String? {
        if let a = course["course_title"] {
            return a as? String
        }
        return nil
    }
}