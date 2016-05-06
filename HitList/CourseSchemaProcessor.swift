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
    var GECourses: [String] = []
    var coursesParsed: Bool = false
    var Majors: [String] = []
    var numMajors: Int = 0

    init(courseModelJSON: [AnyObject]) {
        courseModelJSONString = courseModelJSON
        super.init()
        processJSON(courseModelJSON)

        /*
        fetchArtistWithName("Beatles, The")
        fetchAlbumWithID("97269")
        */
        //fetchAllCourses()
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

                if let autoenrol1 = courseDict["auto_enrol1"] {
                    course.auto_enrol1 = autoenrol1 as? NSNumber
                }
                if let autoenrol2 = courseDict["auto_enrol2"] {
                    course.auto_enrol2 = autoenrol2 as? NSNumber
                }
                if let course_title = courseDict["course_title"] {
                    course.course_title = course_title as? String
                }
                if let department = courseDict["department"] {
                    course.department = department as? String
                }
                if let ge_designation = courseDict["ge_designation"] {
                    course.ge_designation = ge_designation as? String
                }
                if let meeting_pattern = courseDict["meeting_pattern"] {
                    course.meeting_pattern = meeting_pattern as? String
                }
                if let subject = courseDict["subject"] {
                    course.subject = subject as? String
                }
                if let end_time = courseDict["end_time"] {
                    course.end_time = end_time as? String
                }
                if let start_time = courseDict["start_time"] {
                    course.start_time = start_time as? String
                }
                if let seats = courseDict["seats"] {
                    course.seats = seats as? NSNumber
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
        if(GE == "GE"){
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@", GE)
        }else{
            fetchRequest.predicate = NSPredicate(format: "ge_designation = %@", GE)
        }
        
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
    
   

}