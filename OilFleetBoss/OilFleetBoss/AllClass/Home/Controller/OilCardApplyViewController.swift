//
//  OilCardApplyViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class OilCardApplyViewController: MDKBaseListViewController {
    
    var pickerView:UIPickerView!
    
    var siteName:String?
    var telName:String?
    var telNum:String?
    var code:String?
    var idCardNum:String?
    var oilType:String?
    var cardNum:String?
    var pro1 :String?
    var area1 :String?
    var city1:String?
    var add:String?
    var shoukaType:String?
    var siteId :String?
    var data = [OilCardApplyModel]()
    var siteData = [MyConstructionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "申请油卡"
        self.view.backgroundColor = huiColor()
        telNum = userPhone
        idCardNum = ""
        telName = userName
        self.rightBtn?.setTitle("申请状态", for: .normal)
        // Do any additional setup after loading the view.
        let dataArr:Array<Dictionary<String, String>> =
            [["title":"工地名称","content":"请填写您的工地名称"],
             ["title":"申请人","content":userName],
             ["title":"手机号码","content":userPhone],
             ["title":"验证码","content":"请填写验证码"],
             ["title":"身份证号","content":"请输入您的身份证号"],
             ["title":"油卡类型","content":"油卡"],
             ["title":"申请数量","content":"请输入您的油卡数量"],
             ["title":"收卡地址","content":"请填写收卡地址"],
             ["title":"详细地址","content":"请输入您的详细地址"],
             ["title":"收卡方式","content":"请选择您的收卡方式"],
             ]
        print("dataArr = ",dataArr)
        for item in dataArr {
            let post = OilCardApplyModel(dict: item as [String : AnyObject] )
            print("post = ",post)
            data.append(post)
        }
        oilType = "油卡"
        cellID = "OilCardApplyTableViewCell"
        tableView?.frame = CGRect(x:0,y:64,width:WindowWidth,height:WindowHeight-64-50)
        tableView?.register(OilCardApplyTableViewCell.self, forCellReuseIdentifier: cellID)
        let matchAnimator = FNMatchPullAnimator(frame: CGRect(x: 0, y: 0, width: WindowWidth, height: 80))
        matchAnimator.text = "HELLO,OIL"
        matchAnimator.style = .text
        tableView?.addPullToRefreshWithAction({
            OperationQueue().addOperation {
                self.getSiteData()
            }
        }, withAnimator: matchAnimator)
        self.getSiteData()
        self.view.addSubview(tableView!)
        self.craeteUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - tableView代理
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        //        return 1
    }
    //绘制cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! OilCardApplyTableViewCell
        cell.selectionStyle = .none
        cell.OilCardApplyModel = data[indexPath.row]
        cell.contentTF?.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
        cell.contentTF?.tag = indexPath.row
        cell.contentTF?.delegate = self
        if indexPath.row == 3 {
            cell.contentTF?.snp.makeConstraints({ (make)->Void in
                make.right.equalTo(-120)
                make.width.equalTo(200)
                make.top.equalTo(0)
                make.height.equalTo(50)
                
            })
            cell.contentTF?.keyboardType = .numberPad
            
            let codeBtn = TimerButton.init(frame: CGRect(x:WindowWidth-90-20,y:6.5,width:90,height:37))
            codeBtn.addTarget(self, action: #selector(codeBtnClick), for: .touchUpInside)
            codeBtn.layer.cornerRadius = 4
            codeBtn.layer.masksToBounds = true
            codeBtn.backgroundColor = homeColor()
            codeBtn.setup("获取验证码", timeTitlePrefix: "剩余")
            codeBtn.setTitleColor(UIColor.white, for: .normal)
            cell.contentView.addSubview(codeBtn)
        }
        if indexPath.row == 0 || indexPath.row == 7 || indexPath.row == 5 || indexPath.row == 9{
            cell.contentTF?.isEnabled = false
        }
        if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6){
            cell.contentTF?.keyboardType = .numberPad
        }
        if indexPath.row == 5 {
            cell.contentTF?.text = "油卡"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.05
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let cell:OilCardApplyTableViewCell = tableView.cellForRow(at: indexPath) as! OilCardApplyTableViewCell
            var siteNameArr = [String]()
            var siteIdArr = [Int]()
            if self.siteData.count == 0{
                let alertVC = UIAlertController(title: "提示", message: "请创建工地", preferredStyle: UIAlertControllerStyle.alert)
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
                }
                let onePicker = JHPickerView.init(aDataSource: siteNameArr, aTitle: "请选择工地")
                
                onePicker.show()
                onePicker.showSelectedRow(3, animated: true)
                onePicker.didClickDoneForTypeAloneHandler { (selectedRow, result) in
                    print("selectedRow:\(selectedRow)")
                    print("result:\(result)")
                    cell.contentTF?.text = result
                    self.siteName = siteIdArr[selectedRow].description
                    self.siteId = siteIdArr[selectedRow].description
                }
                onePicker.didClickCancelHandler {
                    print("dismiss")
                }
            }
        }
        if indexPath.row == 7 {
            let cell:OilCardApplyTableViewCell = tableView.cellForRow(at: indexPath) as! OilCardApplyTableViewCell
            let rect = CGRect(x: 0, y: WindowHeight-300, width: self.view.frame.width, height: 300)
            let areaVC = AreaPickerViewController(title: "选择省市区", frame: rect) { (pro,area,city) in
                //省市区选择回调
                cell.contentTF?.text = (pro) + (area) + (city)
                self.pro1 = pro
                self.area1 = area
                self.city1 = city
            }
            areaVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.present(areaVC, animated: false, completion: nil)
        }
        if indexPath.row == 9 {
            let cell:OilCardApplyTableViewCell = tableView.cellForRow(at: indexPath) as! OilCardApplyTableViewCell
            let siteNameArr = ["邮寄","自提"]
            var siteIdArr = ["1","2"]
            
            let onePicker = JHPickerView.init(aDataSource: siteNameArr, aTitle: "请选择收卡方式")
            
            onePicker.show()
            onePicker.showSelectedRow(3, animated: true)
            onePicker.didClickDoneForTypeAloneHandler { (selectedRow, result) in
                print("selectedRow:\(selectedRow)")
                print("result:\(result)")
                cell.contentTF?.text = result
                self.shoukaType = siteIdArr[selectedRow].description
            }
            onePicker.didClickCancelHandler {
                print("dismiss")
                
            }
        }
    }
    
    func craeteUI() {
        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:20,y:WindowHeight-50,width:WindowWidth-40,height:44)
        nextBtn.backgroundColor = homeColor()
        nextBtn.setTitle("下一步", for: .normal)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action:#selector(btnClick) , for: .touchUpInside)
        self.view.addSubview(nextBtn)
        
    }
    func btnClick(btn:UIButton)  {
        if siteName == nil{
            loadFailure(msg: "请输入工地名称")
        }
        else if telName == nil{
            loadFailure(msg: "请输入申请人")
        }
        else if isPhoneNumber(phoneNumber: telNum!) == false {
            loadFailure(msg: "请输入正确的手机号码")
        }
        else if code == nil{
            loadFailure(msg: "请输入验证码")
        }
        else if chk18PaperId(sfz: idCardNum!) == false{
            loadFailure(msg: "请输入正确的身份证号")
        }
        else if oilType == nil{
            oilType = "油卡"
            loadFailure(msg: "请输入油卡类型")
        }
        else if cardNum == nil{
            loadFailure(msg: "请输入申请数量")
        }
        else if pro1 == nil{
            loadFailure(msg: "请选择地址")
        }
        else if add == nil{
            loadFailure(msg: "请输入详细地址")
        }
        else if shoukaType == nil{
            
            loadFailure(msg: "请选择收卡方式")
        }
        else{
            let url = BASE_URL + k_applyCard
            //"token":token,
            let params:Dictionary = ["cardCount":cardNum,"cardType":"1","cardTel":telNum,"cardId":idCardNum,"custId":custId,"province":pro1,"city":area1,"county":city1,"address":add,"receivingMode":shoukaType,"engineeringId":siteId,"veriCode":code,"custNname":telName]
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
                                print("URL:\(url)")
                                print("PARAMS:\(params)")
                                print("JSON: \(value)")
                                let data = dict["data"]
                                let vc = FillIdCardViewController()
                                vc.uid = data["uid"].stringValue
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
    func codeBtnClick(btn:TimerButton)  {
        
        if isPhoneNumber(phoneNumber: telNum!) == false {
            loadFailure(msg: "请输入正确的手机号码")
            btn.panduan = false
        }
        else{
            btn.panduan = true
            let url = BASE_URL + k_sendSms
            let params:Dictionary = ["phone":telNum,"custId":"","smsType":"4"]
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
    func tfInPut(tf:UITextField)  {
        
        if tf.tag == 1{
            telName = tf.text!
        }
        else if tf.tag == 2{
            tf.keyboardType = .phonePad
            telNum = tf.text!
        }
        else if tf.tag == 3{
            tf.keyboardType = .numberPad
            code = tf.text!
        }
        else if tf.tag == 4{
            tf.keyboardType = .numberPad
            idCardNum = tf.text!
        }
        else if tf.tag == 5{
            oilType = tf.text!
        }
        else if tf.tag == 6{
            tf.keyboardType = .numberPad
            cardNum = tf.text!
        }
        else if tf.tag == 8{
            add = tf.text!
        }
        
    }
    func getSiteData()  {
        siteData = [MyConstructionModel]()
        let url = BASE_URL + k_siteList
        //"token":token,
        let params:Dictionary = ["custId":custId,"offset":"0","limit":"15"]
        loading()
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
                                    let post = MyConstructionModel(dict: item as! [String: AnyObject])
                                    self.siteData.append(post)
                                }
                            }
                            self.tableView?.stopPullToRefresh()
                            
                        }
                        else{
                            //失败
                            loadFailure(msg : value["msg"] as!String)
                            print("JSON: \(value)()")
                            self.tableView?.stopPullToRefresh()
                        }
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2 {
            guard let text = textField.text else{
                return true
            }
            
            let textLength = text.characters.count + string.characters.count - range.length
            
            return textLength<=11
        }
        else {
            return true
        }
        
    }
    override func leftEvent() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func rightEvent() {
        let vc = MyOrderViewController()
        vc.applyType = "2"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
