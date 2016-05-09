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


    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
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
        selectAndDeselectButtons(0)
        daysBool[0] = !daysBool[0]                    //***
    }                                                 //***
    @IBAction func clickTues(sender: UIButton) {      //***
        selectAndDeselectButtons(1)
        daysBool[1] = !daysBool[1]                    //***
    }                                                 //***
    @IBAction func clickWed(sender: UIButton) {       //***
        selectAndDeselectButtons(2)
        daysBool[2] = !daysBool[2]                    //***
    }                                                 //***
    @IBAction func clickThurs(sender: UIButton) {     //***
        selectAndDeselectButtons(3)                   //***
        daysBool[3] = !daysBool[3]                    //***
    }                                                 //***
    @IBAction func clickFri(sender: UIButton) {       //***
        selectAndDeselectButtons(4)                   //***
        daysBool[4] = !daysBool[4]                    //***
    }                                                 //***
    @IBAction func clickSat(sender: UIButton) {       //***
        selectAndDeselectButtons(5)                   //***
        daysBool[5] = !daysBool[5]                    //***
    }                                                 //***
                                                      //***
    // ****************************************************
    // ******************** UI CHANGES ********************
    // ****************************************************
    
    // [mon,tue,wed,thu,fri,sat]
    var daysBool: [Bool] = [false,false,false,false,false,false]
    
    // Ability to Change this url in the future would be nice
    // Address where the courses JSON is stored
    //let downloadAssistant = Download(withURLString: "https://www.cs.sonoma.edu/~dscott/spring2016courses.json")
    let downloadAssistant = Download(withURLString: "https://www.cs.sonoma.edu/~dscott/courses.json")

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
            
            //print(VersionGet.dataFromServer)
            print(version.getVersion())
            
            // https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-nsuserdefaults
            let defaults = NSUserDefaults.standardUserDefaults()
            // check if defaults has been set yet
            if(defaults.objectForKey("versionNumber") == nil){ // if there is no version already then we want to download
                defaults.setFloat(versionNumber, forKey: "versionNumber")
                downloadNewData = true
            }
            else if(versionNumber > defaults.objectForKey("versionNumber") as! Float ){
                    defaults.setFloat(versionNumber, forKey: "versionNumber")
                    downloadNewData = true
            }
            else {
                VersionGet.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
            }
            
            if(downloadNewData){
                VersionGet.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
                downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .Old, context: nil)
                downloadAssistant.download_request()
            }
        }
        else{ // if we have version number then go ahead
            coursesSchema = CourseSchemaProcessor(courseModelJSON: downloadAssistant.dataFromServer!)
            //print("numCourses: \(coursesSchema.numCourses())")
            //print("numCourses GEB2: \(coursesSchema.numCourses("GEB2"))")
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
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMajors" {
            /*
            if let row = tableView.indexPathForSelectedRow?.row {
            let artist = artistsDS?.artistAt(row)
            let detailedVC = segue.destinationViewController as! ArtistDetailedViewController
            detailedVC.artistForThisView(artist!)
            }
            */
            // OR
            /*
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let startTimeStr = dateFormatter.stringFromDate(startTime.date)
        
            let dateFormatter2 = NSDateFormatter()
            dateFormatter2.dateFormat = "HH:mm:ss"
            let endTimeStr = dateFormatter2.stringFromDate(endTime.date)
*/
            
            let detailedVC = segue.destinationViewController as! MajorsTableViewController

            detailedVC.receiveDataFromTimeView(daysBool, startTimeStr: startTime.date, endTimeStr: endTime.date)

            }
            
        }
        
        
    }



