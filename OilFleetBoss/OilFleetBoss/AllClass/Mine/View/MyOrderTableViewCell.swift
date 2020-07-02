//
//  MyOrderTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var siteNameTitle: UILabel!
    @IBOutlet weak var xiadanName: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var oilQuantityLab: UILabel!
    @IBOutlet weak var siteNameLab: UILabel!
    
    var MyPlaceTheOrderModel :MyPlaceTheOrderModel?{
        didSet{
            siteNameLab.text = "下单时间：" + timeStampToString(timeStamp: (((MyPlaceTheOrderModel?.createDate)!/1000).description))
            siteNameLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            oilQuantityLab.text = "订单数量：" + (MyPlaceTheOrderModel?.oilQuantity?.description)! + "升"
            oilQuantityLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            timeLab.text = "送达时间：" + timeStampToString(timeStamp: (((MyPlaceTheOrderModel?.arriveDate)!/1000).description))
            timeLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            xiadanName.text = "下单人：" + (MyPlaceTheOrderModel?.custNname)!
            xiadanName.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            siteNameTitle.text = MyPlaceTheOrderModel?.name
            siteNameLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
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
