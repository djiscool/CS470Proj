//
//  TableViewController.swift
//  HitList
//
//  Created by student on 4/6/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import Foundation
import UIKit

class MajorsTableViewController: UITableViewController {
    var majorsSchema: MajorsDataSource!
    var startTime: NSDate?
    var endTime: NSDate?
    var daysBool: [Bool]?

    override func viewDidLoad(){
        super.viewDidLoad()
        majorsSchema = MajorsDataSource()
        majorsSchema.setDate(daysBool!)
        majorsSchema.setTime(startTime!, end: endTime!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func receiveDataFromTimeView(daysBool: [Bool], startTimeStr: NSDate, endTimeStr: NSDate) {
        // data from segueue
        self.startTime = startTimeStr
        self.endTime = endTimeStr
        self.daysBool = daysBool

    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let n = majorsSchema {
            return n.numOfMajors()
        }
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MajorTableCell", forIndexPath: indexPath)
        
        // Configure the cell...
        //cell.textLabel?.text = "Row number \(indexPath.row) in section \(indexPath.section)"
        if let theCell = cell as? MajorTableViewCell {
            let major = majorsSchema.getMajorForIndex(indexPath.row)
            theCell.useMajor(major, numCourses: majorsSchema.numCourses(major))
        }
        /*
        let course = coursesDS?.courseAt(indexPath.row)
        cell.textLabel?.text = course?.courseName()
        */
        
        return cell

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let major = majorsSchema.getMajorForIndex(indexPath.row)
        // if selected all
        if major == "ALL" {
            performSegueWithIdentifier("ShowCoursesView", sender: self)
        }
        else if major == "GE" {
        //if selected GE
            performSegueWithIdentifier("ShowCategoryView", sender: self)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowCategoryView" {

            let detailedVC = segue.destinationViewController as! CategoryTableViewController

            detailedVC.receiveDataFromMajorView(majorsSchema.createDayString(), startTimeStr: majorsSchema.getStartTime(), endTimeStr: majorsSchema.getEndTime())
            
        }
        
        if segue.identifier == "ShowCoursesView" {
            
            let detailedVC = segue.destinationViewController as! CoursesTableViewController
            
            detailedVC.receiveDataFromMajorView(majorsSchema.createDayString(), startTime: majorsSchema.getStartTime(), endTime: majorsSchema.getEndTime(), selectedGE: "ALL")
            
        }
        
    }


}
