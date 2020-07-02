//
//  OilOrderTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/27.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class OilOrderTableViewCell: UITableViewCell {
    
    var timeLab :UILabel?
    var addLab : UILabel?
    var totalLab :UILabel?
    var nameArr :Array<Dictionary<String, Any>>? = nil
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
        self.contentView.backgroundColor = huiColor()
        let hui = UIView.init()
        hui.backgroundColor = huiColor()
        hui.frame = CGRect(x:0,y:0,width:WindowWidth,height:5)
        self.contentView.addSubview(hui)
        
        let whiteView = UIView.init()
        whiteView.frame = CGRect(x:0,y:5,width:WindowWidth,height:46)
        whiteView.backgroundColor = UIColor.white
        self.contentView.addSubview(whiteView)
        
        let siteImg = UIImageView.init()
        siteImg.frame = CGRect(x:23,y:16,width:24,height:25)
        siteImg.image = UIImage(named:"免费参观工地1")
        self.contentView.addSubview(siteImg)
        
        timeLab = UILabel()
        timeLab?.text = "申请时间：2017-09-15"
        timeLab?.textColor = UIColor.black
        timeLab?.frame = CGRect(x:63,y:23,width:WindowWidth,height:15)
        timeLab?.font = UIFont.systemFont(ofSize: 15)
        timeLab?.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        self.contentView.addSubview(timeLab!)
        
        addLab = UILabel()
        addLab?.text = "光谷8号工地"
        addLab?.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        addLab?.font = UIFont.systemFont(ofSize: 14)
        addLab?.frame = CGRect(x:26,y:61+5,width:WindowWidth,height:14)
//        self.contentView.addSubview(addLab!)
        
        totalLab = UILabel()
        totalLab?.text = "总数量：2000升"
        totalLab?.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        totalLab?.textAlignment = .right
        totalLab?.frame = CGRect(x:WindowWidth-70-20-20-150,y:5,width:150,height:46)
        self.contentView.addSubview(totalLab!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var OilOrderModel :OilOrderModel? {
        didSet {
            
            
//            timeLab?.text = "送油地址：" + (OilOrderModel?.province)! + (OilOrderModel?.county)! + (OilOrderModel?.city)!
            timeLab?.text =  (OilOrderModel?.name)!
            let m = OilOrderModel?.total
//            addLab?.text = "送油地址：" + (OilOrderModel?.province)! + (OilOrderModel?.county)! + (OilOrderModel?.city)!
            totalLab?.text =  (m?.description)! + "升"
            
            let callOilBtn = UIButton.init()
            callOilBtn.backgroundColor = homeColor()
            self.contentView.addSubview(callOilBtn)
            callOilBtn.layer.cornerRadius = 4
            callOilBtn.layer.masksToBounds = true
            //            callOilBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            callOilBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            //            callOilBtn.setTitle("申请叫油：" + (m?.description)! + "升", for: .normal)
            callOilBtn.setTitle("申请叫油", for: .normal)
            callOilBtn.frame = CGRect(x:WindowWidth-76-20,y:8+5,width:76,height:31)
//            callOilBtn.textAlignment = .center
            callOilBtn.titleLabel?.textColor = UIColor.white
            callOilBtn.addTarget(self, action: #selector(callOil), for: .touchUpInside)
            
            //self.nameArr = [["name":"张三","work":"挖掘机","oil":"申请叫油500升"],["name":"李四","work":"挖掘机","oil":"申请叫油500升"],["name":"王五","work":"挖掘机","oil":"申请叫油500升"]]
            self.nameArr = OilOrderModel?.list as! Array<Dictionary<String, Any>>?
            for index in 0..<(self.nameArr?.count)! {
                let dict :Dictionary<String,Any> = self.nameArr![index]
                let view :UIButton = UIButton.init(frame: CGRect(x:0,y:46+5+index*41,width:Int(WindowWidth),height:41))
                view.backgroundColor = UIColor.white
                view.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                view.tag = index
                self.contentView.addSubview(view)
                
                let nameLab:UILabel = UILabel.init(frame: CGRect(x:15,y:0,width:200,height:41))
                nameLab.text = dict["custNname"] as! String?
                nameLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
                nameLab.font = UIFont.systemFont(ofSize: 14)
                view.addSubview(nameLab)
                
                let workLab:UILabel = UILabel.init(frame: CGRect(x:94,y:0,width:70,height:46))
                workLab.text = dict["workType"] as! String?
                workLab.textColor = UIColor.black
                workLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
                workLab.font = UIFont.systemFont(ofSize: 14)
                view.addSubview(workLab)
                
                let positionLab:UILabel = UILabel.init(frame: CGRect(x:WindowWidth-200-26-13,y:0,width:200,height:41))
                let m = dict["oilQuantity"] as!Int
                let string = (m.description) + "升"
                let ranStr = (m.description)
                let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
                let str = NSString(string: string)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSForegroundColorAttributeName, value: homeColor(), range: theRange)
                attrstring.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: theRange)
                positionLab.attributedText = attrstring
                positionLab.font = UIFont.systemFont(ofSize: 14)
                positionLab.textAlignment = .right
                view.addSubview(positionLab)
                
                let hui1:UIView = UIView.init(frame: CGRect(x:WindowWidth-62,y:4,width:1,height:38))
                hui1.backgroundColor = homeColor()
//                view.addSubview(hui1)
                
                let phoBtn :UIButton = UIButton.init(frame: CGRect(x:WindowWidth-21-18,y:14,width:14,height:14))
                phoBtn.setImage(UIImage(named:"电话"), for: .normal)
//                view.addSubview(phoBtn)
                
                let hui2 :UIView = UIView.init(frame: CGRect(x:22,y:40,width:WindowWidth-44,height:1))
                hui2.backgroundColor = huiColor()
                view .addSubview(hui2)
                
                
            }
    
        }
    }
    func btnClick(btn:UIButton)  {
        let dict :Dictionary<String,Any> = self.nameArr![btn.tag]
        NotificationCenter.default.post(name: NSNotification.Name.init("deleteCell"), object: dict)
    }
    func callOil()  {
        NotificationCenter.default.post(name: NSNotification.Name.init("ClickCell"), object: OilOrderModel)
    }
}
