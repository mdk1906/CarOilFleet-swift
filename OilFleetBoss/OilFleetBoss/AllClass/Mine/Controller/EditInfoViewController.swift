//
//  EditInfoViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/11.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class EditInfoViewController: MDKBaseViewController {
    var textStr :String?
    var titleStr :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = titleStr
        self.createUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI()  {
        let tf :UITextField = UITextField.init()
        self.view.addSubview(tf)
        tf.layer.cornerRadius = 4
        tf.layer.masksToBounds = true
        tf.layer.borderColor = homeColor().cgColor
        tf.layer.borderWidth = 1
        tf.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
        tf.snp.makeConstraints { (make)->Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(84)
            make.height.equalTo(40)
        }
        if titleX?.text == "修改昵称"{
            tf.placeholder = "请输入您的昵称"
        }
        if titleX?.text == "修改地址"{
            tf.placeholder = "请输入您的地址"
        }
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
    func tfInPut(tf:UITextField)  {
        if titleX?.text == "修改昵称"{
            textStr = tf.text!
        }
        if titleX?.text == "修改地址"{
            textStr = tf.text!
        }
    }
    
    func btnClick()  {
        let url = BASE_URL + k_modify
        var params:Dictionary = ["custId":custId]
        
        if titleX?.text == "修改昵称"{
           params = ["custId":custId,"nickName":textStr]
        }
        else if titleX?.text == "修改地址"{
            params = ["custId":custId,"location":textStr]
        }
        if textStr == nil  {
            loadFailure(msg: "请填写信息")
        }
        else {
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
                            self.navigationController?.popViewController(animated: true)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
