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
    var startTime: NSDate?
    var endTime: NSDate?
    var dayString: String?
    var GE: String?
    var selectedGE: String?
    
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
        categorySchema.createGEarray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func receiveDataFromMajorView(days: String?, startTimeStr: NSDate, endTimeStr: NSDate) {
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
        
        if let n = categorySchema {
            return n.numGEs()
        }
        
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableCell", forIndexPath: indexPath)
        
        if let theCell = cell as? CategoryTableViewCell {
            let categoryGE = categorySchema.GeForIndex(indexPath.row)
            let categoryCoursesCount = categorySchema.numCoursesForGe(categoryGE)
            let categorySeatsCount = categorySchema.numSeatsForGe(categoryGE)
            theCell.useCategory(categoryGE, numCourses: categoryCoursesCount, numSeats: categorySeatsCount)
        }
        
        
        return cell
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedGE = categorySchema.GeForIndex(indexPath.row)
        performSegueWithIdentifier("ShowCourses", sender: self)

    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowCourses" {
            
            let detailedVC = segue.destinationViewController as! CoursesTableViewController
            
            detailedVC.recieveDataFromCategory(categorySchema.getDays(), startTimeStr: categorySchema.getStartTime(), endTimeStr: categorySchema.getEndTime(), selectedGE: selectedGE!)
            
        }
        
    }

    
    
}

