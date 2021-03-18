//
//  PuzzleCollectionViewCell.swift
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 6/3/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

import UIKit

class PuzzleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView : UIImageView?
    @IBOutlet weak var nameLbl : UILabel?
    @IBOutlet weak var solvedStatusImage : UIImageView?
    @IBOutlet weak var transparentView : UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        imgView?.image = nil
        transparentView?.style()
    }

}

class LevelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView : UIImageView?
    @IBOutlet weak var nameLbl : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        imgView?.image = nil
    }
    
}

class GrayLevelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl : UILabel?
    @IBOutlet weak var imgView : UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
    }
    
}
