

//
//  Download.swift
//  Navigation
//
//  Created by AAK on 3/10/16.
//  Copyright © 2016 SSU. All rights reserved.
//  copied from an example given by Dr Ali. Kooshesh at SSU for downloading a JSON from a server

import UIKit

class Download: NSObject {
    
    var urlString: String
    dynamic var dataFromServer: [AnyObject]?
    
    init(withURLString: String) {
        urlString = withURLString
        super.init()
    }
    
    func toDict(json: String) {
        let JSONData = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        dataFromServer = try! NSJSONSerialization.JSONObjectWithData(JSONData!, options: []) as! [AnyObject]
    }
    
    func download_request()
    {
        let url:NSURL = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        let task = session.downloadTaskWithRequest(request) {
            (let location, let response, let error) in
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let urlContents = try! NSString(contentsOfURL: location!, encoding: NSUTF8StringEncoding)
            
            guard let _:NSString = urlContents else {
                print("error")
                return
            }
            //            print(urlContents)
            self.toDict(urlContents as String)
        }
        
        task.resume()
        
    }
}