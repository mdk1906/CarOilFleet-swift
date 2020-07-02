//
//  MyConstructionTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyConstructionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var siteType: UILabel!
    @IBOutlet weak var siteName: UILabel!
    @IBOutlet weak var hui: UIView!
    @IBOutlet weak var deletebtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var construType: UILabel!
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
            siteName.text = MyConstructionModel?.name
            //           siteType.text = MyConstructionModel?.engStatus?.description
            
            if MyConstructionModel?.engStatus == 1 {
                siteType.text = "工程状态：已开工"
            }
            if MyConstructionModel?.engStatus == 2 {
                siteType.text = "工程状态：未开工"
            }
            switch MyConstructionModel?.engType?.description {
            case "1"?:
                construType.text = "工程类型：建筑"
            case "2"?:
                construType.text = "工程类型：装饰"
            case "3"?:
                construType.text = "工程类型：土方"
            case "4"?:
                construType.text = "工程类型：市政道路"
            case "5"?:
                construType.text = "工程类型：桥梁"
            case "6"?:
                construType.text = "工程类型：园林绿化"
            case "7"?:
                construType.text = "工程类型：节能环保"
            case "8"?:
                construType.text = "工程类型：铁路"
            case "9"?:
                construType.text = "工程类型：公路"
            case "10"?:
                construType.text = "工程类型：其他"
            default: break
                
            }
//            construType.text =  MyConstructionModel?.engType?.description
            startTime.text = "开工时间：" +  timeStampToString(timeStamp: (((MyConstructionModel?.startDate)!/1000).description))
        }
    }
    
}
