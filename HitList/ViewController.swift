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
    
    // ****************************************************
    // ******************** UI CHANGES ********************
    // ****************************************************
                                                      //***
    @IBOutlet var selectedButtons: [UIView]!          //***
                                                      //***
    func selectAndDeselectButtons (index: Int) {      //***
        if selectedButtons[index].alpha == 0.0 {      //***
            selectedButtons[index].alpha = 1.0        //***
        }                                             //***
        else {                                        //***
            selectedButtons[index].alpha = 0.0        //***
        }                                             //***
    }                                                 //***
                                                      //***
    @IBAction func clickMon(sender: UIButton) {       //***
        selectAndDeselectButtons(0)                   //***
    }                                                 //***
    @IBAction func clickTues(sender: UIButton) {      //***
        selectAndDeselectButtons(1)                   //***
    }                                                 //***
    @IBAction func clickWed(sender: UIButton) {       //***
        selectAndDeselectButtons(2)                   //***
    }                                                 //***
    @IBAction func clickThurs(sender: UIButton) {     //***
        selectAndDeselectButtons(3)                   //***
    }                                                 //***
    @IBAction func clickFri(sender: UIButton) {       //***
        selectAndDeselectButtons(4)                   //***
    }                                                 //***
    @IBAction func clickSat(sender: UIButton) {       //***
        selectAndDeselectButtons(5)                   //***
    }                                                 //***
                                                      //***
    // ****************************************************
    // ******************** UI CHANGES ********************
    // ****************************************************
    
    // Ability to Change this url in the future would be nice
    // Address where the courses JSON is stored
    let downloadAssistant = Download(withURLString: "https://www.cs.sonoma.edu/~dscott/spring2016courses.json")
    var coursesSchema: CourseSchemaProcessor!
    
    // Version Variables
    let VersionGet = Download(withURLString: "https://www.cs.sonoma.edu/~dscott/version.json")
    var downloadNewData : Bool  = false
    var versionNumber : Float = 0.8
    var haveVersion : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Download version number from server
        
        // ******************************************
        // *************** UI CHANGES ***************
        // ******************************************
                                                //***
        for i in 0...5 {                        //***
            selectedButtons[i].alpha = 0.0      //***
        }                                       //***
                                                //***
        // ******************************************
        // *************** UI CHANGES ***************
        // ******************************************
        
        VersionGet.addObserver(self, forKeyPath: "dataFromServer", options: .Old, context: nil)
        VersionGet.download_request()
            }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(!haveVersion){
            // Get Version from web
            VersionGet.download_request()
            let version = DatabaseVersion(version: VersionGet.dataFromServer!)
            if (version.getVersion() != nil) {
                versionNumber = version.getVersion()!
            }
            
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
                VersionGet.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
                downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .Old, context: nil)
                downloadAssistant.download_request()
            }
        }
        else{ // if we have version number then go ahead
            coursesSchema = CourseSchemaProcessor(courseModelJSON: downloadAssistant.dataFromServer!)
        }
        if(downloadNewData){
            haveVersion = true
        }
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

