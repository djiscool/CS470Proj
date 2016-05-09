//
//  SSUCourses+CoreDataProperties.swift
//  HitList
//
//  Created by DJ on 5/8/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SSUCourses {

    @NSManaged var auto_enrol1: NSNumber?
    @NSManaged var auto_enrol2: NSNumber?
    @NSManaged var course_title: String?
    @NSManaged var department: String?
    @NSManaged var end_time_hour: NSNumber?
    @NSManaged var end_time_min: NSNumber?
    @NSManaged var ge_designation: String?
    @NSManaged var meeting_pattern: String?
    @NSManaged var seats: NSNumber?
    @NSManaged var start_time_hour: NSNumber?
    @NSManaged var start_time_min: NSNumber?
    @NSManaged var subject: String?

}
