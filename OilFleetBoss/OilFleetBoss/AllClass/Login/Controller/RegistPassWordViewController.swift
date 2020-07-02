//
//  RegistPassWordViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/10/18.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegistPassWordViewController: MDKBaseViewController {

    var phoStr:String?
    var codeStr:String?
    var passStr :String?
    @IBOutlet weak var passTf: UITextField!
    @IBOutlet weak var registBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "注册"
        passTf.layer.cornerRadius = 4
        passTf.layer.masksToBounds = true
        passTf.layer.borderColor = homeColor().cgColor
        passTf.layer.borderWidth = 1
        passTf.isSecureTextEntry = true
        passTf.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func regestClick(_ sender: Any) {
        if passStr == nil {
            loadFailure(msg: "请输入密码")
        }
        else{
            loading()
            let url = BASE_URL + k_register
            let params:Dictionary = ["phone":phoStr,"password":passStr?.MD5(),"veriCode":codeStr,"custRegType":"4","custType":"2"]
            print("url = ",url)
            print("params = ",params)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                }
            }, to:url,headers :["devType":"1"])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                    })
                    upload.responseJSON { response in
                        if let JSON:NSDictionary = response.result.value as! NSDictionary? {
                            //let dict = JSON(value)
                            if JSON["ret"]as! NSInteger == 1 {
                                loadSuccess()
                                //成功
                                print("JSON: \(JSON)")
                                loadSuccess()
                                //成功
                                let data:NSDictionary = (JSON["data"] as!NSDictionary?)!
                                //保存用户名密码
                                saveWithNSUserDefaults(content: self.phoStr!, key: "phone")
                                OilValue.shared.userPhone = self.phoStr!
                                userPhone = OilValue.shared.userPhone
                                saveWithNSUserDefaults(content: self.passStr!, key: "passWord")
                                //保存token
//                                saveWithNSUserDefaults(content: data["token"] as!String, key: "token")
                                OilValue.shared.token = data["token"] as! String
                                token = OilValue.shared.token
                                //保存用户昵称
                                saveWithNSUserDefaults(content: data["custNname"]as!String, key: "custNname")
                                userName = data["custNname"] as!String
                                //保存用户会员号custId
                                saveWithNSUserDefaults(content: data["custNo"]as!String, key: "custNo")
                                //custId
                                saveWithNSUserDefaults(content: data["custId"]as!String, key: "custId")
                                //保存会员头像custImg
                                if data["custImg"] != nil{
                                    headImgStr = data["custImg"]as!String
                                }
                                //                           saveWithNSUserDefaults(content: data["custImg"] as!String, key: "custImg")
                                
                                let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
                                let viewController = mainStoryboard.instantiateInitialViewController()
                                self.present(viewController!, animated: true, completion:nil)
                            }
                            else{
                                //失败
                                loadFailure(msg : JSON["msg"] as!String)
                                print("JSON: \(JSON)()")
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
        passStr = tf.text
    }
    
    override func leftEvent() {
        self.dismiss(animated: true, completion: nil)
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
