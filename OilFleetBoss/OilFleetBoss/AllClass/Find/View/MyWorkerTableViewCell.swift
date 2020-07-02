//
//  MyWorkerTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/26.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyWorkerTableViewCell: UITableViewCell {
    var phoNum :String?
    //电话图片
    @IBOutlet weak var phoneImg: UIImageView!
    //工地名字
    @IBOutlet weak var addLab: UILabel!
    //选择btn
    @IBOutlet weak var xuanzhongBtn: UIButton!
    //姓名
    @IBOutlet weak var nameLab: UILabel!

    
    
    var MyWorkerModel:MyWorkerModel? {
        didSet {
            nameLab.text = MyWorkerModel?.custNname
            nameLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            addLab.text = MyWorkerModel?.workType
            addLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            phoNum = MyWorkerModel?.custPhone
            if workerXuanZe == "未编辑"{
                MyWorkerModel?.xuanzhong = "0"
            }
            if workerXuanZe == "编辑"{
                MyWorkerModel?.xuanzhong = "2"
            }
            print(MyWorkerModel?.xuanzhong! as Any)
            if MyWorkerModel?.xuanzhong == "0"{
                xuanzhongBtn.isHidden = true
            }
            else if MyWorkerModel?.xuanzhong == "1"{
                xuanzhongBtn.isHidden = false
                xuanzhongBtn.setImage(UIImage.init(named: "选中"), for: .normal)
            }
            else if MyWorkerModel?.xuanzhong == "2"{
                xuanzhongBtn.isHidden = false
                xuanzhongBtn.setImage(UIImage.init(named: "未选中"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        xuanzhongBtn.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
