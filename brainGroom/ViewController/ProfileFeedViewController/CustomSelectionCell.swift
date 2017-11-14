//
//  CustomSelectionCell.swift
//  brainGroom
//
//  Created by Keyur on 14/11/17.
//  Copyright © 2017 CodeLiners. All rights reserved.
//

import UIKit

class CustomSelectionCell: UITableViewCell {

    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
