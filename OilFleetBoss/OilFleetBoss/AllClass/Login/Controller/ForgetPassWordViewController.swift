//
//  ForgetPassWordViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/18.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
class ForgetPassWordViewController: MDKBaseViewController {
    var phone :String?
    var code :String?
    var passWord :String?
    var newPassWord :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "忘记密码"
        phone = ""
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.creatUi()
        self.createNav()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func creatUi()   {
        let imgArr = ["电话","","password-icon","password-icon"]
        let titleArr = ["请输入电话号码","请输入验证码","请输入新密码","请再次输入新密码"]
        for  index in 0 ..< 4{
            let view:UIView! = UIView.init(frame: CGRect(x:25, y:CGFloat(index*68)+92, width:WindowWidth-50, height:37))
            view.layer.cornerRadius = 4
            view.layer.masksToBounds = true
            view.layer.borderColor = homeColor().cgColor
            view.layer.borderWidth = 1
            self.view.addSubview(view)
            
            let Image:UIImageView! = UIImageView.init(frame: CGRect(x:8,y:6,width:25,height:25))
            Image.image = UIImage(named: imgArr[index])
            view.addSubview(Image)
            
            let tf:UITextField = UITextField(frame:
                CGRect(origin: CGPoint(x: 40, y: 0),
                       size: CGSize(width: WindowWidth-40-50, height: 37)))
            tf.delegate = self
            tf.addTarget(self, action: #selector(textinPut), for: .editingChanged)
            tf.placeholder = titleArr[index]
            tf.tag = index+100
            view .addSubview(tf)
            if index == 1 {
                view.frame = CGRect(x:25, y:CGFloat(index*68)+92, width:WindowWidth-50-90-8, height:37)
                Image.isHidden = true
                tf.frame = CGRect(origin: CGPoint(x: 10, y: 0),
                                  size: CGSize(width: WindowWidth-40-50-90-8, height: 37))
                let codeBtn = TimerButton.init(frame: CGRect(x:25+WindowWidth-50-90,y:160,width:90,height:37))
                        codeBtn.addTarget(self, action: #selector(codeBtnClick), for: .touchUpInside)
                codeBtn.layer.cornerRadius = 4
                codeBtn.layer.masksToBounds = true
                codeBtn.backgroundColor = homeColor()
                //codeBtn.setTitle("验证码", for: .normal)
                codeBtn.setup("获取验证码", timeTitlePrefix: "剩余")
                codeBtn.setTitleColor(UIColor.white, for: .normal)
                self.view.addSubview(codeBtn)

            }
            if (index == 2 || index == 3){
                tf.isSecureTextEntry = true
            }
          
        }
        
        let sureBtn:UIButton = UIButton.init(frame: CGRect(x:25,y:542,width:WindowWidth-50,height:45))
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        sureBtn.layer.cornerRadius = 4
        sureBtn.layer.masksToBounds = true
        sureBtn.backgroundColor = homeColor()
        sureBtn.setTitle("确认找回密码", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(sureBtn)
        
    }
    func createNav()  {
        let view:UIView! = UIView.init(frame: CGRect(x:0, y:0, width:WindowWidth, height:64))
        view.backgroundColor = homeColor()
        self.view.addSubview(view)
        
        let leftBtn:UIButton = UIButton.init(frame: CGRect(x:10,y:30,width:50,height:40))
        leftBtn.addTarget(self, action: #selector(ForgetPassWordViewController.left), for: .touchUpInside)
        view.addSubview(leftBtn)
        
        let titleLab:UILabel = UILabel.init(frame: CGRect(x:0,y:30,width:WindowWidth,height:18))
        titleLab.text = "找回密码"
        titleLab.textAlignment = NSTextAlignment(rawValue: 1)!
        titleLab.textColor = UIColor.white
        titleLab.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(titleLab)
        let leftImg:UIImageView = UIImageView.init(frame: CGRect(x:10,y:31,width:13,height:21))
        leftImg.image = UIImage(named: "Back-icon")
        view.addSubview(leftImg)
        
    }
    func left()  {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK :找回密码
    func sureBtnClick(btn:UIButton)  {
        if phone == nil {
            loadFailure(msg: "请输入手机号")
        }
        else if code == nil{
            loadFailure(msg: "请输入验证码")
        }
        else if passWord == nil{
            loadFailure(msg: "请输入新密码")
        }
        else if newPassWord == nil{
            loadFailure(msg: "请输入新密码")
        }
        else if passWord != newPassWord{
            loadFailure(msg: "两次密码输入不一致")
        }
        else{
            let url = BASE_URL + k_forgetPass
            let pass = passWord?.MD5()
            let params:Dictionary = ["phone":phone,"password":pass,"veriCode":code,"custType":"2"]
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
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
                                loadSuccess()
                                //成功
                                //                                let data:NSDictionary = (JSON["data"] as!NSDictionary?)!
                                self.left()
                                print("JSON: \(JSON)")
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
    //MARK :获取验证码
    func codeBtnClick(btn:TimerButton)  {
        if isPhoneNumber(phoneNumber: phone!) == false {
            loadFailure(msg: "请输入正确的手机号码")
            btn.panduan = false
        }
        else{
            btn.panduan = true
            loading()
            let url = BASE_URL + k_sendSms
            let params:Dictionary = ["phone":phone,"custId":"","smsType":"2"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
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
                                loadSuccess()
                                //成功
//                                let data:NSDictionary = (JSON["data"] as!NSDictionary?)!
                                self.leftEvent()
                                print("JSON: \(JSON)")
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
    func textinPut(tf:UITextField)  {
        if tf.tag == 100 {
            //电话号码
            phone = tf.text!
        }
        else if tf.tag == 101{
            //验证码
            code = tf.text!
        }
        else if tf.tag == 102{
            //新密码
            passWord = tf.text!
        }
        else if tf.tag == 103{
            //再次输入新密码
            newPassWord = tf.text!
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.characters.count + string.characters.count - range.length
        
        return textLength<=11
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
