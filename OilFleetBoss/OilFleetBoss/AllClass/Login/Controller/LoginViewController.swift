//
//  LoginViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/14.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class LoginViewController: MDKBaseViewController {
    
    @IBOutlet weak var bigImg: UIImageView!
    var items = [LoginModel]()
    
    @IBOutlet weak var backView: UIView!
    //注册按钮
    @IBOutlet weak var rigestBtn: UIButton!
    //忘记密码按钮
    @IBOutlet weak var forgetBtn: UIButton!
    //密码输入框
    @IBOutlet weak var PassWordTf: UITextField!
    //用户名输入框
    @IBOutlet weak var userNameTf: UITextField!
    //登录按钮
    @IBOutlet weak var loginBtn: UIButton!
    
    var launchImg :UIImageView?
    var timer : Timer!
    var tuichu :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if tuichu == nil {
            launchImg = UIImageView.init()
            launchImg?.frame = CGRect(x:0,y:0,width:WindowWidth,height:WindowHeight)
            launchImg?.image = UIImage(named:"油机队工地端-启动页")
            self.view.addSubview(launchImg!)
            
            timer=Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(launchImgDismiss), userInfo: nil, repeats: true)
        }
        else{
            
        }
        
        
        
        self.bigImg.backgroundColor = UIColor.clear
        self.Nav?.isHidden = true
        PassWordTf.isSecureTextEntry = true
        PassWordTf.delegate = self
        userNameTf.keyboardType = .phonePad
        userNameTf.layer.borderColor = UIColor.clear.cgColor
        userNameTf.layer.borderWidth = 2
        userNameTf.delegate = self
        loginBtn.layer.cornerRadius = 4
        loginBtn.layer.masksToBounds = true
        if phoneNum != nil{
            self.userNameTf.text = phoneNum
            self.PassWordTf.text = passWord
        }
        rigestBtn.titleLabel?.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        forgetBtn.titleLabel?.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func launchImgDismiss()  {
        launchImg?.isHidden = true
        guard let timer1 = self.timer
            else{ return }
        timer1.invalidate()
    }
    @IBAction func rigestAc(_ sender: Any) {
        let vc = RegistPhoViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func forgetAction(_ sender: Any) {
        let vc = ForgetPassWordViewController()
        vc.title = "忘记密码"
        //        navigationController?.pushViewController(forgetVc, animated: true)
        self.present(vc, animated: true, completion: nil)
        // 转场动画风格 modalTransitionStyle
    }
    @IBAction func login(_ sender: Any) {
        
        NSLog("userNameTf = %@", userNameTf.text!);
        NSLog("PassWordTf = %@", PassWordTf.text!);
        let pass = PassWordTf.text!.MD5()
        NSLog(pass)
        
        let url = BASE_URL + k_Login
        let params:Dictionary = ["phone":userNameTf.text!,"password":pass,"custType":"2"]
        loading()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    if let JSON:NSDictionary = response.result.value as! NSDictionary? {
                        if JSON["ret"]as! NSInteger == 1 {
                            //取消别名
                            JPUSHService.setAlias("",
                                                  callbackSelector: #selector(self.tagsAliasCallBack(resCode:tags:alias:)),
                                                  object: self)
                            //成功
                            let data:NSDictionary = (JSON["data"] as!NSDictionary?)!
                            //保存用户名密码
                            saveWithNSUserDefaults(content: self.userNameTf.text!, key: "phone")
                            
                            OilValue.shared.userPhone = data["custPhone"] as! String
                            userPhone = OilValue.shared.userPhone
                            
                            saveWithNSUserDefaults(content: self.PassWordTf.text!, key: "passWord")
                            //保存token
                            saveWithNSUserDefaults(content: data["token"] as!String, key: "token")
                            
                            OilValue.shared.token = data["token"] as! String
                            print("token456 = ",OilValue.shared.token)
                            token = OilValue.shared.token
                            //保存用户昵称
                            saveWithNSUserDefaults(content: data["custNname"] as!String, key: "custNname")
                            userName = data["custNname"] as!String
                            //保存用户会员号custId
                            saveWithNSUserDefaults(content: data["custNo"] as!String, key: "custNo")
                            //custId
                            saveWithNSUserDefaults(content: data["custId"] as!String, key: "custId")
                            //保存会员头像custImg
                            if data["custImg"] != nil{
                                headImgStr = data["custImg"] as!String
                            }
                            //                           saveWithNSUserDefaults(content: data["custImg"] as!String, key: "custImg")
                            loadSuccess()
                            let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
                            let viewController = mainStoryboard.instantiateInitialViewController()
                            self.present(viewController!, animated: true, completion:nil)
                            print("JSON: \(JSON)")
                            
                            
                            
                        }
                        else{
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.characters.count + string.characters.count - range.length
        
        return textLength<=11
    }
    
    
    //别名注册回调
    func tagsAliasCallBack(resCode:CInt, tags:NSSet, alias:NSString) {
        print("相应结果",resCode)
        print("别名",alias)
        //注册别名
        JPUSHService.setAlias(custId,
                              callbackSelector: #selector(tagsAliasCallBack(resCode:tags:alias:)),
                              object: self)
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
