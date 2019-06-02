//
//  HeadacheMedicationTableViewCell.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 5/19/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit

class HeadacheMedicationTableViewCell: UITableViewCell {

    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var medicationDescriptionLabel: UILabel!
    @IBOutlet weak var medicationQuantityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
