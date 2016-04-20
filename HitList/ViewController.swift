//
//  ViewController.swift
//  HitList
//
//  Created by student on 4/1/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // Ability to Change this url in the future would be nice
    // Address where the courses JSON is stored
    let downloadAssistant = Download(withURLString: "https://www.cs.sonoma.edu/~dscott/spring2016courses.json")
    var coursesSchema: CourseSchemaProcessor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .Old, context: nil)
        downloadAssistant.download_request()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
                //print(downloadAssistant.dataFromServer!)
        coursesSchema = CourseSchemaProcessor(courseModelJSON: downloadAssistant.dataFromServer!)
    }
    
    deinit {
        downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
    }


    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

