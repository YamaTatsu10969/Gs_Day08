//
//  CustomCell.swift
//  GsTodo
//
//  Created by yamamototatsuya on 2020/01/16.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
