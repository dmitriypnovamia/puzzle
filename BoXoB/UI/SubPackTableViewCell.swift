//
//  SubPackTableViewCell.swift
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 6/3/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

import UIKit

class SubPackTableViewCell: UITableViewCell {

    //@IBOutlet var packNameLbl : UILabel?
    @IBOutlet var subPackNameLbl : UILabel?
    @IBOutlet var descriptionLbl : UILabel?
    @IBOutlet var imgView : UIImageView?
    @IBOutlet var buyBtn : UIButton?
    @IBOutlet var bgView : UIView?
    @IBOutlet var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // bgView?.layer.cornerRadius = 10.0
        //bgView?.layer.masksToBounds = true
        //bgView?.style()
        bgView?.backgroundColor = .clear
        // Initialization code
    }
    override func prepareForReuse() {
        imgView?.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
