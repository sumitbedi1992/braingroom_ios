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
    
    @IBOutlet weak var btnLiked: UIButton!
    
    @IBOutlet weak var lblLikedCount: UILabel!
    
    @IBOutlet weak var btnCommentedcount: UIButton!
    @IBOutlet weak var lblCommentedCount: UILabel!
    
    @IBOutlet weak var btnShareAction: UIButton!
    @IBOutlet weak var btnLikeAction: UIButton!
    @IBOutlet weak var btnCommentAction: UIButton!
    @IBOutlet weak var lblLike: UILabel!
    
    @IBOutlet weak var lblComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var onlikeTapped : ((_ indexTapped : Int) -> Void)? = nil
    var onCommentTapped : ((_ indexTapped : Int) -> Void)? = nil
    
//    @IBAction func liveClicked(_ sender: UIButton) {
//        if let onlikeTapped = self.onlikeTapped {
//            onlikeTapped(sender.tag)
//        }
//    }
//    
//    @IBAction func commentClicked(_ sender: UIButton) {
//        if let onCommentTapped = self.onCommentTapped {
//            onCommentTapped(sender.tag)
//        }
//    }
//    

}
