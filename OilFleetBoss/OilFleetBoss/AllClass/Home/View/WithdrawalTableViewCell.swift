//
//  WithdrawalTableViewCell.swift
//  OilFleetDelivery
//
//  Created by mdk mdk on 2018/4/28.
//  Copyright © 2018年 czt. All rights reserved.
//

import UIKit

class WithdrawalTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var orderIdLab: UILabel!
    @IBOutlet weak var siteLab: UILabel!
    @IBOutlet weak var oilNumLab: UILabel!
    @IBOutlet weak var infoLab: UILabel!
    @IBOutlet weak var orderNumLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var contectLab: UILabel!
    var WithdrawalModel:WithdrawalModel? {
        didSet {
            titleLab.text = "提成"
            let createTime = timeStampToString(timeStamp: ((WithdrawalModel?.completeTime)!/1000).description)
            timeLab.text = createTime
            orderIdLab.text = "订单号：" + (WithdrawalModel?.orderId)!
            siteLab.text = "工地：" + (WithdrawalModel?.engineeringName)!
            oilNumLab.text = "加油数量：" + (WithdrawalModel?.litre?.description)! + "升"
            let money  = Double((WithdrawalModel?.shippingFee)!)/100
            countLab.text = "+" + money.description
            orderNumLab.text = "下单数量：" + (WithdrawalModel?.oilQuantity?.description)! + "升"
            let money2 = Double((WithdrawalModel?.cost)!)!/100
            moneyLab.text = "加油金额：¥" + money2.description
            infoLab.isHidden = true
        }
    }
    var IntegralWithdrawalModel:IntegralWithdrawalModel? {
        didSet {
            titleLab.text = "积分"
            let createTime = timeStampToString(timeStamp: ((IntegralWithdrawalModel?.completeTime)!/1000).description)
            timeLab.text = createTime
            orderIdLab.text = "订单号：" + (IntegralWithdrawalModel?.orderId)!
            siteLab.text = "用户名：" + (IntegralWithdrawalModel?.custNname)!
            oilNumLab.text = "加油数量：" + (IntegralWithdrawalModel?.litre?.description)! + "升"
            let money  = Double((IntegralWithdrawalModel?.score)!)/100
            countLab.text = "+" + money.description
            orderNumLab.text = "隶属关系：" + (IntegralWithdrawalModel?.level?.description)! + "级"
            let money2 = Double((IntegralWithdrawalModel?.cost)!)!/100
            moneyLab.text = "加油金额：¥" + money2.description
            infoLab.isHidden = true
            contectLab.text = "工地：" + (IntegralWithdrawalModel?.engineeringName)!
        }
    }
    var CommissionWithdrawalModel:CommissionWithdrawalModel? {
        didSet {
            titleLab.text = "佣金"
            let createTime = timeStampToString(timeStamp: ((CommissionWithdrawalModel?.completeTime)!/1000).description)
            timeLab.text = createTime
            orderIdLab.isHidden = true
            siteLab.text = "用户名：" + (CommissionWithdrawalModel?.custNname)!
            let money4 = Double((CommissionWithdrawalModel?.phoneReg)!)/100
            oilNumLab.text = "手机注册：¥" + money4.description
            let money  = Double((CommissionWithdrawalModel?.total)!)/100
            countLab.text = "+" + money.description
            orderNumLab.text = "类型：" + (CommissionWithdrawalModel?.workType)!
            let money2 = Double((CommissionWithdrawalModel?.userOrder)!)/100
            moneyLab.text = "加油金额：¥" + money2.description
            let money3 = Double((CommissionWithdrawalModel?.info)!)/100
            infoLab.text = "完善类型：¥" + money3.description
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
