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
    var downloadNewData : Bool  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let versionNumber : Float = 0.8
        // https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-nsuserdefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        // check if defaults has been set yet
        if((defaults.objectForKey("versionNumber")) != nil){
            // if version online is newer we want to download again
            if(versionNumber > defaults.objectForKey("versionNumber") as! Float ){
                defaults.setFloat(versionNumber, forKey: "versionNumber")
                downloadNewData = true
            }
        }
        else{ // if there is no version already then we want to download
            defaults.setFloat(versionNumber, forKey: "versionNumber")
            downloadNewData = true
        }
        
        if(downloadNewData){
            downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .Old, context: nil)
            downloadAssistant.download_request()
        }
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

