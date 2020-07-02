//
//  MyCommissionTableViewCell.swift
//  CarOilFleetService
//
//  Created by mdk mdk on 2017/10/17.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyCommissionTableViewCell: UITableViewCell {

    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    var MyCommissionModel:MyCommissionModel?{
        didSet{
            timeLab.text = "时间：" + timeStampToString(timeStamp: (((MyCommissionModel?.createDate)!/1000).description))
            let mm = Float((MyCommissionModel?.total)!)/100
            
            moneyLab.text = "¥" + mm.description
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
