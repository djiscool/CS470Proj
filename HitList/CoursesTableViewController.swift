//
//  TableViewController.swift
//  HitList
//
//  Created by student on 4/6/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import Foundation
import UIKit

class CoursesTableViewController: UITableViewController {
    
    var coursesDS: CoursesDataSource?
    var download: Download?
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    func acceptData(dataSource: CoursesDataSource) {
        coursesDS = dataSource
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let n = coursesDS {
            return n.numCourses()
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseTableCell", forIndexPath: indexPath)
        
        // Configure the cell...
        //cell.textLabel?.text = "Row number \(indexPath.row) in section \(indexPath.section)"
        let course = coursesDS?.courseAt(indexPath.row)
        cell.textLabel?.text = course?.courseName()
        
        return cell
    }
}
