//
//  MyBillTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyBillTableViewCell: UITableViewCell {

    @IBOutlet weak var payType: UILabel!
    @IBOutlet weak var orderLab: UILabel!
    @IBOutlet weak var addLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    var MyBillModel:MyBillModel?{
        didSet{
            addLab.text = "订单单号：" + (MyBillModel?.orderId)!
            if MyBillModel?.orderType == 1{
                payType.text = "油卡支付"
            }
            else if MyBillModel?.orderType == 2{
                payType.text = "微信支付"
            }
            timeLab.text = "订单时间：" + timeStampToString(timeStamp: (((MyBillModel?.completeTime)!/1000).description))
            let money  = Double((MyBillModel?.cost)!)/100
            moneyLab.text = "¥" + (money.description)
            if MyBillModel?.province == nil{
                orderLab.text = "加油地点：油站支付"
            }else{
            orderLab.text = "加油地点：" + (MyBillModel?.province)! + (MyBillModel?.county)! + (MyBillModel?.city)! + (MyBillModel?.address)!
        }
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
