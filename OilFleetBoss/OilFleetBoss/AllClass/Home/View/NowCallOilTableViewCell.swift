//
//  NowCallOilTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class NowCallOilTableViewCell: UITableViewCell {

    var titleLab:UILabel?
    var workNameLab:UILabel?
    var oilLab:UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let view :UIView = UIView.init(frame: CGRect(x:0,y:0,width:Int(WindowWidth),height:46))
        view.backgroundColor = UIColor.white
        self.contentView.addSubview(view)
        
        let nameLab:UILabel = UILabel.init(frame: CGRect(x:24,y:0,width:70,height:46))
        nameLab.text = "张三"
        nameLab.font = UIFont.systemFont(ofSize: 14)
        nameLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        nameLab.tag = 10
        view.addSubview(nameLab)
        
        let workLab:UILabel = UILabel.init(frame: CGRect(x:94,y:0,width:70,height:46))
        workLab.text = "挖掘机"
        workLab.textColor = UIColor.black
        //view.addSubview(workLab)
        
        let positionLab:UILabel = UILabel.init(frame: CGRect(x:94+70,y:0,width:150,height:46))
        positionLab.text = "申请叫油500升"
        positionLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        positionLab.font = UIFont.systemFont(ofSize: 14)
        positionLab.tag = 11
        view.addSubview(positionLab)
        
        let hui1:UIView = UIView.init(frame: CGRect(x:WindowWidth-62,y:4,width:1,height:38))
        hui1.backgroundColor = homeColor()
        view.addSubview(hui1)
        
        let phoBtn :UIButton = UIButton.init(frame: CGRect(x:WindowWidth-21-18,y:14,width:14,height:14))
        phoBtn.setImage(UIImage(named:"电话"), for: .normal)
        view.addSubview(phoBtn)
        
        let hui2 :UIView = UIView.init(frame: CGRect(x:0,y:45,width:WindowWidth,height:1))
        hui2.backgroundColor = huiColor()
        view .addSubview(hui2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var NowCallOilModel :NowCallOilModel? {
        didSet {
            let nameLab :UILabel = self.contentView.viewWithTag(10) as! UILabel
            let positionLab :UILabel = self.contentView.viewWithTag(11) as! UILabel
            nameLab.text = NowCallOilModel?.custNname
            let m = NowCallOilModel?.oilQuantity
            positionLab.text = "申请叫油" + (m?.description)! + "升"
        }
    }
}
