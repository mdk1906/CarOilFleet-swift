//
//  EditSiteViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/10.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class EditSiteViewController: MDKBaseViewController {
    var siteName :String?
    var siteType:String?
    var siteTypeStr : String?
    var siteTime :String?
    var telPhone :String?
    var telName :String?
    var pro1 :String?
    var area1 :String?
    var city1:String?
    var add:String?
    var model:MyConstructionModel?
    var siteTypeName = [String]()
    var siteTypeId = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "修改工地信息"
        self.createUI()
        siteTypeName = ["建筑","装饰","土方","市政道路","桥梁","园林绿化","节能环保","铁路","公路","其他"]
        siteTypeId = ["1","2","3","4","5","6","7","8","9","10"]
        self.rightBtn?.setTitle("删除", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI()  {
        let titleArr = ["工程名称","工程类型","开工时间","联系方式","联系人","省 市 区","详细地址"]
        siteName = (model?.name)!
        siteType = (model?.engType?.description)!
        siteTime = (model?.startDate)!.description
        telPhone = (model?.tel)!
        telName = (model?.contacts)!
        pro1 = (model?.province)!
        area1 = (model?.city)!
        city1 = (model?.county)!
        add = (model?.address)!
        switch model?.engType?.description {
        case "1"?:
            self.siteTypeStr = "建筑"
        case "2"?:
            self.siteTypeStr = "装饰"
        case "3"?:
            self.siteTypeStr = "土方"
        case "4"?:
            self.siteTypeStr = "市政道路"
        case "5"?:
            self.siteTypeStr = "桥梁"
        case "6"?:
            self.siteTypeStr = "园林绿化"
        case "7"?:
            self.siteTypeStr = "节能环保"
        case "8"?:
            self.siteTypeStr = "铁路"
        case "9"?:
            self.siteTypeStr = "公路"
        case "10"?:
            self.siteTypeStr = "其他"
        default: break
            
        }
        let contentArr:Array<String> = [(model?.name)!,siteTypeStr!,timeStampToString(timeStamp: (((model?.startDate)!/1000).description)),(model?.tel)!,(model?.contacts)!,((model?.province)!+(model?.city)!+(model?.county)!),(model?.address)!]
        
        for index in 0..<(titleArr.count) {
            let view :UIView = UIView.init()
            view.backgroundColor = UIColor.white
            self.view.addSubview(view)
            view.snp.makeConstraints({ (make)-> Void in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(64+index*45)
                make.height.equalTo(45)
            })
            
            let titleLab :UILabel = UILabel.init()
            titleLab.text = titleArr[index]
            titleLab.font = UIFont.systemFont(ofSize: 14)
            titleLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            view.addSubview(titleLab)
            titleLab.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(22)
                make.top.equalTo(0)
                make.width.equalTo(200)
                make.height.equalTo(45)
            })
            
            let tf :UITextField = UITextField.init()
            tf.textAlignment = .right
            tf.font = UIFont.systemFont(ofSize: 14)
            tf.text = contentArr[index]
            tf.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            view.addSubview(tf)
            tf.tag = index
            if (index == 1 ) {
                tf.isEnabled = false
                let btn :UIButton = UIButton.init()
                view.addSubview(btn)
                btn.addTarget(self, action: #selector(siteTypeClick), for: .touchUpInside)
                btn.snp.makeConstraints({ (make)->Void in
                    make.right.equalTo(-22)
                    make.top.equalTo(0)
                    make.height.equalTo(45)
                    make.width.equalTo(200)
                })
            }
            else if (index == 2 ) {
                tf.addTarget(self, action: #selector(tfInPut), for: .editingDidBegin)
            }
                
            else if (index == 5){
                tf.isEnabled = false
                let btn :UIButton = UIButton.init()
                view.addSubview(btn)
                btn.addTarget(self, action: #selector(cityClick), for: .touchUpInside)
                btn.snp.makeConstraints({ (make)->Void in
                    make.right.equalTo(-22)
                    make.top.equalTo(0)
                    make.height.equalTo(45)
                    make.width.equalTo(200)
                })
            }
            else{
                tf.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
            }
            tf.snp.makeConstraints({ (make)->Void in
                make.right.equalTo(-22)
                make.top.equalTo(0)
                make.height.equalTo(45)
                make.width.equalTo(200)
            })
            
            let hui :UIView = UIView.init()
            hui.backgroundColor = huiColor()
            view.addSubview(hui)
            hui.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(44)
                make.height.equalTo(1)
            })
        }
        
        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:20,y:45*7+64+50,width:WindowWidth-40,height:40)
        nextBtn.backgroundColor = homeColor()
        nextBtn.setTitle("确认修改", for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action:#selector(btnClick) , for: .touchUpInside)
        self.view.addSubview(nextBtn)
    }
    func tfInPut(tf:UITextField){
        if tf.tag == 0{
            //工程名称
            siteName = tf.text!
        }
        else if tf.tag == 1{
            //工程类型
            siteType = tf.text!
        }
        else if tf.tag == 2{
            //开工时间
            let dateF:DateFormatter = DateFormatter()
            dateF.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let startInputView:JWDatePickerKeyBoardView = JWDatePickerKeyBoardView(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height: 216))
            
            startInputView.didConfirmDateClosure = {
                (date) -> Void in
                tf.text = dateF.string(from: date)
                //                self.siteTime = dateF.string(from: date)
                let dateStamp:TimeInterval = date.timeIntervalSince1970
                let dateSt:Int = Int(dateStamp)*(1000)
                self.siteTime = String(dateSt)
            };
            
            tf.inputView =  startInputView
            
        }
        else if tf.tag == 3{
            //联系方式
            tf.keyboardType = .phonePad
            telPhone = tf.text!
        }
        else if tf.tag == 4{
            //联系人
            telName = tf.text!
        }
        else if tf.tag == 5{
            
            
        }
        else if tf.tag == 6{
            //详细地址
            add = tf.text!
        }
        
    }
    func cityClick()  {
        let rect = CGRect(x: 0, y: WindowHeight-300, width: self.view.frame.width, height: 300)
        let areaVC = AreaPickerViewController(title: "选择省市区", frame: rect) { (pro,area,city) in
            //省市区选择回调
            print(pro,area,city)
            let tf :UITextField = self.view.viewWithTag(5) as! UITextField
            tf.text = (pro) + (area) + (city)
            self.pro1 = pro
            self.area1 = area
            self.city1 = city
        }
        areaVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.present(areaVC, animated: false, completion: nil)
    }
    func siteTypeClick()  {
        let onePicker = JHPickerView.init(aDataSource: siteTypeName, aTitle: "请选择工程类型")
        
        onePicker.show()
        onePicker.showSelectedRow(3, animated: true)
        onePicker.didClickDoneForTypeAloneHandler { (selectedRow, result) in
            print("selectedRow:\(selectedRow)")
            print("result:\(result)")
            let tf:UITextField = self.view.viewWithTag(1) as! UITextField
            tf.text = result
            self.siteType = self.siteTypeId[selectedRow].description
        }
        onePicker.didClickCancelHandler {
            print("dismiss")
        }
    }
    func btnClick()  {
    
        if siteName == nil {
            loadFailure(msg: "请填写工程名称")
        }
        else if siteType == nil {
            loadFailure(msg: "请选择工程类型")
        }
        else if siteTime == nil {
            loadFailure(msg: "请填写开工时间")
        }
        else if isPhoneNumber(phoneNumber: telPhone!) == false {
            loadFailure(msg: "请填写联系方式")
        }
        else if telName == nil {
            loadFailure(msg: "请填写联系人")
        }
        else if city1 == nil {
            loadFailure(msg: "请填写省市区")
        }
        else if add == nil {
            loadFailure(msg: "请填写详细地址")
        }
        else{
            let url = BASE_URL + k_editSite
            //"token":token,
            let params:Dictionary = ["custId":custId,"name":siteName,"tel":telPhone,"contacts":telName,"province":pro1,"city":area1,"county":city1,"address":add,"startDate":siteTime,"engType":siteType,"uid":model?.uid?.description]
            loading()
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                }
            }, to:url ,headers :["devType":"1","token":token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                    })
                    upload.responseJSON { response in
                        if let JSON:NSDictionary = response.result.value as! NSDictionary? {
                            if JSON["ret"]as! NSInteger == 1 {
                                loadSuccess()
                                //成功
                                print("JSON: \(JSON)")
                                self.leftEvent()
                            }
                            else{
                                //失败
                                loadFailure(msg : JSON["msg"] as!String)
                                print("JSON: \(JSON)")
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
    override func rightEvent() {
        let alertVC = UIAlertController(title: "提示", message: "确认删除工地吗", preferredStyle: UIAlertControllerStyle.alert)
        let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
            print("click Sure")
            self.deleteSite()
        }
        let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            print("click Cancel")
        }
        alertVC.addAction(acSure)
        alertVC.addAction(acCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    func deleteSite()  {
        let url = BASE_URL + k_delSite
        //"token":token,
        let params:Dictionary = ["custId":custId,"uid":model!.uid?.description]
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
