//
//  AddNewSiteViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/9.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
class AddNewSiteViewController: MDKBaseViewController {
    var siteName :String?
    var siteType:String?
    var siteTime :String?
    var telPhone :String?
    var telName :String?
    var pro1 :String?
    var area1 :String?
    var city1:String?
    var add:String?
    var siteTypeName = [String]()
    var siteTypeId = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "新增工地"
        self.createUI()
        telPhone = userPhone
        telName = userName
        siteTypeName = ["建筑","装饰","土方","市政道路","桥梁","园林绿化","节能环保","铁路","公路","其他"]
        siteTypeId = ["1","2","3","4","5","6","7","8","9","10"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI()  {
        let titleArr = ["工程名称","工程类型","开工时间","联系方式","联系人","省 市 区","详细地址"]
        let contentArr = ["请输入您的工程名称","请选择工程类型","开工时间",userPhone,userName,"请选择省、市、区","请填写详细工地地址"]
        
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
            tf.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            tf.placeholder = contentArr[index]
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
            if index == 3 || index == 4{
                tf.text = contentArr[index]
            }
        }
        
        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:20,y:45*7+64+50,width:WindowWidth-40,height:44)
        nextBtn.backgroundColor = homeColor()
        nextBtn.setTitle("确定增加", for: .normal)
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
         let params:Dictionary = ["custId":custId,"name":siteName,"tel":telPhone,"contacts":telName,"province":pro1,"city":area1,"county":city1,"address":add,"startDate":siteTime,"engType":siteType]
        print(params)
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
            loadFailure(msg: "请填写正确的联系方式")
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
            let url = BASE_URL + k_add
            //"token":token,
            let params:Dictionary = ["custId":custId,"name":siteName,"tel":telPhone,"contacts":telName,"province":pro1,"city":area1,"county":city1,"address":add,"startDate":siteTime,"engType":self.siteType]
            print(params)
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
                                let vc = OilCardApplyViewController()
                                
                            self.navigationController?.pushViewController(vc, animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
