//
//  Download.swift
//  HitList
//
//  Created by student on 4/6/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import Foundation
import UIKit

class Download: NSObject {
    
    let fvc: CoursesTableViewController
    
    init(fvc: CoursesTableViewController) {
        self.fvc = fvc
        super.init()
    }
    
    func toDict(json: String) {
        let JSONData = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let courses = try! NSJSONSerialization.JSONObjectWithData(JSONData!, options: []) as! [AnyObject]
        fvc.acceptData(CoursesDataSource(dataSource: courses))
    }
    
    func download_request()
    {
        // Change URL location  ---------vvvvvvvvvvvvvvv---------
        let url:NSURL = NSURL(string: "https://www.cs.sonoma.edu/~dscott/spring2016courses.json")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "data=Hello"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.downloadTaskWithRequest(request) {
            (
            let location, let response, let error) in
            
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let urlContents = try! NSString(contentsOfURL: location!, encoding: NSUTF8StringEncoding)
            
            guard let _:NSString = urlContents else {
                print("error")
                return
            }
            
            print(urlContents)
            self.toDict(urlContents as String)
            
        }
        
        task.resume()
        
    }
}