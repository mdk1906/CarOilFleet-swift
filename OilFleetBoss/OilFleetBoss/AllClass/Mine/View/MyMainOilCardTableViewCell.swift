//
//  MyMainOilCardTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyMainOilCardTableViewCell: UITableViewCell {

    @IBOutlet weak var createDateLab: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var siteNameLab: UILabel!
    @IBOutlet weak var blanceLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var cardNum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var MyConstructionModel:MyConstructionModel? {
        didSet {
            backView.layer.cornerRadius = 5
            backView.layer.masksToBounds = true
           cardNum.text = MyConstructionModel?.oilCardNum
            nameLab.text = "" + (MyConstructionModel?.custNname)!
            let money  = Double((MyConstructionModel?.balance)!)/100
            blanceLab.text = "¥" + (money.description)
            siteNameLab.text = "" + (MyConstructionModel?.name)!
            createDateLab.text = "申请时间：" + timeStampToString(timeStamp: (((MyConstructionModel?.createDate)!/1000).description))
        }
    }

}
