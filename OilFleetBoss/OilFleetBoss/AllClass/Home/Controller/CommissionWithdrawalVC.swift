//
//  CommissionWithdrawalVC.swift
//  OilFleetDelivery
//
//  Created by mdk mdk on 2018/4/28.
//  Copyright © 2018年 czt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class CommissionWithdrawalVC: MDKBaseListViewController {
    var data  = [CommissionWithdrawalModel]()
    var money:String?
    var count :String?
    var invateCode :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        money = ""
        self.getStateData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI()  {
        self.titleX?.text = "提现"
        cellID = "WithdrawalTableViewCell"
        tableView?.frame = CGRect(x:0,y:64,width:WindowWidth,height:WindowHeight-64)
        let nib = UINib(nibName: String(describing: WithdrawalTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        self.rightBtn?.setTitle("提现记录", for: .normal)
        
        let headView = UIView.init()
        headView.frame = CGRect(x:0,y:0,width:WindowWidth,height:312+57)
        self.tableView?.tableHeaderView = headView
        headView.backgroundColor = UIColor.white
        
        let hui = UIView.init()
        hui.frame = CGRect(x:0,y:0,width:WindowWidth,height:8)
        hui.backgroundColor = huiColor()
        headView.addSubview(hui)
        
        let cashImg = UIImageView.init()
        cashImg.image = UIImage(named:"提现")
        cashImg.frame = CGRect(x:20,y:16+8,width:30,height:20)
        headView.addSubview(cashImg)
        
        let titleLab = UILabel.init()
        titleLab.frame = CGRect(x:60,y:18+8,width:WindowWidth,height:15)
        titleLab.text = "可提现金额（元）"
        titleLab.font = UIFont.systemFont(ofSize: 15)
        titleLab.textColor = fontColor()
        headView.addSubview(titleLab)
        
        let moneyLab = UILabel.init()
        moneyLab.frame = CGRect(x:0,y:58+8,width:WindowWidth,height:25)
        moneyLab.text = "¥" + count!
        moneyLab.font = UIFont.systemFont(ofSize: 25)
        moneyLab.textColor = homeColor()
        moneyLab.textAlignment = .center
        headView.addSubview(moneyLab)
        
        let hui2 = UIView.init()
        hui2.frame = CGRect(x:0,y:95+8,width:WindowWidth,height:1)
        hui2.backgroundColor = huiColor()
        headView.addSubview(hui2)
        
        let tixianMoneyLab = UILabel.init()
        tixianMoneyLab.frame = CGRect(x:20,y:126,width:80,height:15)
        tixianMoneyLab.text = "提现金额"
        tixianMoneyLab.font = UIFont.systemFont(ofSize: 15)
        tixianMoneyLab.textColor = fontColor()
        headView.addSubview(tixianMoneyLab)
        
        let hui3 = UIView.init()
        hui3.frame = CGRect(x:110,y:122,width:1,height:23)
        hui3.backgroundColor = huiColor()
        headView.addSubview(hui3)
        
        let moneyTF = UITextField.init()
        moneyTF.frame = CGRect(x:115,y:95+8,width:WindowWidth-107-100,height:61)
        moneyTF.placeholder = "请输入金额"
        moneyTF.keyboardType = .numberPad
        headView.addSubview(moneyTF)
        moneyTF.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
        
        let tixianBtn = UIButton.init()
        tixianBtn.frame = CGRect(x:WindowWidth-80-20,y:95+8,width:80,height:60)
        tixianBtn.setTitle("全部提现", for: .normal)
        tixianBtn.setTitleColor(homeColor(), for: .normal)
        headView.addSubview(tixianBtn)
        tixianBtn.addTarget(self, action: #selector(tixianAll), for: .touchUpInside)
        
        let hui4 = UIView.init()
        hui4.frame = CGRect(x:0,y:163,width:WindowWidth,height:1)
        hui4.backgroundColor = huiColor()
        headView.addSubview(hui4)
        
        let instructionsLab = UILabel.init()
        instructionsLab.frame = CGRect(x:20,y:163+10,width:WindowWidth-20,height:12)
        instructionsLab.text = "说明：提现金额经后台审核通过后转入微信钱包，请查收！"
        instructionsLab.font = UIFont.systemFont(ofSize: 12)
        instructionsLab.textColor = kRGBColorFromHex(rgbValue: 0x999999)
        headView.addSubview(instructionsLab)
        
        let nextBtn:UIButton = UIButton()
        headView.addSubview(nextBtn)
        nextBtn.frame = CGRect(x:20,y:163+10+12+32,width:WindowWidth-40,height:46)
        nextBtn.backgroundColor = homeColor()
        nextBtn.setTitle("确认提现", for: .normal)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action:#selector(nextClick) , for: .touchUpInside)
        
        let hui5 = UIView.init()
        hui5.frame = CGRect(x:0,y:163+121,width:WindowWidth,height:29)
        hui5.backgroundColor = huiColor()
        headView.addSubview(hui5)
        
        let contentLab = UILabel.init()
        contentLab.frame = CGRect(x:0,y:312,width:WindowWidth,height:51)
        contentLab.text = "佣金列表"
        contentLab.font = UIFont.systemFont(ofSize: 15)
        contentLab.textColor = fontColor()
        headView.addSubview(contentLab)
        contentLab.textAlignment = .center
        let hui6 = UIView.init()
        hui6.frame = CGRect(x:0,y:312+50,width:WindowWidth,height:8)
        hui6.backgroundColor = huiColor()
        headView.addSubview(hui6)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func tfInPut(tf:UITextField)  {
        money = tf.text
    }
    func tixianAll () {
        let url = BASE_URL + k_applyMoney
        let mon:String = count!
        let m :Int = Int(Double(mon)!*100)
        let params:Dictionary = ["custId":custId,"fromType":"1","total":m.description]
//        let params:Dictionary = ["custId":custId,"fromType":"1","total":count]
        print("url = ",url)
        print("params = ",params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
            }
        }, to:url,headers :["devType":"1","token":token])
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
                            let data = dict["data"]
                            self.leftEvent()
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
    func nextClick()  {
        if money == "" {
            loadFailure(msg: "请输入金额")
        }
        else{
            let url = BASE_URL + k_applyMoney
            let mon:String = money!
            let m :Int = Int(Double(mon)!*100)
            let params:Dictionary = ["custId":custId,"fromType":"1","total":m.description]
//            let params:Dictionary = ["custId":custId,"fromType":"1","total":money]
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                }
            }, to:url,headers :["devType":"1","token":token])
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
                                let data = dict["data"]
                                self.leftEvent()
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! WithdrawalTableViewCell
                cell.selectionStyle = .none
                cell.CommissionWithdrawalModel = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.05
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.data.count
        return self.data.count
    }
    override func rightEvent() {
        let vc = WithdrawalRecordVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getStateData()  {
        let url = BASE_URL + k_isbangdingWX
        let params:Dictionary = ["rewardType":"1","custId":custId]
        print("url = ",url)
        print("params = ",params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
            }
        }, to:url,headers :["devType":"1","token":token])
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
                            let state = data["state"]?.intValue
                            if state == 1  {
                                //已经绑定
                                self.createUI()
                                self.getData()
                            }
                            else {
                                self.getQRCode()
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
    
    func getQRCode()  {
        let url = BASE_URL + k_QRCode
        let params:Dictionary = ["custId":custId]
        print("url = ",url)
        print("params = ",params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
            }
        }, to:url,headers :["devType":"1","token":token])
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
                            let data = dict["data"].dictionaryObject
                            let filePath = data!["filePath"] as? String
                            self.invateCode = "http://test.chezutong.com" + filePath!
                            self.createNoVxUI()
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
    func createNoVxUI()  {
        self.titleX?.text = "关注我们"
        let contentLab = UILabel.init()
        self.view.addSubview(contentLab)
        contentLab.text = "您还未关注我们微信公众号，不能进行提现， \n请先关注我们微信公众号后，进行提现。"
        contentLab.textColor = homeColor()
        contentLab.textAlignment = .center
        contentLab.snp.makeConstraints { (make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(64)
            make.height.equalTo(105)
        }
        contentLab.numberOfLines = 2
        
        let backImg = UIImageView.init()
        self.view.addSubview(backImg)
        backImg.image = UIImage(named:"组2拷贝2")
        backImg.snp.makeConstraints { (make)->Void in
            make.left.equalTo(0)
            make.top.equalTo(contentLab.snp.bottom).offset(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        let QRCode  = UIImageView.init()
        QRCode.backgroundColor = huiColor()
        backImg.addSubview(QRCode)
        QRCode.snp.makeConstraints { (make)->Void in
            make.height.equalTo(150)
            make.width.equalTo(150)
            make.top.equalTo(60)
            make.left.equalTo(25)
        }
        QRCode.image = invateCode?.generateQRCodeWithLogo(logo: UIImage(named: ""))
        
    }
    func getData()  {
        self.data = [CommissionWithdrawalModel]()
        let url = BASE_URL + k_CommissionWithdrawalList
        let params:Dictionary = ["offset":"0","limit":"200","custId":custId]
        print("url = ",url)
        print("params = ",params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
            }
        }, to:url,headers :["devType":"1","token":token])
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
                            if let items = dict["data"].arrayObject {
                                for item in items {
                                    print(item)
                                    let post = CommissionWithdrawalModel(dict: item as! [String: AnyObject])
                                    self.data.append(post)
                                }
                                self.tableView?.reloadData()
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
}
