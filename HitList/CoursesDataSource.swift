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
    var startTime: NSDate?
    var endTime: NSDate?
    var GE: String?
    var Courses: [String] = []
    var courseCount: Int = 0
    
    override init() {
        super.init()
    }
    
    func setTime(start: NSDate, end: NSDate) {
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
    
    func getHour(dateGiven: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let hour =  calendar.component(NSCalendarUnit.Hour, fromDate: dateGiven)
        return hour
    }
    
    func getMin(dateGiven: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let min = calendar.component(NSCalendarUnit.Minute, fromDate: dateGiven)
        return min
    }
    
    private func fetchAllCourses(){
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        //((start_time_hour >= %d AND start_time_min >= %d) OR ((end_time_hour >= %d AND end_time_min >= %d) AND (end_time_hour <= %d AND end_time_min <= %d))) AND meeting_pattern = %@", getHour(startTime!), getMin(startTime!), getHour(startTime!), getMin(startTime!), getHour(endTime!), getMin(endTime!)
            switch daysString! {
                case "M", "T", "W", "TH", "F":
                    fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND meeting_pattern = %@", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), daysString!)
                case "MW":
                    fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "MW")
                case "MWF":
                    fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "F", "MW", "MWF")
                case "TTH":
                    fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "T", "TH", "TTH")
                default:
            fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d))))", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
            }
        
        // sorts the results ascending
        let sortDescriptor = NSSortDescriptor(key: "subject", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        // Distinct
        fetchRequest.returnsDistinctResults = true
        
        // This allows me to get distinct results
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        
        // we want just one attribute
        fetchRequest.propertiesToFetch = ["course_title"]
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            for course in result{
                if let value = course.valueForKey("course_title") as! String? {
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
        
        // Distinct
        fetchRequest.returnsDistinctResults = true
        
        // This allows me to get distinct results
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        
        // we want just one attribute
        fetchRequest.propertiesToFetch = ["course_title"]
        
        switch daysString! {
        case "M", "T", "W", "TH", "F":
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND meeting_pattern = %@", GE!, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), daysString!)
        case "MW":
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", GE!, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "MW")
        case "MWF":
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ or meeting_pattern = %@)", GE!,  getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "F", "MW", "MWF")
        case "TTH":
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", GE!, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "T", "TH", "TTH")
        default:
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d))))", GE!, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
        }
        
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
                courseCount += 1
            }
            
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
    
    func getNumSeats(index: Int) -> Int? {
        let course = getCourseForIndex(index)
        let fetchRequest = NSFetchRequest()
        var numOfSeats = -1
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        
        // Distinct
        fetchRequest.returnsDistinctResults = false
        /*
        fetchRequest.resultType = .DictionaryResultType
        
        let sumExpression = NSExpression(format: "sum:(seats)")
        let sumED = NSExpressionDescription()
        sumED.expression = sumExpression
        sumED.name = "sumOfAmount"
        sumED.expressionResultType = .Integer16AttributeType
        
        fetchRequest.propertiesToFetch = ["seats", sumED]
        */
        
        switch daysString! {
        case "M", "T", "W", "TH", "F":
            fetchRequest.predicate = NSPredicate(format: "course_title = %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND meeting_pattern = %@", course,getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), daysString!)
        case "MW":
            fetchRequest.predicate = NSPredicate(format: "course_title = %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", course, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "MW")
        case "MWF":
            fetchRequest.predicate = NSPredicate(format: "course_title = %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", course,  getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "F", "MW", "MWF")
        case "TTH":
            fetchRequest.predicate = NSPredicate(format: "course_title = %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", course, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "T", "TH", "TTH")
        default:
            fetchRequest.predicate = NSPredicate(format: "course_title = %@ AND ((start_time_hour > %d OR (start_time_hour > %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour < %d AND end_time_min <= %d))))", course, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
        }
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            for course in result {
                if let value = course.valueForKey("seats") as! Int? {
                    if(value != -1){
                        if(numOfSeats == -1){
                            numOfSeats = 0
                        }
                        numOfSeats += value
                    }
                }

            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    
        return numOfSeats
    }
}
    