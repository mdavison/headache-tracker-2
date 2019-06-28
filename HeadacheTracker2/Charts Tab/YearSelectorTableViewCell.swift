//
//  YearSelectorTableViewCell.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 6/25/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit

class YearSelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
