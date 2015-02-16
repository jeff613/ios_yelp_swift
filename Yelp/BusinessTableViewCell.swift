//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Jianfeng Ye on 2/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    var business: Business?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var reviewNumLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dollarSignLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var CategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: Business) {
        business = data
        nameLabel.text = data.name
        thumbImageView.setImageWithURL(NSURL(string: data.thumbUrl))
        reviewImageView.setImageWithURL(NSURL(string: data.ratingImgUrl))
        reviewNumLabel.text = "\(data.ratingNum) Reviews"
        let distanceStr = String(format: "%.2f", data.distance)
        distanceLabel.text = "\(distanceStr) mi"
        addressLabel.text = data.address
        CategoryLabel.text = data.category
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
}
