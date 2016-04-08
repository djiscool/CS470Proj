//
//  CoursesDataSource.swift
//  HitList
//
//  Created by student on 4/6/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit

class CoursesDataSource: NSObject {
    
    let coreDataStack = CoreDataStack(modelName: "Course List")
    
    var courses: [AnyObject]
    
    init(dataSource: [AnyObject]) {
        courses = dataSource
        super.init()
    }
    
    func numCourses() -> Int {
        return courses.count
    }
    
    func courseAt(index: Int) -> Course {
        let course = Course(course: courses[index])
        return course
    }
}
