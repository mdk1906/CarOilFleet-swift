//
//  AddNewWorkerViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/12.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class AddNewWorkerViewController: MDKBaseViewController {
    
    var siteName :String?
    var Nname :String?
    var telPhone :String?
    var workType :String?
    var cardNum :String?
    var siteData = [MyConstructionModel]()
    var workerId :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "新增雇工"
        workType = ""
        workerId = ""
        self.rightBtn?.setImage(UIImage(named:"扫一扫"), for: .normal)
        // Do any additional setup after loading the view.
        self.createUI()
        self.getSiteData()
        NotificationCenter.default.addObserver(self, selector: #selector(fresh), name: NSNotification.Name.init("saomiaoSecuess"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fresh(noc:Notification)  {
        print(noc.object)
        let resultArr :Array<String> = noc.object as! Array

        workerId = resultArr[1]
        self.getData()
        
    }
    func createUI()  {
        let titleArr = ["工程名称","姓名","联系方式","工种","卡号"]
        let contentArr = ["工程名称","请输入您的姓名","请输入联系方式","请选择工种","请填写卡号"]
        for index in 0..<(titleArr.count) {
            let view : UIView = UIView.init()
            view.backgroundColor = UIColor.white
            self.view.addSubview(view)
            view.snp.makeConstraints({ (make)->Void in
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
                make.left.equalTo(20)
                make.top.equalTo(0)
                make.height.equalTo(45)
                make.width.equalTo(200)
            })
            
            let tf :UITextField = UITextField.init()
            tf.placeholder = contentArr[index]
            tf.textAlignment = .right
            tf.font = UIFont.systemFont(ofSize: 14)
            tf.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
            view.addSubview(tf)
            tf.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            tf.tag = index + 100
            tf.snp.makeConstraints({ (make)->Void in
                make.right.equalTo(-20)
                make.top.equalTo(0)
                make.width.equalTo(200)
                make.height.equalTo(45)
            })
            
            let hui :UIView = UIView.init()
            hui.backgroundColor = huiColor()
            view.addSubview(hui)
            hui.snp.makeConstraints({ (make)->Void in
                make.top.equalTo(44)
                make.height.equalTo(1)
                make.left.equalTo(0)
                make.right.equalTo(0)
            })
            if index == 0 {
                tf.isEnabled = false
                
                let btn :UIButton = UIButton.init()
                view.addSubview(btn)
                btn.snp.makeConstraints({ (make)->Void in
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.height.equalTo(45)
                    make.top.equalTo(0)
                })
                btn.addTarget(self, action: #selector(chooseClick), for: .touchUpInside)
            }
            if index == 3 {
                tf.isEnabled = false
                
                let btn :UIButton = UIButton.init()
                view.addSubview(btn)
                btn.snp.makeConstraints({ (make)->Void in
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.height.equalTo(45)
                    make.top.equalTo(0)
                })
                btn.addTarget(self, action: #selector(chooseWorktypeClick), for: .touchUpInside)
            }
        }
        let saoyisaoBtn:UIButton = UIButton()
        saoyisaoBtn.frame = CGRect(x:20,y:300,width:WindowWidth-40,height:44)
        saoyisaoBtn.backgroundColor = homeColor()
        saoyisaoBtn.setTitle("扫描司机二维码", for: .normal)
        saoyisaoBtn.setTitleColor(UIColor.white, for: .normal)
        saoyisaoBtn.layer.masksToBounds = true
        saoyisaoBtn.layer.cornerRadius = 5
        saoyisaoBtn.addTarget(self, action:#selector(saoyisaoClick) , for: .touchUpInside)
        //        self.view.addSubview(saoyisaoBtn)
        
        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:20,y:45*5+64+50,width:WindowWidth-40,height:44)
        nextBtn.backgroundColor = homeColor()
        nextBtn.setTitle("保存", for: .normal)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action:#selector(btnClick) , for: .touchUpInside)
        self.view.addSubview(nextBtn)
        
    }
    func btnClick()  {
        if siteName == nil {
            loadFailure(msg: "请输入工程名称")
        }
        else if Nname == nil{
            loadFailure(msg: "请输入您的姓名")
        }
        else if telPhone == nil{
            loadFailure(msg: "请输入您的联系方式")
        }
        else if workType == nil{
            loadFailure(msg: "请输入您的工种")
        }
        else if cardNum == nil{
            loadFailure(msg: "请输入您的卡号")
        }
        else{
            let url = BASE_URL + k_employAdd
            let params:Dictionary = ["custId":custId,"oilCardNum":cardNum,"engineeringId":siteName,"custPhone":telPhone,"workType":workType,"startDate":"1507625788000"]
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
                                NotificationCenter.default.post(name: NSNotification.Name.init("freshUI"), object: nil)
//                                self.navigationController?.popViewController(animated: true)
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
    func tfInPut(tf:UITextField)  {
        
        if tf.tag == 101{
            //姓名
            Nname = tf.text!
        }
        else if tf.tag == 102{
            //联系方式
            telPhone = tf.text!
        }
        else if tf.tag == 103{
            //工种
            workType = tf.text!
        }
        else if tf.tag == 104{
            //卡号
            cardNum = tf.text!
        }
    }
    func chooseClick()  {
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
                let tf :UITextField = self.view.viewWithTag(100) as! UITextField
                tf.text = result
                //cell.contentTF?.text = result
                self.siteName = siteIdArr[selectedRow].description
            }
            onePicker.didClickCancelHandler {
                print("dismiss")
            }
        }
        
    }
    func chooseWorktypeClick()  {
        var workType = ["挖掘机","渣土车","推土机","吊车工"]
        let onePicker = JHPickerView.init(aDataSource: workType, aTitle: "请选择工种")
        
        onePicker.show()
        onePicker.showSelectedRow(3, animated: true)
        onePicker.didClickDoneForTypeAloneHandler { (selectedRow, result) in
            print("selectedRow:\(selectedRow)")
            print("result:\(result)")
            let tf :UITextField = self.view.viewWithTag(103) as! UITextField
            tf.text = result
            //cell.contentTF?.text = result
            self.workType = workType[selectedRow].description
        }
        onePicker.didClickCancelHandler {
            print("dismiss")
        }
    }
    func getSiteData()  {
        let url = BASE_URL + k_siteList
        //"token":token,
        let params:Dictionary = ["custId":custId,"offset":"0","limit":"15"]
        loading()
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
                            
                            if let items = dict["data"].arrayObject {
                                for item in items {
                                    let post = MyConstructionModel(dict: item as! [String: AnyObject])
                                    self.siteData.append(post)
                                }
                                
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
    //MARK : - 扫一扫
    func saoyisaoClick()  {
        let vc = QRCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    override func rightEvent() {
        let vc = QRCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func getData()  {
        let url = BASE_URL + k_bindEmployee
        let params:Dictionary = ["custId":workerId]
        print(params)
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
                            let data = dict["data"].dictionaryObject
                            let nameTf :UITextField = self.view.viewWithTag(101) as! UITextField
                            let telTf :UITextField = self.view.viewWithTag(102) as! UITextField
                            let workTf :UITextField = self.view.viewWithTag(103) as! UITextField
                            let cardIdTf :UITextField = self.view.viewWithTag(104) as! UITextField
                            nameTf.text = (data?["name"] as! String)
                            telTf.text = (data?["custPhone"] as! String)
                            self.Nname =  (data?["name"] as! String)
                            cardIdTf.text = (data?["oilCardNum"] as! String)
                            //                                    Nname = resultArr[1]
                            self.telPhone = (data?["custPhone"] as! String)
                            switch data?["workType"]as! String {
                            case "0":
                                break
                            case "1":
                                workTf.text = "挖掘机"
                                self.workType = "挖掘机"
                            case "2":
                                workTf.text = "渣土车"
                                self.workType = "渣土车"
                            case "3":
                                workTf.text = "推土机"
                                self.workType = "推土机"
                            case "3":
                                workTf.text = "吊车工"
                                self.workType = "吊车工"
                            default:
                                break
                            }
                            
                            self.cardNum = (data?["oilCardNum"] as! String)
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
