//
//  MineTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/25.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MineTableViewCell: UITableViewCell {

    @IBOutlet weak var hui: UIView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var rightImg: UIImageView!
    
    @IBOutlet weak var leftImg: UIImageView!
    var MineModel:MineModel? {
        didSet {
            titleLab.text = MineModel?.title
            titleLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            leftImg.image = UIImage(named:(MineModel?.leftImg)!)
//            titleLab.text = "我的油卡"
        }
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
