//
//  CourseSchemaProcessor.swift
//  HitList
//
//  Created by DJ on 4/19/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit
import CoreData

class CourseSchemaProcessor: NSObject {


    let courseModelJSONString: [AnyObject]
    let coreDataContext = CoreDataCommonMethods()


    init(courseModelJSON: [AnyObject]) {
        courseModelJSONString = courseModelJSON
        super.init()
        processJSON(courseModelJSON)
        /*
        fetchArtistWithName("Beatles, The")
        fetchAlbumWithID("97269")
        fetchAllAlbums()
*/
    }

    func processJSON(schema: [AnyObject]) {
        for entity in schema {
            if let payload = entity["payload"], let entity_name = entity["entity_name"] {
                let name = entity_name as! String
                let objects = payload as! [AnyObject]
                /*
                if name == "Artist" {
                    processArtistsJSON(objects)
                } else if name == "Album" {
                    processAlbumsJSON(objects)
                } else if name == "Track" {
                    processTracksJSON(objects)
                }
*/
            }
        }
    }
    
    
    func numCourses() -> Int{
        return 0
    }

}