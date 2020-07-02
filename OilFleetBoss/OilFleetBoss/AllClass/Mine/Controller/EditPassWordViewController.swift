//
//  EditPassWordViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/11/6.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class EditPassWordViewController: MDKBaseViewController {

    var oldPass:String?
    var newPass:String?
    var newPass2 :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "修改密码"
        // Do any additional setup after loading the view.
        self.createUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createUI()  {
        let titleArr = ["请输入原密码","请输入新密码","请再次输入新密码"]
        for index in 0..<3 {
            let view :UIView = UIView.init()
            view.backgroundColor = UIColor.white
            self.view.addSubview(view)
            view.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(45)
                make.top.equalTo(64+10+index*45)
                
            })
            
            let tf :UITextField = UITextField.init()
            tf.font = UIFont.systemFont(ofSize: 14)
            tf.placeholder = titleArr[index]
            tf.addTarget(self, action: #selector(tfInput), for: .editingChanged)
            view.addSubview(tf)
            tf.isSecureTextEntry = true
            tf.tag = index + 100
            tf.delegate = self
            tf.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(45)
                make.top.equalTo(0)
                
            })
            
            let hui:UIView = UIView.init()
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
        nextBtn.frame = CGRect(x:20,y:259,width:WindowWidth-40,height:40)
        nextBtn.backgroundColor = homeColor()
        nextBtn.setTitle("确认修改密码", for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 4
        nextBtn.addTarget(self, action:#selector(btnClick) , for: .touchUpInside)
        self.view.addSubview(nextBtn)
    }

    func tfInput(tf:UITextField)  {
        if tf.tag == 100{
            oldPass = tf.text
        }
        else if tf.tag == 101{
            newPass = tf.text
        }
        else if tf.tag == 102{
            newPass2 = tf.text
        }
    }
    func btnClick()  {
        if oldPass == nil{
            loadFailure(msg: "请输入原密码")
        }
        else if newPass == nil{
            loadFailure(msg: "请输入新密码")
        }
        else if newPass2 == nil{
            loadFailure(msg: "请输入新密码")
        }
        else if newPass != newPass2{
            loadFailure(msg: "两次密码输入不一致")
        }
        else{
        let url = BASE_URL + k_editPassword
        //"token":token,
        let params:Dictionary = ["custId":custId,"password":oldPass?.MD5(),"newPassword":newPass?.MD5()]
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
                            let defaults = UserDefaults.standard;
                            defaults.removeSuite(named: "custImg")
                            defaults.removeSuite(named: "custNname")
                            defaults.removeSuite(named: "custNo")
                            defaults.removeSuite(named: "phoneNum")
                            defaults.removeSuite(named: "passWord")
                            defaults.removeSuite(named: "custId")
                            OilValue.shared.token = ""
                            print("token123 = ",OilValue.shared.token)
                            let vc = LoginViewController()
                            vc.tuichu = "1"
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
