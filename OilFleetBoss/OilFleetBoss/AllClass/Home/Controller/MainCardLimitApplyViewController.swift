//
//  MainCardLimitApplyViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import Alamofire
class MainCardLimitApplyViewController: MDKBaseViewController {
    
    var topConstraint: Constraint? //登录框距顶部距离约束
    var post : MyConstructionModel?
    var moneyStr:String?
    var siteData = [MyConstructionModel]()
    var titleLab :UILabel?
    var cardIdLab :UILabel?
    var nameLab :UILabel?
    var cardIdStr : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "主卡额度申请"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        cardIdStr = ""
        self.rightBtn?.setTitle("申请进度", for: .normal)
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func createUI() {
        let choseSiteBtn :UIButton = UIButton.init()
        self.view.addSubview(choseSiteBtn)
        choseSiteBtn.layer.contentsScale = 4
        choseSiteBtn.layer.masksToBounds = true
//        choseSiteBtn.addTarget(self, action: #selector(choseSite), for: .touchUpInside)
        choseSiteBtn.snp.makeConstraints { (make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(64+43)
            make.height.equalTo(94)
        }
        let backView = UIView.init()
        backView.backgroundColor = huiColor()
        self.view.addSubview(backView)
        backView.snp.makeConstraints { (make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(64)
            make.height.equalTo(43)
        }
        let cardImg :UIImageView = UIImageView.init(image: UIImage(named:"卡-1"))
        backView.addSubview(cardImg)
        cardImg.snp.makeConstraints { (make)->Void in
            make.top.equalTo(14)
            make.left.equalTo(self.view).offset(14)
            make.width.equalTo(21)
            make.height.equalTo(16)
        }
        
        let cardTitle = UILabel.init()
        cardTitle.text = "主卡选择"
        cardTitle.textColor = homeColor()
        cardTitle.font = UIFont.systemFont(ofSize: 15)
        backView.addSubview(cardTitle)
        cardTitle.snp.makeConstraints { (make)->Void in
            make.left.equalTo(cardImg.snp.right).offset(6)
            make.height.equalTo(15)
            make.width.equalTo(200)
            make.top.equalTo(15)
        }
        
        let choseBtn = UIButton.init()
        choseBtn.setTitle("更多主卡", for: .normal)
        choseBtn.setTitleColor(UIColor.white, for: .normal)
        choseBtn.layer.cornerRadius = 4
        choseBtn.layer.masksToBounds = true
        choseBtn.backgroundColor = homeColor()
        choseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        choseBtn.addTarget(self, action: #selector(choseSite), for: .touchUpInside)
        backView.addSubview(choseBtn)
        choseBtn.snp.makeConstraints { (make)->Void in
            make.right.equalTo(-14)
            make.top.equalTo(6)
            make.height.equalTo(31)
            make.width.equalTo(81)
        }
        titleLab  = UILabel.init()
        titleLab?.text =  ((self.post?.name!)! as String)
        titleLab?.font = UIFont.systemFont(ofSize: 15)
        choseSiteBtn.addSubview(titleLab!)
        titleLab?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(14)
            make.top.equalTo(12)
            make.height.equalTo(15)
            make.width.equalTo(200)
        }
        titleLab?.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        cardIdStr = self.post?.oilCardNum!
        cardIdLab  = UILabel.init()
        cardIdLab?.text = "负责人：" +  ((self.post?.custNname!)! as String)
        cardIdLab?.font = UIFont.systemFont(ofSize: 13)
        cardIdLab?.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        choseSiteBtn.addSubview(cardIdLab!)
        cardIdLab?.snp.makeConstraints { (make) ->Void in
            make.left.equalTo(14)
            make.top.equalTo((titleLab?.snp.bottom)!).offset(14)
            make.height.equalTo(13)
            make.width.equalTo(200)
        }
        nameLab  = UILabel.init(frame: CGRect(x:19,y:17,width:WindowWidth,height:14))
        nameLab?.text = "主卡卡号：" + cardIdStr!
        nameLab?.font = UIFont.systemFont(ofSize: 13)
        nameLab?.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        choseSiteBtn.addSubview(nameLab!)
        nameLab?.snp.makeConstraints { (make) ->Void in
            make.top.equalTo((cardIdLab?.snp.bottom)!).offset(14)
            make.left.equalTo(self.view).offset(14)
        }
        //
        //
        let hui = UIView.init()
        hui.backgroundColor = huiColor()
        choseSiteBtn.addSubview(hui)
        hui.snp.makeConstraints { (make)->Void in
            make.left.equalTo(13)
            make.bottom.equalTo(-1)
            make.height.equalTo(1)
            make.right.equalTo(-13)
        }
        
        let chongzhiImg :UIImageView = UIImageView.init(image: UIImage(named:"充值"))
        self.view.addSubview(chongzhiImg)
        chongzhiImg.snp.makeConstraints { (make)->Void in
            make.top.equalTo(choseSiteBtn.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(14)
            make.width.equalTo(24)
            make.height.equalTo(16)
        }
        //
        //
        let chongzhiLab :UILabel = UILabel.init(frame: CGRect(x:19,y:17,width:WindowWidth,height:15))
        chongzhiLab.text = "申请充值额度"
        chongzhiLab.font = UIFont.systemFont(ofSize: 15)
        chongzhiLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        self.view.addSubview(chongzhiLab)
        chongzhiLab.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(choseSiteBtn.snp.bottom).offset(19)
            make.left.equalTo(chongzhiImg.snp.right).offset(8)
        }
        //
        //
        let tf :UITextField = UITextField()
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = homeColor().cgColor
        tf.layer.borderWidth = 1
        tf.placeholder = "请输入金额"
        tf.delegate = self
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.keyboardType = .numberPad
        self.view.addSubview(tf)
        tf.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
        tf.snp.makeConstraints { (make)-> Void in
        make.top.equalTo(chongzhiLab.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(45)
            make.right.equalTo(self.view).offset(-45)
            make.height.equalTo(46)
            
        }
        //
        //
        let shuomingLab :UILabel = UILabel.init(frame: CGRect(x:WindowWidth-40-300,y:0,width:300,height:11))
        shuomingLab.textAlignment = .right
        shuomingLab.text = "审核通过后预计两小时到账"
        self.view.addSubview(shuomingLab)
        shuomingLab.font = UIFont.systemFont(ofSize: 11)
        shuomingLab.snp.makeConstraints { (make)-> Void in
            make.top.equalTo(tf.snp.bottom).offset(10)
            make.right.equalTo(-47)
            make.width.equalTo(200)
            make.height.equalTo(11)
        }
        //
        //
        let moneyLab:UILabel = UILabel.init(frame: CGRect(x:0,y:0,width:WindowWidth,height:75))
        moneyLab.text = "¥0.00"
        moneyLab.textAlignment = .center
        moneyLab.font = UIFont.systemFont(ofSize: 75)
        moneyLab.textColor = kRGBColorFromHex(rgbValue: 0xFF8900)
        self.view.addSubview(moneyLab)
        moneyLab.tag = 1000
        moneyLab.snp.makeConstraints { (make)-> Void in
            make.top.equalTo(shuomingLab.snp.bottom).offset(60)
            make.width.equalTo(WindowWidth)
            
        }
        //
        //
        let tijiaoBtn :UIButton = UIButton.init(frame: CGRect(x:21,y:0,width:(WindowWidth-21)/2,height:40))
        tijiaoBtn.backgroundColor = homeColor()
        tijiaoBtn.layer.masksToBounds = true
        tijiaoBtn.layer.cornerRadius = 4
        tijiaoBtn.setTitle("立即提交", for: .normal)
        tijiaoBtn.addTarget(self, action:#selector(btnClick) , for: .touchUpInside)
        self.view.addSubview(tijiaoBtn)
        tijiaoBtn.setTitleColor(UIColor.white, for: .normal)
        tijiaoBtn.snp.makeConstraints { (make)->Void in
            make.bottom.equalTo(self.view).offset(-50)
            make.left.equalTo(self.view).offset(25)
            make.right.equalTo(self.view).offset(-25)
            make.height.equalTo(40)
        }
    }
    
    func btnClick(btn:UIButton)  {
        if moneyStr == nil{
            loadFailure(msg: "请输入金额")
        }
        else{
            let url = BASE_URL + k_applyBlance
            
            let params:Dictionary = ["custId":custId,"oilCardNum":self.cardIdStr,"balance":moneyStr]
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                }
            }, to:url,headers :["devType":"1","token":OilValue.shared.token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                    })
                    upload.responseJSON { response in
                        if let value:NSDictionary = response.result.value as! NSDictionary? {
                            let dict = JSON(value)
                            if dict["ret"].intValue == 1 {
                                loadSuccess()
                                //成功
                                print("JSON: \(value)")
                                let data = dict["data"].dictionaryValue
                                let vc = LinesApplySuccessViewController()
                                vc.cardStr = data["oilCardNum"]?.stringValue
                                vc.moneyStr = data["money"]?.stringValue
                                vc.siteStr = ((self.post?.name!)! as String)
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                            else{
                                //失败
                                loadFailure(msg : value["msg"] as!String)
                                print("JSON: \(value)()")
                            }
                        }
                    }
                    
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                }
                
            }
        }
        
        
    }
    func getData()  {
        let url = BASE_URL + k_siteList
        //"token":token,
        let params:Dictionary = ["custId":custId,"offset":"0","limit":"15"]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
            }
        }, to:url,headers :["devType":"1","token":OilValue.shared.token])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    if let value:NSDictionary = response.result.value as! NSDictionary? {
                        let dict = JSON(value)
                        if dict["ret"].intValue == 1 {
                            loadSuccess()
                            //成功
                            print("JSON: \(value)")
                            let items = dict["data"].arrayObject
                            if ((items?.count)! > 0) {
                                self.post = MyConstructionModel(dict: items?[0] as! [String: AnyObject])
                                self.createUI()
                            }
                            if let items = dict["data"].arrayObject {
                                for item in items {
                                    let post = MyConstructionModel(dict: item as! [String: AnyObject])
                                    self.siteData.append(post)
                                }
                            }
                            else{
                                let alertVC = UIAlertController(title: "提示", message: "您还没有主卡，请先创建工地", preferredStyle: UIAlertControllerStyle.alert)
                                let acSure = UIAlertAction(title: "跳转", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
                                    //我的工地
                                    let vc = MyConstructionViewController()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
                                    print("click Cancel")
                                }
                                alertVC.addAction(acSure)
                                alertVC.addAction(acCancel)
                                self.present(alertVC, animated: true, completion: nil)
                            }
                            
                        }
                        else{
                            //失败
                            loadFailure(msg : value["msg"] as!String)
                            print("JSON: \(value)()")
                        }
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
    }
    func tfInPut(tf:UITextField)  {
        let moneyLab :UILabel = self.view.viewWithTag(1000) as! UILabel
        let money = tf.text!
        if money .characters.count == 0 {
            moneyLab.text = "¥ 0.0"
        }
        else{
            
            let doub = Double(money)
            print(doub!)
            let mo2 = doub!*100
            print(mo2)
            //            moneyStr = mo2.description
            let b:CharacterSet=NSCharacterSet(charactersIn:".") as CharacterSet
            
            moneyStr = (mo2.description.components(separatedBy: b))[0].description
            print(moneyStr!)
            moneyLab.text = "¥" + (doub?.description)!
        }
        
    }
    func choseSite()  {
        var siteNameArr = [String]()
        var siteIdArr = [Int]()
        var nameArr = [String]()
        var cardNumArr = [String]()
        if self.siteData.count == 0{
            let alertVC = UIAlertController(title: "提示", message: "您还没有主卡，请先创建工地", preferredStyle: UIAlertControllerStyle.alert)
            let acSure = UIAlertAction(title: "跳转", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
                //我的工地
                let vc = MyConstructionViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
                print("click Cancel")
            }
            alertVC.addAction(acSure)
            alertVC.addAction(acCancel)
            self.present(alertVC, animated: true, completion: nil)
        }else{
            for model in self.siteData {
                siteNameArr.append(model.name!)
                siteIdArr.append(model.uid!)
                nameArr.append(model.custNname!)
                cardNumArr.append(model.oilCardNum!)
            }
            let onePicker = JHPickerView.init(aDataSource: siteNameArr, aTitle: "请选择主卡")
            
            onePicker.show()
            onePicker.showSelectedRow(3, animated: true)
            onePicker.didClickDoneForTypeAloneHandler { (selectedRow, result) in
                print("selectedRow:\(selectedRow)")
                print("result:\(result)")
                self.titleLab?.text =   siteNameArr[selectedRow]
                self.cardIdStr = cardNumArr[selectedRow]
                self.cardIdLab?.text = "负责人：" + nameArr[selectedRow]
                self.nameLab?.text = "主卡卡号：" + self.cardIdStr!
            }
            onePicker.didClickCancelHandler {
                print("dismiss")
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            guard let text = textField.text else{
                return true
            }
            
            let textLength = text.characters.count + string.characters.count - range.length
            
            return textLength<=6
        
        
    }
    override func rightEvent() {
        let vc = MyOrderViewController()
        vc.applyType = "0"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
