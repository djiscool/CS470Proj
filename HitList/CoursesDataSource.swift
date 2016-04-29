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
    
    // Assumes setTime, setDate, and setGECategory have been called
    func numCourses() -> Int {
        
        
        // returns how many courses in give GE or subject
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        var count = 0
        
        // Create Entity Description
        let managedObjectContext = coreDataContext.backgroundContext!
        let entityDescription = NSEntityDescription.entityForName("SSUCourses", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        fetchRequest.predicate = NSPredicate(format: "ge_designation = %@", GE!)
        
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
    
    

    func coursesForGe(ge: String){
        
    }
}
    