//
//  MyApplyTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/10/27.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyApplyTableViewCell: UITableViewCell {

    @IBOutlet weak var applyType: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    
    var MyApplymodel:MyApplymodel?{
        didSet{
           
            
           timeLab.text = timeStampToString(timeStamp: (((MyApplymodel?.createDate)!/1000).description))
            if MyApplymodel?.applyType == 0{
                //主卡
                applyType.text = "卡号：" + (MyApplymodel?.oilCardNum)!
                let money  = Double((MyApplymodel?.balance)!)/100
                print("money = ",money)
                moneyLab.text = "¥" + (money.description)
            }
            else if MyApplymodel?.applyType == 1{
                //分卡
                applyType.text = "卡号：" + (MyApplymodel?.oilCardNum)!
                let money  = Double((MyApplymodel?.money)!)/100
                print("money = ",money)
                moneyLab.text = "¥" + (money.description)
            }
            //applyType.text = MyApplymodel?.applyStatus?.description
            
        }
    }
    var MyOilCardListModel:MyOilCardListModel?{
        didSet{
            
            
            timeLab.text = timeStampToString(timeStamp: (((MyOilCardListModel?.createTime)!/1000).description))
            applyType.text = "申请人：" + (MyOilCardListModel?.custNname)!
//                let money  = Double((MyApplymodel?.cardCount)!)/100
            moneyLab.text = "申请数量：" + (MyOilCardListModel?.cardCount?.description)!
            
            //applyType.text = MyApplymodel?.applyStatus?.description
            
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
