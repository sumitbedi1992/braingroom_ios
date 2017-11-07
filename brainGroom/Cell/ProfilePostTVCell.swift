//
//  ProfilePostTVCell.swift
//  brainGroom
//
//  Created by Gaurav Parmar on 28/10/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit

class ProfilePostTVCell: UITableViewCell {

    
    var onlikeTapped : ((_ indexTapped : Int) -> Void)? = nil
    var onCommentTapped : ((_ indexTapped : Int) -> Void)? = nil
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var collegeLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var segmentLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentsCountLbl: UILabel!
    
    @IBOutlet weak var likeCountbtn: UIButton!
    @IBOutlet weak var commentsCountbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func liveClicked(sender: UIButton) {
        if let onlikeTapped = self.onlikeTapped {
            onlikeTapped(sender.tag)
        }
    }
    
    @IBAction func commentClicked(sender: UIButton) {
        if let onCommentTapped = self.onCommentTapped {
            onCommentTapped(sender.tag)
        }
    }

}
