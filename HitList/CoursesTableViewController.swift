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
    //var categorySchema: CategoryDataSource!
    var startTime: String?
    var endTime: String?
    var daysBool: [Bool]?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //categorySchema = CategoryDataSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func courseProcessorForThisView(ds: CourseSchemaProcessor) {
        // rewrite this function. use this for segeue
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseTableCell", forIndexPath: indexPath)
        
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