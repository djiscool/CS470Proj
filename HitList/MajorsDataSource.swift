//
//  MajorsDataSource.swift
//  HitList
//
//  Created by DJ on 4/27/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit
import CoreData

class MajorsDataSource: NSObject {
    let coreDataContext = CoreDataCommonMethods()
    var GECourses: [String] = []
    var coursesParsed: Bool = false
    var Majors: [String] = []
    var numMajors: Int = 0
    var daysBool: [Bool]?
    var startTime: NSDate?
    var endTime: NSDate?

    override init() {
        super.init()
        createGEarray()
        createMajors()

    }
    
    func getStartTime() -> NSDate {
        return startTime!
    }
    
    func getEndTime() -> NSDate {
        return endTime!
    }
    
    func setTime(start: NSDate, end: NSDate) {
        self.startTime = start
        self.endTime = end
    }
    
    func setDate(days: [Bool]) {
        daysBool = days
    }
    
    func createDayString() -> String {
        var dayString: String = ""
        if daysBool![0] == true {
            dayString += "M"
        }
        if daysBool![1] == true {
            dayString += "T"
        }
        if daysBool![2] == true {
            dayString += "W"
        }
        if daysBool![3] == true {
            dayString += "TH"
        }
        if daysBool![4] == true {
            dayString += "F"
        }
        if daysBool![5] == true {
            dayString += "S"
        }
        return dayString
    }
    
    func allFalse() -> Bool {
        var allFalse: Bool = true
        for i in daysBool! {
            if i == true{
                allFalse = false
                break
            }
        }
        return allFalse
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
    
    // Assumes setTime, and setDate have been called
    func numCourses(GE: String) -> Int{
        // returns how many courses in total there are
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        var count = 0
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        if allFalse(){
            if(GE == "GE"){
                fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND (start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))", GE, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
            }
            else {
                fetchRequest.predicate = NSPredicate(format: "(start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
                
            }
        }
        else{
            if(GE == "GE"){
                /*
                fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND (start_time >= %@ OR (end_time >= %@ AND end_time <= %@)) AND meeting_pattern = %@", GE, startTime!, startTime!, endTime!, createDayString())
                */
                switch createDayString() {
                case "M", "T", "W", "TH", "F":
                    fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND (start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))) AND meeting_pattern = %@", GE, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), createDayString())
                case "MW":
                    fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND (start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", GE,getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "MW")
                case "MWF":
                    fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND (start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ or meeting_pattern = %@)", GE,  getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "F", "MW", "MWF")
                case "TTH":
                    fetchRequest.predicate = NSPredicate(format: "ge_designation contains[c] %@ AND (start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", GE,getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "T", "TH", "TTH")
                default:
                    fetchRequest.predicate = NSPredicate(format:  "ge_designation contains[c] %@ AND (start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))", GE, getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
                }
            }
            else {
                /*
                fetchRequest.predicate = NSPredicate(format: "(start_time >= %@ OR (end_time >= %@ AND end_time <= %@)) AND meeting_pattern = %@", startTime!, startTime!, endTime!, createDayString())
                */
                switch createDayString() {
                case "M", "T", "W", "TH", "F":
                    fetchRequest.predicate = NSPredicate(format: "(start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))) AND meeting_pattern = %@", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), createDayString())
                case "MW":
                    fetchRequest.predicate = NSPredicate(format: "(start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "MW")
                case "MWF":
                    fetchRequest.predicate = NSPredicate(format: "(start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "M", "W", "F", "MW", "MWF")
                case "TTH":
                    fetchRequest.predicate = NSPredicate(format: "(start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d))) AND (meeting_pattern = %@ OR meeting_pattern = %@ OR meeting_pattern = %@)", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!), "T", "TH", "TTH")
                default:
                    fetchRequest.predicate = NSPredicate(format: "(start_time_hour > %d OR (start_time_hour == %d AND start_time_min >= %d)) OR ((end_time_hour > %d OR (end_time_hour == %d AND end_time_min >= %d)) AND (end_time_hour < %d OR (end_time_hour == %d AND end_time_min <= %d)))", getHour(startTime!), getHour(startTime!), getMin(startTime!), getHour(startTime!), getHour(startTime!), getMin(startTime!),getHour(endTime!), getHour(endTime!), getMin(endTime!))
                }
            }
        }
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            count = result.count
            print(count)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return count
    }
    /*
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
*/
    
    // parses all available GE Categories from database, and puts in a string[]
    func createGEarray() {
        if(!coursesParsed) {
            // Initialize Fetch Request
            let fetchRequest = NSFetchRequest()
            
            // Create Entity Description
            let managedObjectContext = coreDataContext.backgroundContext!
            let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
            
            // Configure Fetch Request
            fetchRequest.entity = entityDescription
            // This allows me to get distinct results
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            // we want just one attribute
            fetchRequest.propertiesToFetch = ["ge_designation"]
            // Distinct
            fetchRequest.returnsDistinctResults = true
            // sorts the results ascending
            let sortDescriptor = NSSortDescriptor(key: "ge_designation", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
            
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
    
    
    func createMajors() {
        // hard coding for now
        /*
        Majors[0] = "GE"
        Majors[1] = "ALL"
*/
        Majors.append("GE")
        Majors.append("ALL")
        numMajors = 2
    }
    
    func getMajorForIndex(index: Int) -> String {
        //if (index < numMajors && numMajors > 0){
        return Majors[index]
        //}
        //return nil
    }
    
    func numOfMajors() -> Int {
        return numMajors
    }

}