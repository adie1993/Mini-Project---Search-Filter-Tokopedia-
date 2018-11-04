//
//  ShopTypeTableViewCell.swift
//  TestTokped
//
//  Created by WGS-LAP189 on 04/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import UIKit

class ShopTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var lblType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
