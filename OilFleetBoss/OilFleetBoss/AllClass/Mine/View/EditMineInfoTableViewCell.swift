//
//  EditMineInfoTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/11.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class EditMineInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var rightImg: UIImageView!
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    
    var MineModel:MineModel? {
        didSet {
            titleLab.text = MineModel?.title
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
