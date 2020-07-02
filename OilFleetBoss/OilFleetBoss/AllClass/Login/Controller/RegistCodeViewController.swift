//
//  RegistCodeViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/9.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegistCodeViewController: MDKBaseViewController {

    @IBOutlet weak var codeTf: UITextField!
    var codeBtn :TimerButton!
    var phoStr :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "注册"
        codeTf.layer.cornerRadius = 4
        codeTf.layer.masksToBounds = true
        codeTf.layer.borderColor = homeColor().cgColor
        codeTf.layer.borderWidth = 1
        codeTf.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
         codeBtn = TimerButton.init(frame: CGRect(x:25+WindowWidth-50-90,y:145,width:90,height:30))
        codeBtn.addTarget(self, action: #selector(codeBtnClick), for: .touchUpInside)
        codeBtn.layer.cornerRadius = 4
        codeBtn.layer.masksToBounds = true
        codeBtn.backgroundColor = homeColor()
        //codeBtn.setTitle("验证码", for: .normal)
        codeBtn.setup("获取验证码", timeTitlePrefix: "剩余")
        codeBtn.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(codeBtn)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func codeBtnClick()  {
        loading()
        let url = BASE_URL + k_sendSms
        let params:Dictionary = ["phone":phoStr,"custId":"","smsType":"1"]
        
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


    func tfInPut(tf:UITextField)  {
        if tf.text?.characters.count == 4 {
            let vc = RegistPassWordViewController()
            vc.phoStr = phoStr
            vc.codeStr = tf.text
            self.present(vc, animated: true, completion: nil)
        }
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
