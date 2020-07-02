//
//  MyOilCardTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyOilCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workType: UILabel!
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var leijixiaofeiLab: UILabel!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var yueMoney: UILabel!
    @IBOutlet weak var oilCardNumLab: UILabel!
    
    var MyOilCardModel:MyOilCardModel?{
        didSet{
            backView.layer.cornerRadius = 4
            backView.layer.masksToBounds = true
            oilCardNumLab.text =  (MyOilCardModel?.oilCardNum)!
            let money  = Double((MyOilCardModel?.balance)!)/100
            yueMoney.text = "¥" + (money.description)
            if MyOilCardModel?.custNname != nil{
                nameLab.text = "姓名：" + (MyOilCardModel?.custNname)!
            }
            else{
                nameLab.text = "未绑定"
            }
            cardType.text = "绑定时间：" + timeStampToString(timeStamp: (((MyOilCardModel?.createDate)!/1000).description))
            let sumtotal  = Double((MyOilCardModel?.balance)!)/100
            leijixiaofeiLab.text = "累计消费：" + (sumtotal.description)
            workType.text = MyOilCardModel?.workType
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
