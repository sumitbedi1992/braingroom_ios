//
//  BGSocialLearningTableCell.swift
//  brainGroom
//
//  Created by Vignesh Kumar on 11/11/17.
//  Copyright © 2017 CodeLiners. All rights reserved.
//

import UIKit

class BGSocialLearningTableCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblCollegeName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    
    @IBOutlet weak var userImage: UIButtonX!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
