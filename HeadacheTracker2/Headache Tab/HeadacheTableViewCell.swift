//
//  HeadacheTableViewCell.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 4/28/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit

class HeadacheTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var medicationsLabel: UILabel!
    @IBOutlet weak var severityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
