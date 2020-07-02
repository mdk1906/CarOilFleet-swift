//
//  WithdrawalRecordTableViewCell.swift
//  OilFleetDelivery
//
//  Created by mdk mdk on 2018/4/28.
//  Copyright © 2018年 czt. All rights reserved.
//

import UIKit

class WithdrawalRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var orderLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var finishTimeLab: UILabel!
    @IBOutlet weak var typeImg: UIImageView!
    var WithdrawalRecordModel:WithdrawalRecordModel? {
        didSet {
            let create = timeStampToString(timeStamp: ((WithdrawalRecordModel?.createDate)!/1000).description)
            let money4 = Double((WithdrawalRecordModel?.total)!)/100
            
            moneyLab.text = "提现积分：（金额" + money4.description + "元）"
            createTime.text = "申请时间" + create.description
            
            if WithdrawalRecordModel?.status == 1 {
                //未审核
                finishTimeLab.text = "暂无"
            }
            else if WithdrawalRecordModel?.status == 2 {
                //通过
                typeImg.image = UIImage(named:"")
                let finishtime = timeStampToString(timeStamp: ((WithdrawalRecordModel?.completeDate)!/1000).description)
                finishTimeLab.text = finishtime.description
            }
            else if WithdrawalRecordModel?.status == 3 {
                //驳回
                typeImg.image = UIImage(named:"")
                let finishtime = timeStampToString(timeStamp: ((WithdrawalRecordModel?.completeDate)!/1000).description)
                finishTimeLab.text = finishtime.description
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
