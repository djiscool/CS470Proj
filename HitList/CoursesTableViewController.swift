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
}
