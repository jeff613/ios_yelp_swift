//
//  FilterTableViewCell.swift
//  Yelp
//
//  Created by Jianfeng Ye on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterSwitchDelegate {
    func onFilterSwitchValueChanged(cell: FilterTableViewCell, value: Bool)
}

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    
    var delegate: FilterSwitchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchValueChanged(sender: AnyObject) {
        delegate?.onFilterSwitchValueChanged(self, value: filterSwitch.on)
    }
}
