//
//  CoursesTableViewController.swift
//  HitList
//
//  Created by DJ on 4/27/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//


import Foundation
import UIKit

class CoursesTableViewController: UITableViewController {
    var coursesSchema: CoursesDataSource!
    var startTime: NSDate?
    var endTime: NSDate?
    var dayString: String?
    var allCourses: Bool?
    var GECategory: String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        coursesSchema = CoursesDataSource()
        if(dayString != nil){
            coursesSchema.setDate(dayString!)
        }
        else {
            coursesSchema.setDate("")
        }
        coursesSchema.setTime(startTime!, end: endTime!)
        coursesSchema.setGECategory(GECategory!)
        coursesSchema.fetchCourses()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let n = coursesSchema {
            return n.numCourses()
        }
        
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseTableCell", forIndexPath: indexPath)
        
        // Configure the cell...
        
        if let theCell = cell as? CourseTableViewCell {
        let course = coursesSchema.getCourseForIndex(indexPath.row)
        theCell.useCourse(course, numSeats: coursesSchema.getNumSeats(indexPath.row)) // nil until we figure out where to get seats from
        }
        
        return cell
        
        
    }
    
    func receiveDataFromMajorView(days: String?, startTime: NSDate, endTime: NSDate, selectedGE: String){
        allCourses = true
        self.dayString = days
        self.startTime = startTime
        self.endTime = endTime
        self.GECategory = "ALL"
    }
    
    func recievedDataFromCategory(days: String?, startTimeStr: NSDate, endTimeStr: NSDate, selectedGE: String){
        allCourses = false
        self.dayString = days
        self.startTime = startTimeStr
        self.endTime = endTimeStr
        self.GECategory = selectedGE
    }
    
    
    
}