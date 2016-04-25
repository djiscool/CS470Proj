//
//  CourseSchemaProcessor.swift
//  HitList
//
//  Created by DJ on 4/19/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit
import CoreData

class CourseSchemaProcessor: NSObject {


    let courseModelJSONString: [AnyObject]
    let coreDataContext = CoreDataCommonMethods()


    init(courseModelJSON: [AnyObject]) {
        courseModelJSONString = courseModelJSON
        super.init()
        processJSON(courseModelJSON)
        /*
        fetchArtistWithName("Beatles, The")
        fetchAlbumWithID("97269")
        */
        fetchAllCourses()
    }

    func processJSON(schema: [AnyObject]) {
        /*
        for entity in schema {
            if let payload = entity["payload"], let entity_name = entity["entity_name"] {
                let name = entity_name as! String
                let objects = payload as! [AnyObject]
                
                if name == "SSUCourses" {
*/ // Outline for processing JSON wtih multiple entities
            // we don't have multiple entities, so we only need to process schema instead of objects
                    processCoursesJSON(schema)
                //}
            //}
        //}
    }
    
    func processCoursesJSON(artistObjects: [AnyObject]) {
        for artistObject in artistObjects {
            if let courseDict = artistObject as? Dictionary<String, AnyObject> {
                let course = NSEntityDescription.insertNewObjectForEntityForName("SSUCourses", inManagedObjectContext: coreDataContext.backgroundContext!) as! SSUCourses
                
                if let acad_group = courseDict["acad_group"] {
                    course.acad_group = acad_group as? NSNumber
                }
                if let autoenrol1 = courseDict["auto_enrol1"] {
                    course.auto_enrol1 = autoenrol1 as? NSNumber
                }
                if let autoenrol2 = courseDict["auto_enrol2"] {
                    course.auto_enrol2 = autoenrol2 as? NSNumber
                }
                if let catalog = courseDict["catalog"] {
                    course.catalog = catalog as? NSNumber
                }
                if let class_number = courseDict["class_number"] {
                    course.class_number = class_number as? NSNumber
                }
                if let cs_number = courseDict["cs_number"] {
                    course.cs_number = cs_number as? NSNumber
                }
                if let k_factor = courseDict["k_factor"] {
                    course.k_factor = k_factor as? NSNumber
                }
                if let max_units = courseDict["max_units"] {
                    course.max_units = max_units as? NSNumber
                }
                if let min_units = courseDict["min_units"] {
                    course.min_units = min_units as? NSNumber
                }
                if let s_factor = courseDict["s_factor"] {
                    course.s_factor = s_factor as? NSNumber
                }
                if let wtu = courseDict["wtu"] {
                    course.wtu = wtu as? NSNumber
                }
                if let class_type = courseDict["class_type"] {
                    course.class_type = class_type as? String
                }
                if let combined_section = courseDict["combined_section"] {
                    course.combined_section = combined_section as? String
                }
                if let component = courseDict["component"] {
                    course.component = component as? String
                }
                if let course_title = courseDict["course_title"] {
                    course.course_title = course_title as? String
                }
                if let department = courseDict["department"] {
                    course.department = department as? String
                }
                if let facility_name = courseDict["facility_name"] {
                    course.facility_name = facility_name as? String
                }
                if let ge_designation = courseDict["ge_designation"] {
                    course.ge_designation = ge_designation as? String
                }
                if let instructor_fName = courseDict["instructor_fName"] {
                    course.instructor_fName = instructor_fName as? String
                }
                if let instructor_id = courseDict["instructor_id"] {
                    course.instructor_id = instructor_id as? String
                }
                if let instructor_lName = courseDict["instructor_lName"] {
                    course.instructor_lName = instructor_lName as? String
                }
                if let meeting_pattern = courseDict["meeting_pattern"] {
                    course.meeting_pattern = meeting_pattern as? String
                }
                if let school_name = courseDict["school_name"] {
                    course.school_name = school_name as? String
                }
                if let section = courseDict["section"] {
                    course.section = section as? String
                }
                if let subject = courseDict["subject"] {
                    course.subject = subject as? String
                }
                if let workload_factor = courseDict["workload_factor"] {
                    course.workload_factor = workload_factor as? String
                }
                if let end_time = courseDict["end_time"] {
                    if let end_time: String? = String(end_time) {
                    let RFC3339DateFormatter = NSDateFormatter()
                    RFC3339DateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    RFC3339DateFormatter.dateFormat = "HH:mm:ss"
                    let time = RFC3339DateFormatter.dateFromString(end_time!)
                    course.end_time = time
                    }
                }
                if let start_time = courseDict["start_time"] {
                    if let start_time: String? = String(start_time) {
                        let RFC3339DateFormatter = NSDateFormatter()
                        RFC3339DateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                        RFC3339DateFormatter.dateFormat = "HH:mm:ss"
                        let time = RFC3339DateFormatter.dateFromString(start_time!)
                        course.start_time = time
                    }
                }
                
            }
        }
                coreDataContext.saveContext()
    }
    
    func fetchAllCourses() {
        let fReq = NSFetchRequest(entityName: "SSUCourses")
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.executeFetchRequest(fReq)
            let courses = result as! [SSUCourses]
            print("Printing titles of all courses")
            for course in courses {
                print(course.course_title, course.start_time)
            }
        } catch {
            print("Unable to fetch all courses from the database.")
            abort()
        }
    }
    
    
    func numCourses() -> Int{
        // returns how many courses in total there are
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        var count = 0
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            count = result.count
            //print(count)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return count
    }
    
    func numCourses(GE: String) -> Int {
        // returns how many courses in give GE or subject
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        var count = 0
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "ge_designation = %@", GE)
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            count = result.count
            //print(count)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return count

    }
    
    func createGEarray() {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "ge_designation != nil")
        fetchRequest.returnsDistinctResults = true
        let sortDescriptor = NSSortDescriptor(key: "ge_designation", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            for course in result{
                print (course.ge_designation)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

}