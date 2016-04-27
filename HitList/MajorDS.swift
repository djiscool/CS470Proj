//
//  MajorDS.swift
//  HitList
//
//  Created by DJ on 4/26/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import Foundation
import UIKit

class MajorDS: NSObject {
    
    var majors: [AnyObject]
    
    init(dataSource: [AnyObject]) {
        albums = dataSource
        super.init()
    }
    
    func numAlbums() -> Int{
        return albums.count
    }
    
    func AlbumAt(index: Int) -> Album {
        //print("index requested:  \(index)")
        let album = Album( album: albums[index] )
        return album
    }
    
    func filterByArtistId(artId: Int){
        albums = albums.filter({$0["artist_id"] as! Int == artId})
    }
    
}