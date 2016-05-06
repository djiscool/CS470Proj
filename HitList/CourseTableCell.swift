//
//  CourseTableCell.swift
//  HitList
//
//  Created by DJ on 4/27/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cell_course: UILabel!
    
    @IBOutlet weak var cell_seats: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func useCourse(course: String, numSeats: Int?) { //
        cell_course.text = course
        if((numSeats) != nil){
            cell_seats.text = String(numSeats!)
        }

    }
    
}