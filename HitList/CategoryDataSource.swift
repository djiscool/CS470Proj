//
//  CategoryDataSource.swift
//  HitList
//
//  Created by DJ on 4/27/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit
import CoreData

class CategoryDataSource: NSObject {
    let coreDataContext = CoreDataCommonMethods()
    var GECourses: [String] = []
    var daysString: String?

    var coursesParsed: Bool = false
    var startTime: NSDate?
    var endTime: NSDate?
    
    override init() {
        super.init()
        
    }
    
    // sets time interval to use
    func setTime(start: NSDate, end: NSDate) {
        self.startTime = start
        self.endTime = end
    }
    
    // sets days to use
    func setDate(days: String) {
        daysString = days
    }
    
    func getStartTime() -> NSDate {
        return startTime!
    }
    
    func getEndTime() -> NSDate {
        return endTime!
    }
    
    func getDays() -> String? {
        return daysString
    }
    
    // checks if all days are not selected i.e. ""
    func allFalse() -> Bool {
        if(daysString == ""){
            return true
        }
        return false
    }

    func numGEs() -> Int {
        return GECourses.count
    }
    
    //helper function to get the hour from NSDate
    func getHour(dateGiven: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let hour =  calendar.component(NSCalendarUnit.Hour, fromDate: dateGiven)
        return hour
    }
    
    //helper function to get the minutes from NSDate
    func getMin(dateGiven: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let min = calendar.component(NSCalendarUnit.Minute, fromDate: dateGiven)
        return min
    }
    
    // parses all available GE Categories from database, and puts in a string[]
    // given a set time interval and day[]
    func createGEarray() {
        if(!coursesParsed) {
            // Initialize Fetch Request
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
            fetchRequest.propertiesToFetch = ["ge_designation"]
            
            switch daysString! {
            case "M", "T", "W", "TH", "F":
                fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND meeting_pattern = %@", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), daysString!)
            case "MW":
                fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "MW")
            case "MWF":
                fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ or meeting_pattern = %@)", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "F", "MW", "MWF")
            case "TTH":
                fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "T", "TH", "TTH")
            default:
                fetchRequest.predicate = NSPredicate(format: "((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))))", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
            }

            
            do {
                let result = try managedObjectContext.executeFetchRequest(fetchRequest)
                for ge in result{
                    if let value = ge.valueForKey("ge_designation") as! String? {
                        GECourses.append(value)
                    }
                }
                
                print(GECourses)
                coursesParsed = true
                
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
        }
    }
    
    func GeForIndex(index: Int) -> String {
        return GECourses[index]
    }
    
    func numCoursesForGe(ge: String) -> Int {
        let fetchRequest = NSFetchRequest()
        
        var numOfCourses = 0
        
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
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND meeting_pattern = %@", ge, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), daysString!)
        case "MW":
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", ge, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "MW")
        case "MWF":
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ or meeting_pattern = %@)", ge, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "F", "MW", "MWF")
        case "TTH":
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", ge, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "T", "TH", "TTH")
        default:
            fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))))", ge, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
        }
        
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            numOfCourses = result.count
            

            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
            return numOfCourses
    }


    func numSeatsForGe(ge: String) -> Int {
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
            fetchRequest.predicate = NSPredicate(format: "ge_designation = %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND meeting_pattern = %@", ge ,getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), daysString!)
        case "MW":
            fetchRequest.predicate = NSPredicate(format: "ge_designation = %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", ge , getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "MW")
        case "MWF":
            fetchRequest.predicate = NSPredicate(format: "ge_designation = %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", ge , getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "F", "MW", "MWF")
        case "TTH":
            fetchRequest.predicate = NSPredicate(format: "ge_designation = %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", ge, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "T", "TH", "TTH")
        default:
            fetchRequest.predicate = NSPredicate(format: "ge_designation = %@ AND ((start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))))", ge, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
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



