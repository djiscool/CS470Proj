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
    
    var coursesSchema: CourseSchemaProcessor!
    var download: Download?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    func courseProcessorForThisView(ds: CourseSchemaProcessor) {
        self.coursesSchema = ds
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MajorTableCell", forIndexPath: indexPath)
        
        // Configure the cell...
        //cell.textLabel?.text = "Row number \(indexPath.row) in section \(indexPath.section)"
        if let theCell = cell as? MajorTableViewCell {
            let major = coursesSchema.getMajorForIndex(indexPath.row)
            theCell.useMajor(major, numCourses: coursesSchema.numCourses(major))
        }
        /*
        let course = coursesDS?.courseAt(indexPath.row)
        cell.textLabel?.text = course?.courseName()
        */
        
        return cell

    }


}
