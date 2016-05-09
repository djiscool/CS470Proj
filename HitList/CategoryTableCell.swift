//
//  CourseTableCell.swift
//  HitList
//
//  Created by DJ on 4/27/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//


import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var geText: UILabel!
    @IBOutlet weak var SectionText: UILabel!
    @IBOutlet weak var SeatsText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func useCategory(ge: String, numCourses: Int, numSeats: Int) { //
        
        geText.text = ge
        SectionText.text = String(numCourses)
        SeatsText.text = String(numSeats)
        
    }
    
}