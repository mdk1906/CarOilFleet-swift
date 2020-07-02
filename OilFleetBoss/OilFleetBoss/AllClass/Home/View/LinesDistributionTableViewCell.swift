//
//  LinesDistributionTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class LinesDistributionTableViewCell: UITableViewCell {
    
    var gongdiImg :UIImageView?
    var gongdiName :UILabel?
    var gongdiView:UIView?
    var nameArr :Array<Dictionary<String, Any>>? = nil
    var wokerModel :MyWorkerModel?
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
        gongdiView = UIView()
        self.contentView.addSubview(gongdiView!)
        gongdiView?.backgroundColor = huiColor()
        gongdiView?.snp.makeConstraints({ (make)->Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(40)
        })
        
        gongdiImg = UIImageView()
        gongdiImg?.image = UIImage(named:"免费参观工地")
        gongdiView?.addSubview(gongdiImg!)
        gongdiImg?.snp.makeConstraints({ (make)->Void in
            make.left.equalTo(23)
            make.top.equalTo(10)
            make.width.equalTo(21)
            make.height.equalTo(22)
        })
        
        gongdiName = UILabel()
        gongdiName?.text = "光谷8号工地"
        gongdiName?.textColor = homeColor()
        gongdiName?.font = UIFont.systemFont(ofSize: 15)
        gongdiView?.addSubview(gongdiName!)
        gongdiName?.snp.makeConstraints({ (make)->Void in
            make.left.equalTo(55)
            make.top.equalTo(0)
            make.width.equalTo(200)
            make.height.equalTo(40)
        })
        let titleLab2:UILabel = UILabel()
        titleLab2.text = "额度：20000元"
        titleLab2.textColor = homeColor()
        titleLab2.textAlignment = .right
        titleLab2.font = UIFont.systemFont(ofSize: 15)
        titleLab2.tag = 10000
        gongdiView?.addSubview(titleLab2)
        titleLab2.snp.makeConstraints { (make)->Void in
            make.top.equalTo(0)
            make.right.equalTo(-22)
            make.width.equalTo(200)
            make.height.equalTo(41)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tfInPut(tf:UITextField) {
        let dict :Dictionary<String,Any> = self.nameArr![tf.tag]
        let oilCardNum :String = dict["oilCardNum"] as! String
        let dic :[String : NSObject]  = [
            
            "money":tf.text! as NSObject,
            
            "inde" : tf.tag as NSObject,
            
            "oilCardNum":oilCardNum as NSObject
        ]
        NotificationCenter.default.post(name: NSNotification.Name.init("addMoney"), object: dic)

    }
    var LinesDistributionModel :LinesDistributionModel? {
        didSet {
            
            gongdiName?.text = LinesDistributionModel?.name
            let money  = Double((LinesDistributionModel?.balance)!)/100
            let titleLab :UILabel = self.contentView.viewWithTag(10000) as! UILabel
            titleLab.text = "额度：" + (money.description)
            
            self.nameArr = LinesDistributionModel?.list as! Array<Dictionary<String, Any>>?
            for index in 0..<(self.nameArr?.count)! {
                var dict :Dictionary<String,Any> = self.nameArr![index]
                let view :UIView = UIView.init(frame: CGRect(x:0,y:40+index*46,width:Int(WindowWidth),height:46))
                view.backgroundColor = UIColor.white
                self.contentView.addSubview(view)
                
                let nameLab:UILabel = UILabel.init(frame: CGRect(x:24,y:0,width:70,height:46))
                nameLab.text = dict["custNname"] as! String?
                nameLab.textColor = UIColor.black
                view.addSubview(nameLab)
                nameLab.font = UIFont.systemFont(ofSize: 14)
                
                let workLab:UILabel = UILabel.init(frame: CGRect(x:105,y:0,width:70,height:46))
                workLab.text = dict["oilCardNum"] as! String?
                workLab.textColor = UIColor.black
                view.addSubview(workLab)
                workLab.font = UIFont.systemFont(ofSize: 14)
                
                let positionLab:UILabel = UILabel.init(frame: CGRect(x:105+70,y:0,width:150,height:46))
                let m = dict["balance"] as!Int
                let mone  = Double(m)/100
                positionLab.text = "余额：" + (mone.description)
                positionLab.textColor = UIColor.black
                view.addSubview(positionLab)
                positionLab.font = UIFont.systemFont(ofSize: 14)
                
                let minBtn :UIButton = UIButton.init(frame: CGRect(x:WindowWidth-117-18,y:15,width:18,height:18))
                minBtn.setImage(UIImage(named:"减"), for: .normal)
                //view.addSubview(minBtn)
                
                let tf :UITextField = UITextField()
                tf.frame = CGRect(x:WindowWidth-12-60,y:8,width:60,height:32)
                tf.tag = index
//                _  = Double((LinesDistributionModel?.remittanceLimit)!)/100
                
                tf.text = ""
                dict["money"] = tf.text
                tf.layer.borderColor = homeColor().cgColor
                tf.layer.borderWidth = 1
                tf.font = UIFont.systemFont(ofSize: 13)
                tf.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
                view.addSubview(tf)
                LinesDistributionModel?.fenpeiMoney = tf.text!
                dict["mainOilCardNum"] = LinesDistributionModel?.oilCardNum
                NotificationCenter.default.post(name: NSNotification.Name.init("newMoney"), object: dict)
                
                let addBtn :UIButton = UIButton.init(frame: CGRect(x:WindowWidth-11-18,y:15,width:18,height:18))
                addBtn.setImage(UIImage(named:"加"), for: .normal)
                //view.addSubview(addBtn)
                
                let hui2 :UIView = UIView.init(frame: CGRect(x:0,y:45,width:WindowWidth,height:1))
                hui2.backgroundColor = huiColor()
                view .addSubview(hui2)
                
            }

        }
    }
}
