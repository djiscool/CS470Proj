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
    var dayString: String?

    var coursesParsed: Bool = false
    var startTime: NSDate?
    var endTime: NSDate?
    
    override init() {
        super.init()
        createGEarray()
        
    }
    
    func setTime(start: NSDate, end: NSDate) {
        self.startTime = start
        self.endTime = end
    }
    
    func setDate(days: String) {
        dayString = days
    }
    
    
    
    func allFalse() -> Bool {
        if(dayString == ""){
            return true
        }
        return false
    }

    
    // Assumes setTime, and setDate have been called
    
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
    
    func coursesForGe(ge: String){
        
    }
    

    
}
