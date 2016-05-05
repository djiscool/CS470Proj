//
//  CoursesDataSource.swift
//  HitList
//
//  Created by DJ on 4/27/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit
import CoreData

class CoursesDataSource: NSObject {
    let coreDataContext = CoreDataCommonMethods()
    
    var daysString: String?
    var startTime: String?
    var endTime: String?
    var GE: String?
    var Courses: [String] = []
    var CourseSeats: [Int?] = []
    var courseCount: Int = 0
    
    override init() {
        super.init()
    }
    
    func setTime(start: String, end: String) {
        self.startTime = start
        self.endTime = end
    }
    
    func setDate(days: String) {
        daysString = days
    }
    
    func setGECategory(GE: String) {
        self.GE = GE
    }

    
    func allFalse() -> Bool {
        if(daysString == ""){
            return true
        }
        return false
    }
    
    // Assumes fetchCourses has been called
    func numCourses() -> Int {
        
        return courseCount
        
    }
    // time, date, and ge must be set first
    func fetchCourses(){
        if(GE == "ALL"){
            fetchAllCourses()
        }
        else{
            fetchCoursesForGe()
        }
    }
    
    private func fetchAllCourses(){
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        if allFalse(){
            fetchRequest.predicate = NSPredicate(format: "start_time >= %@ AND end_time <= %@", startTime!, endTime!)
        }
        else{
            fetchRequest.predicate = NSPredicate(format: "start_time >= %@ AND end_time <= %@ AND meeting_pattern = %@", startTime!, endTime!, daysString!)
        }
        
        // sorts the results ascending
        let sortDescriptor = NSSortDescriptor(key: "subject", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            for ge in result{
                if let value = ge.valueForKey("course_title") as! String? {
                    Courses.append(value)
                    //print("value \(value)")
                }
            }
            courseCount += result.count
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

    }

    private func fetchCoursesForGe(){
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        fetchRequest.predicate = NSPredicate(format: "ge_designation = %@", GE!)
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            for course in result {
                if let value = course.valueForKey("course_title") as! String? {
                    Courses.append(value)
                }
                //check if there is an autoenrol1 and add it to the array if necessary
                if let autoenrol1 = course.valueForKey("auto_enrol1") as! String? { // if the json value is null the cast to string should fail
                    if let value = course.valueForKey("course_title") as! String? {
                        getCourseForAutoEnroll(value, section: autoenrol1)
                    }
                }
                //check if there is an autoenrol2 and add it to the array if necessary
                if let autoenrol2 = course.valueForKey("auto_enrol2") as! String? {
                    if let value = course.valueForKey("course_title") as! String? {
                        getCourseForAutoEnroll(value, section: autoenrol2)
                    }
                }
                // also need to get seats for course here
            }
            
            courseCount += result.count
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

    }
    
    func getCourseForAutoEnroll(courseTitle: String, section: String){
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        fetchRequest.predicate = NSPredicate(format: "course_title = %@ AND section = %@", courseTitle, section)
        
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)

            if let value = result[0].valueForKey("course_title") as! String? {
                let someString = value + " (AutoAdd)"
                Courses.append(someString)
                courseCount += 1
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    func getCourseForIndex(index: Int) -> String {
        print(Courses[index])
        return Courses[index]

    }
    
    
}
    