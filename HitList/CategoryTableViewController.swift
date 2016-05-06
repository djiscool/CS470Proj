//
//  CategoryTableViewController.swift
//  HitList
//
//  Created by DJ on 4/27/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import Foundation
import UIKit

class CategoryTableViewController: UITableViewController {
    var categorySchema: CategoryDataSource!
    var startTime: String?
    var endTime: String?
    var dayString: String?
    var GE: String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        categorySchema = CategoryDataSource()
        if(dayString != nil){
            categorySchema.setDate(dayString!)
        }
        else{
            categorySchema.setDate("")
        }
        categorySchema.setTime(startTime!, end: endTime!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func receiveDataFromMajorView(days: String?, startTimeStr: String, endTimeStr: String) {
        // rewrite this function. use this for segeue
        self.dayString = days
        self.startTime = startTimeStr
        self.endTime = endTimeStr
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        /*
        if let n = majorsSchema {
            return n.numOfMajors()
        }
        */
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableCell", forIndexPath: indexPath)
        
        // Configure the cell...
        //cell.textLabel?.text = "Row number \(indexPath.row) in section \(indexPath.section)"
        /*
        if let theCell = cell as? MajorTableViewCell {
            let major = majorsSchema.getMajorForIndex(indexPath.row)
            theCell.useMajor(major, numCourses: majorsSchema.numCourses(major))
        }
        */
        /*
        let course = coursesDS?.courseAt(indexPath.row)
        cell.textLabel?.text = course?.courseName()
        */
        
        return cell
        
        
    }


    
    
}

