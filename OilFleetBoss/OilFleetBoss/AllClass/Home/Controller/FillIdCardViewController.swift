//
//  FillIdCardViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class FillIdCardViewController: MDKBaseViewController {
    var uid:String?
    let picker: UIImagePickerController = UIImagePickerController()
    var keyId :String?
    var zhengmiantu:String?
    var fanmiantu:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "申请油卡"
        self.view.backgroundColor = UIColor.white
        self.createUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func createUI()  {
        let zhengmianView:UIButton = UIButton()
        zhengmianView.layer.cornerRadius = 4
        zhengmianView.layer.masksToBounds = true
        zhengmianView.layer.borderColor = kRGBColorFromHex(rgbValue: 0x000000).cgColor
        zhengmianView.layer.borderWidth = 1
        zhengmianView.addTarget(self, action: #selector(zhengmianClick), for: .touchUpInside)
        zhengmianView.tag = 100
        self.view.addSubview(zhengmianView)
        zhengmianView.snp.makeConstraints { (make)->Void in
            make.top.equalTo(104)
            //            make.centerX.equalTo(self.view)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(156)
        }
        let add:UIImageView = UIImageView()
        add.image = UIImage(named:"+-拷贝")
        zhengmianView.addSubview(add)
        add.tag = 1000
        add.snp.makeConstraints { (make)->Void in
            make.left.equalTo(64)
            make.top.equalTo(48)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        let titleLab:UILabel = UILabel()
        titleLab.text = "上传身份证正面"
        titleLab.textColor = kRGBColorFromHex(rgbValue: 0x000000)
        titleLab.textAlignment = .left
        titleLab.font = UIFont.systemFont(ofSize: 14)
        zhengmianView.addSubview(titleLab)
        titleLab.tag = 1001
        titleLab.snp.makeConstraints { (make)-> Void in
            make.left.equalTo(add.snp.right).offset(24)
            make.top.equalTo(72)
            make.height.equalTo(14)
            make.width.equalTo(100)
        }
        
        let fanmianView:UIButton = UIButton()
        fanmianView.layer.cornerRadius = 4
        fanmianView.layer.masksToBounds = true
        fanmianView.layer.borderColor = kRGBColorFromHex(rgbValue: 0x000000).cgColor
        fanmianView.layer.borderWidth = 1
        fanmianView.addTarget(self, action: #selector(fanmianClick), for: .touchUpInside)
        fanmianView.tag = 101
        self.view.addSubview(fanmianView)
        fanmianView.snp.makeConstraints { (make)->Void in
            make.top.equalTo(zhengmianView.snp.bottom).offset(40)
            //            make.centerX.equalTo(self.view)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(156)
        }
        let add2:UIImageView = UIImageView()
        add2.image = UIImage(named:"+-拷贝")
        add2.tag = 1002
        fanmianView.addSubview(add2)
        add2.snp.makeConstraints { (make)->Void in
            make.left.equalTo(64)
            make.top.equalTo(48)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        let titleLab2:UILabel = UILabel()
        titleLab2.text = "上传身份证反面"
        titleLab2.textColor = kRGBColorFromHex(rgbValue: 0x000000)
        titleLab2.textAlignment = .left
        titleLab2.font = UIFont.systemFont(ofSize: 14)
        fanmianView.addSubview(titleLab2)
        titleLab2.tag = 1003
        titleLab2.snp.makeConstraints { (make)-> Void in
            make.left.equalTo(add.snp.right).offset(24)
            make.top.equalTo(72)
            make.height.equalTo(14)
            make.width.equalTo(100)
        }
        
        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:20,y:WindowHeight-50,width:WindowWidth-40,height:44)
        nextBtn.backgroundColor = homeColor()
        nextBtn.setTitle("确认提交申请", for: .normal)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        self.view.addSubview(nextBtn)
    }
    func fanmianClick()  {
        keyId = "2"
        let alertController:JWAlertController = JWAlertController(preferredStyle: JWAlertControllerStyle.actionSheet)
        alertController.addAction(actionTitle: "相机", actionStyle: .default, handler: { (action) in
            self.openCamera()
        })
        alertController.addAction(actionTitle: "相册", actionStyle: .default, handler: { (action) in
            self.openSource()
            
        })
        alertController.addAction(actionTitle: "取消", actionStyle: .default, handler: { (action) in
            
        })
        self.present(alertController, animated: true, completion: {
            
        })
    }
    func zhengmianClick()  {
        keyId = "1"
        let alertController:JWAlertController = JWAlertController(preferredStyle: JWAlertControllerStyle.actionSheet)
        alertController.addAction(actionTitle: "相机", actionStyle: .default, handler: { (action) in
            self.openCamera()
        })
        alertController.addAction(actionTitle: "相册", actionStyle: .default, handler: { (action) in
            self.openSource()
            
        })
        alertController.addAction(actionTitle: "取消", actionStyle: .default, handler: { (action) in
            
        })
        self.present(alertController, animated: true, completion: {
            
        })
        
    }
    //MARK:打开相册
    func openSource()  {
        self.picker.sourceType = UIImagePickerControllerSourceType.photoLibrary      //相册  默认
        self.picker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum  //存储
        self.picker.delegate = self
        
        self.picker.allowsEditing = true
        
        //        无法push导航控制器
        //        navigationController?.pushViewController(picker, animated: true)
        
        self.present(self.picker, animated: true, completion: nil)
    }
    //MARK :打开相机
    func openCamera()  {
        //            判断有没有相机
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let alert = UIAlertController(title: "错误", message: "没有相机", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "知道啦", style: .cancel, handler: { [weak self] (UIAlertAction) in
                guard let strongSelf = self else { return }
                strongSelf.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }else{//有相机
            picker.sourceType = UIImagePickerControllerSourceType.camera            //相机
            picker.delegate = self
            
            picker.allowsEditing = true
            
            //        无法push导航控制器
            //        navigationController?.pushViewController(picker, animated: true)
            
            self.present(picker, animated: true, completion: nil)
            
        }
    }
    
    //MARK :下一步
    func nextClick()  {
        
        if zhengmiantu == nil{
            loadFailure(msg: "请上传身份证正面照")
        }
        else if fanmiantu == nil{
            loadFailure(msg: "请上传身份证反面照")
        }else{
            let url = BASE_URL + k_editCard
            //"token":token,
            let params:Dictionary = ["uid":uid,"idUrl1":zhengmiantu,"idUrl2":fanmiantu]
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
                                let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
                                let viewController = mainStoryboard.instantiateInitialViewController()
                                self.present(viewController!, animated: true, completion:nil)
                                
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
}
extension FillIdCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if keyId == "1"{
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage ?? UIImage()
            let zhengmian :UIButton = self.view.viewWithTag(100) as! UIButton
            let add :UIImageView = self.view.viewWithTag(1000) as! UIImageView
            add.isHidden = true
            let titleLab :UILabel = self.view.viewWithTag(1001) as! UILabel
            titleLab.isHidden = true
            zhengmian.setBackgroundImage(image, for: .normal)
            
            //将选择的图片保存到Document目录下
            let fileManager = FileManager.default
            let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .userDomainMask, true)[0] as String
            
            let filePath = "\(rootPath)/pickedimage.jpg"
            
            let imageData = UIImageJPEGRepresentation(image, 0.1)
            
            fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
            
            //上传图片
            if (fileManager.fileExists(atPath: filePath)){
                //取得NSURL
                let imageURL = URL(fileURLWithPath: filePath)
                //使用Alamofire上传
                print("1",imageURL)
                let url = BASE_URL + k_file
                //            "token":token,
                let params:Dictionary = ["custId":custId,"fileType":"1","sourceType":"1","devType":"1"]
                loading()
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in params {
                        multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                    }
                    
                    multipartFormData.append(imageURL, withName: "file")
                }, to:url,headers :["devType":"1","token":token])
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (Progress) in
                            print("当前进度: \(Progress.fractionCompleted)")
                        })
                        upload.responseJSON { response in
                            if let value:NSDictionary = response.result.value as! NSDictionary? {
                                let dict = JSON(value)
                                if dict["ret"].intValue == 1 {
                                    loadSuccess()
                                    //成功
                                    loadSuccess()
                                    let data = dict["data"]
                                    self.zhengmiantu = data["fileUrl"].stringValue
                                    print("JSON: \(value)")
                                    
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
        else{
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage ?? UIImage()
            let fanmian :UIButton = self.view.viewWithTag(101) as! UIButton
            let add :UIImageView = self.view.viewWithTag(1002) as! UIImageView
            add.isHidden = true
            let titleLab :UILabel = self.view.viewWithTag(1003) as! UILabel
            titleLab.isHidden = true
            fanmian.setBackgroundImage(image, for: .normal)
            
            //将选择的图片保存到Document目录下
            let fileManager = FileManager.default
            let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .userDomainMask, true)[0] as String
            
            let filePath = "\(rootPath)/pickedimage.jpg"
            
            let imageData = UIImageJPEGRepresentation(image, 0.1)
            
            fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
            
            //上传图片
            if (fileManager.fileExists(atPath: filePath)){
                //取得NSURL
                let imageURL = URL(fileURLWithPath: filePath)
                //使用Alamofire上传
                print("1",imageURL)
                let url = BASE_URL + k_file
                //            "token":token,
                let params:Dictionary = ["custId":custId,"fileType":"1","sourceType":"1","devType":"1"]
                loading()
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in params {
                        multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                    }
                    
                    multipartFormData.append(imageURL, withName: "file")
                }, to:url,headers :["devType":"1","token":token])
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (Progress) in
                            print("当前进度: \(Progress.fractionCompleted)")
                        })
                        upload.responseJSON { response in
                            if let value:NSDictionary = response.result.value as! NSDictionary? {
                                let dict = JSON(value)
                                if dict["ret"].intValue == 1 {
                                    loadSuccess()
                                    //成功
                                    loadSuccess()
                                    let data = dict["data"]
                                    self.fanmiantu = data["fileUrl"].stringValue
                                    print("JSON: \(value)")
                                    
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
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
