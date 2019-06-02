//
//  SeverityTableViewCell.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 5/18/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit

class SeverityTableViewCell: UITableViewCell {

    @IBOutlet weak var severitySlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
