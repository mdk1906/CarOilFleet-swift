//
//  WithdrawalViewController.swift
//  CarOilFleetService
//
//  Created by mdk mdk on 2017/10/17.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class WithdrawalViewController: MDKBaseViewController {
    
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var moneyTf: UITextField!
    @IBOutlet weak var ketiLab: UILabel!
    @IBOutlet weak var tichengLab: UILabel!
    @IBOutlet weak var tixianBtn: UIButton!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    
    let bangdingView :UIView = UIView()
    var bangdingBtn :UIButton = UIButton()
    var openid:String?
    //可提现
    var tixian :String?
    //总提现：包括审核中的
    var totalTixian :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "申请提现"
        self.view.backgroundColor = huiColor()
        self.getData()
//        self.unBangding()
        self.tixian = "0.0"
        self.totalTixian = "0.0"
//        self.isBangding()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name:   NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func rightEvent() {
        let vc = MyCommissionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func isBangding()  {
        self.rightBtn?.setTitle("提现记录", for: .normal)
        
        firstView.isHidden = false
        secondView.isHidden = false
        tixianBtn.isHidden = false
        bangdingView.isHidden = true
        bangdingBtn.isHidden = true
        
        tixianBtn.addTarget(self, action: #selector(tixianClick), for: .touchUpInside)
        tixianBtn.layer.cornerRadius = 4
        tixianBtn.layer.masksToBounds = true
        moneyTf.addTarget(self, action: #selector(moneyInPut), for: .editingChanged)
        moneyTf.keyboardType = .numberPad
        tichengLab.text = "提成总额：¥" + self.totalTixian!
        ketiLab.text = "可提现：¥" + self.tixian!
    }
    func unBangding()  {
        
        bangdingBtn.frame = CGRect(x:20,y:384,width:WindowWidth-40,height:40)
        bangdingBtn.backgroundColor = homeColor()
        bangdingBtn.setTitleColor(UIColor.white, for: .normal)
        bangdingBtn.layer.cornerRadius = 4
        bangdingBtn.layer.masksToBounds = true
        bangdingBtn.addTarget(self, action: #selector(bangdingClick), for: .touchUpInside)
        bangdingBtn.setTitle("立即绑定", for: .normal)
        self.view.addSubview(bangdingBtn)
        firstView.isHidden = true
        secondView.isHidden = true
        self.tixianBtn.isHidden = true
        bangdingView.backgroundColor = UIColor.white
        self.view.addSubview(bangdingView)
        bangdingView.snp.makeConstraints { (make)->Void in
            make.top.equalTo(80)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(150)
        }
        
        let titleLab :UILabel = UILabel.init()
        titleLab.numberOfLines = 2
        titleLab.text = "您需要绑定微信之后才能提现，请点击立即绑定先绑定微信。"
        titleLab.textColor = UIColor.black
        titleLab.font = UIFont.systemFont(ofSize: 14)
        bangdingView.addSubview(titleLab)
        titleLab.textAlignment = .left
        titleLab.snp.makeConstraints { (make)->Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(130)
            make.top.equalTo(20)
        }
    }
    func moneyInPut(tf:UITextField)  {
        moneyLab.text = "对应金额：¥" + moneyTf.text!
    }
    func tixianClick()  {
        if moneyTf.text?.count == 0 {
            loadFailure(msg: "请填写提现金额")
        }else{
            let money = (moneyTf.text! as NSString).doubleValue * 100
            let m :Int = Int(money)
            let url = BASE_URL + k_tixianApply
            let params:Dictionary = ["custId":custId,"total":m.description]
            print("url = ", url)
            print("params = " ,params)
            print("token = ", token)
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
                                NotificationCenter.default.post(name: NSNotification.Name.init("freshUI"), object: nil)
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
    func bangdingClick()  {
        //WXApi.registerApp("wx23c37747e56a5060")
        let urlStr = "weixin://"
        if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
            let red = SendAuthReq.init()
            red.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
            red.state = "\(arc4random()%100)"
            WXApi.send(red)
        }else{
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
            }
        }
    }
    
    /**  微信通知  */
    func WXLoginSuccess(notification:Notification) {
        
        let code = notification.object as! String
        let requestUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(WX_APPID)&secret=\(WX_APPSecret)&code=\(code)&grant_type=authorization_code"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                let openid: String = jsonResult["openid"] as! String
                let access_token: String = jsonResult["access_token"] as! String
                self.getUserInfo(openid: openid, access_token: access_token)
            }
        }
    }
    
    /**  获取用户信息  */
    func getUserInfo(openid:String,access_token:String) {
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openid)"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                print(jsonResult)
                self.openid = jsonResult["openid"] as? String
                self.bangdingWX()
            }
        }
    }
    func bangdingWX()  {
        let url = BASE_URL + k_bangdingWX
        let params:Dictionary = ["custId":custId,"openId":self.openid]
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
                            self.isBangding()
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
    // MARK : - 获取用户是否绑定微信公众号
    func getData()   {
        let url = BASE_URL + k_isBangding
        let params:Dictionary = ["custId":custId]
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
                            let data = dict["data"].dictionary
                            if data!["Bindmsg"] == "success"{
                                self.isBangding()
                            }
                            else{
                                self.unBangding()
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
    // MARK : - 提交申请
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
