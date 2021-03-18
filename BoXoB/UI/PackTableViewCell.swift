//
//  PackTableViewCell.swift
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 6/3/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

import UIKit

class PackTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?

    override func prepareForReuse() {
        iconImage?.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
