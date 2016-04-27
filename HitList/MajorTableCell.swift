//
//  MajorTableCell.swift
//  HitList
//
//  Created by DJ on 4/26/16.
//  Copyright © 2016 Sonoma State. All rights reserved.
//

import UIKit

class MajorTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var MajorTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func useMajor(major: String, numCourses: Int) { //
        
        let cellText = "\(major) (\(numCourses))"
        MajorTitle.text = cellText

    }
    
}