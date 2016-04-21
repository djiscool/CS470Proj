//
//  CoreDataStore.swift
//  CoreDataForArtists
//
//  Created by AAK on 4/14/16.
//  Copyright © 2016 SSU. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStore: NSObject {
    
    // See https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html
    // for more information about the need for creating varible manageObjectModel.
    
    let storeName = "HitList"
    let storeFilename = "HitList.sqlite"
    
    lazy var applicationDocumentsDirectory: NSURL = {
        
        // Establish a path (url) to the application's document directory.
        // Gets path to where the database is
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    // acceses the database "graph"
    lazy var managedObjectModel: NSManagedObjectModel = {
        // Establish a pointer to DB Model that is defined in CoreDataForArtists.xcdatamodeld.
        if let modelURL = NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd") {
            return NSManagedObjectModel(contentsOfURL: modelURL)!
        }
        abort() // should do something more appropriate here...
    }()
    
    //coordinates access to database
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Create the coordinator and store configure it.
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.storeFilename)
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            NSLog("Unable to tie the store with the coordinator")
            abort()
        }
        
        return coordinator
    }()
}
