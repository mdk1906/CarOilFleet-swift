//
//  WorkerDetaileViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/26.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MessageUI
class WorkerDetaileViewController: MDKBaseViewController,MFMessageComposeViewControllerDelegate {
    
    var model :MyWorkerModel?
    
    
    @IBOutlet weak var jiebangBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.titleX?.text = "联系人详情"
        jiebangBtn.layer.cornerRadius = 4
        jiebangBtn.layer.masksToBounds = true
        
        print("model = ",model)
        self.createUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createUI()  {
        let titleArr = ["","手机","工种","工地","卡号","雇工时间"]
        let contentArr = [(model?.custNname)!,model?.custPhone,(model?.workType)!,model?.engName,(model?.oilCardNum)!,timeStampToString(timeStamp: (((model?.createDate)!/1000).description))]
        for index in 0..<titleArr.count {
            let view = UIView.init()
            view.backgroundColor = UIColor.white
            self.view.addSubview(view)
            view.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(0)
                make.height.equalTo(46)
                make.right.equalTo(0)
                make.top.equalTo(64+CGFloat(index)*46)
            })
            
            let titleLab = UILabel.init()
            titleLab.text = titleArr[index]
            view.addSubview(titleLab)
            titleLab.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(14)
                make.height.equalTo(46)
                make.width.equalTo(300)
                make.top.equalTo(0)
            })
            titleLab.font = UIFont.systemFont(ofSize: 14)
            titleLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            
            let contentLab = UILabel.init()
            contentLab.text = contentArr[index]
            view.addSubview(contentLab)
            contentLab.snp.makeConstraints({ (make)->Void in
                make.right.equalTo(-15)
                make.height.equalTo(46)
                make.width.equalTo(200)
                make.top.equalTo(0)
            })
            contentLab.textAlignment = .right
            contentLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            contentLab.font = UIFont.systemFont(ofSize: 14)
            
            let hui = UIView.init()
            hui.backgroundColor = huiColor()
            view.addSubview(hui)
            hui.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(0)
                make.height.equalTo(1)
                make.bottom.equalTo(-1)
                make.right.equalTo(0)
            })
            
            if index == 0{
                titleLab.isHidden = true
                
                let manImg = UIImageView.init()
                manImg.image = UIImage(named:"身份证")
                view.addSubview(manImg)
                manImg.snp.makeConstraints({ (make)->Void in
                    make.left.equalTo(14)
                    make.height.equalTo(30)
                    make.width.equalTo(30)
                    make.top.equalTo(8)
                })
                manImg.layer.cornerRadius = 15
                manImg.layer.masksToBounds = true
                
                contentLab.snp.makeConstraints({ (make)->Void in
                    make.left.equalTo(manImg.snp.right).offset(12)
                    make.height.equalTo(46)
                    make.width.equalTo(200)
                    make.top.equalTo(0)
                })
                contentLab.textAlignment = .left
            }
            if index == 1{
                contentLab.isHidden = true
                titleLab.text = "手机   " + contentArr[index]!
                titleLab.frame.size.width = 300
                let phoBtn = UIButton.init()
                phoBtn.addTarget(self, action: #selector(phoCall), for: .touchUpInside)
                view.addSubview(phoBtn)
                phoBtn.setImage(UIImage(named:"电话"), for: .normal)
                phoBtn.snp.makeConstraints({ (make)->Void in
                    make.right.equalTo(-70)
                    make.top.equalTo(13)
                    make.height.equalTo(20)
                    make.width.equalTo(16)
                })
                
                let messageBtn = UIButton.init()
                messageBtn.addTarget(self, action: #selector(messageClick), for: .touchUpInside)
                view.addSubview(messageBtn)
                messageBtn.setImage(UIImage(named:"-消息"), for: .normal)
                messageBtn.snp.makeConstraints({ (make)->Void in
                    make.right.equalTo(-15)
                    make.top.equalTo(15)
                    make.height.equalTo(17)
                    make.width.equalTo(17)
                })
            }
            
        }
    }
    func messageClick()  {
        //设置联系人
        let str = model?.custPhone
        //创建一个弹出框提示用户
        let alertController = UIAlertController(title: "发短信", message: "是否给\((model?.custNname)!)发送短信?", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sendAction = UIAlertAction(title: "确定", style: .default) { (alertController) in
            //判断设备是否能发短信(真机还是模拟器)
            if MFMessageComposeViewController.canSendText() {
                let controller = MFMessageComposeViewController()
                //短信的内容,可以不设置
//                controller.body = "发短信"
                //联系人列表
                controller.recipients = [str!]
                //设置代理
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            } else {
                print("本设备不能发短信")
            }
        }
        alertController.addAction(cancleAction)
        alertController.addAction(sendAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func phoCall()  {
        let Pho = model?.custPhone
        let phoStr = "telprompt://" + Pho!
        UIApplication.shared.openURL(NSURL(string :phoStr)! as URL)
    }
    @IBAction func jiebangClick(_ sender: Any) {
        let url = BASE_URL + k_employeeDel
        let params:Dictionary = ["custId":custId!,"uid":model!.uid?.description]
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
    
    //实现MFMessageComposeViewControllerDelegate的代理方法
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        //判断短信的状态
        switch result{
            
        case .sent:
            print("短信已发送")
        case .cancelled:
            print("短信取消发送")
        case .failed:
            print("短信发送失败")
        default:
            print("短信已发送")
            break
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
