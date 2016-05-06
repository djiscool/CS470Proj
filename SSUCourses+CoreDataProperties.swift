//
//  SSUCourses+CoreDataProperties.swift
//  HitList
//
//  Created by DJ on 5/5/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SSUCourses {

    @NSManaged var acad_group: NSNumber?
    @NSManaged var auto_enrol1: NSNumber?
    @NSManaged var auto_enrol2: NSNumber?
    @NSManaged var catalog: NSNumber?
    @NSManaged var class_number: NSNumber?
    @NSManaged var class_type: String?
    @NSManaged var combined_section: String?
    @NSManaged var component: String?
    @NSManaged var course_title: String?
    @NSManaged var cs_number: NSNumber?
    @NSManaged var department: String?
    @NSManaged var end_time: String?
    @NSManaged var facility_name: String?
    @NSManaged var ge_designation: String?
    @NSManaged var instructor_fName: String?
    @NSManaged var instructor_id: String?
    @NSManaged var instructor_lName: String?
    @NSManaged var k_factor: NSNumber?
    @NSManaged var max_units: NSNumber?
    @NSManaged var meeting_pattern: String?
    @NSManaged var min_units: NSNumber?
    @NSManaged var s_factor: NSNumber?
    @NSManaged var school_name: String?
    @NSManaged var section: String?
    @NSManaged var start_time: String?
    @NSManaged var subject: String?
    @NSManaged var workload_factor: String?
    @NSManaged var wtu: NSNumber?
    @NSManaged var seats: NSNumber?

}
