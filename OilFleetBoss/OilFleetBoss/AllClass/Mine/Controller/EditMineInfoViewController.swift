//
//  EditMineInfoViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/11.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class EditMineInfoViewController: MDKBaseViewController {
    let picker: UIImagePickerController = UIImagePickerController()
    var contentArr :Array<String>?
    
    var backView :UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "个人信息"
        self.getData()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(fresh), name: NSNotification.Name.init("freshUI"), object: nil)
    }
    
    func fresh()  {
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI()  {
        let titleArr:Array = ["头像","邀请码","昵称","手机号码","位置"]
        backView = UIView.init()
        self.view.addSubview(backView!)
        backView?.snp.makeConstraints({ (make)->Void in
            make.top.equalTo(64)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(310)
        })
        for index in 0..<(titleArr.count) {
            let view :UIButton = UIButton.init()
            self.backView?.addSubview(view)
            view.backgroundColor = UIColor.white
            view.tag = index+100
            view.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            if index == 0{
                view.snp.makeConstraints({ (make)-> Void in
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.height.equalTo(45)
                    make.top.equalTo(0)
                })
                
                let touxiangImg :UIImageView = UIImageView.init()
                if headImgStr != "默认头像" {
                    loading()
                    let urlStr = String(FEIL_URL + headImgStr)
                    let url = URL.init(string: urlStr!)
                    touxiangImg.downloadedFrom(url: url!)
                    loadSuccess()
                }else{
                    touxiangImg.image = UIImage(named:(headImgStr))
                }
                
                view.addSubview(touxiangImg)
                touxiangImg.tag = 1000
                touxiangImg.snp.makeConstraints({ (make)->Void in
                    make.top.equalTo(6)
                    make.right.equalTo(-26)
                    make.height.equalTo(33)
                    make.width.equalTo(33)
                })
            }
            else{
                view.snp.makeConstraints({ (make)-> Void in
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.height.equalTo(45)
                    make.top.equalTo(index*45)
                })
            }
            
            let titleLab :UILabel = UILabel.init()
            titleLab.text = titleArr[index]
            titleLab.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(titleLab)
            titleLab.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(23)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                make.width.equalTo(200)
            })
            
            let rightImg :UIImageView = UIImageView.init()
            view.addSubview(rightImg)
            rightImg.image = UIImage(named:"箭头")
            rightImg.snp.makeConstraints({ (make)->Void in
                make.right.equalTo(-14)
                make.top.equalTo(15)
                make.height.equalTo(15)
                make.width.equalTo(8)
            })
            rightImg.isHidden = true
            
            
            
            let contentLab :UILabel = UILabel.init()
            contentLab.text = self.contentArr?[index]
            contentLab.textAlignment = .right
            contentLab.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(contentLab)
            contentLab.snp.makeConstraints({ (make)->Void in
                make.right.equalTo(-26)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                make.width.equalTo(200)
            })
            if  (index == 2 || index == 4 ){
                rightImg.isHidden = false
                
            }
            
            if index == 0{
                contentLab.isHidden = true
            }
            let hui :UIView = UIView.init()
            hui.backgroundColor = huiColor()
            view.addSubview(hui)
            hui.snp.makeConstraints({ (make)->Void in
                make.bottom.equalTo(-1)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(1)
                
            })
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
    func getData()  {
        self.backView?.removeFromSuperview()
        let url = BASE_URL + k_getCus
        //"token":token,
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
                            let data = dict["data"]
                            var add = "请选择地址"
                            let yaoqing = custNo
                            if data["custImg"] != nil{
                                headImgStr = data["custImg"].stringValue
                            }
                            if data["custLocation"] != nil{
                                add = data["custLocation"].stringValue
                            }
                            //没有头像
                            //没有地址
                            //邀请码
                            let username = data["custNname"].stringValue
                            self.contentArr = [headImgStr,yaoqing!,data["custNname"].stringValue,data["custPhone"].stringValue,add]
                            userName = username
                            self.createUI()
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
    //MARK :修改头像
    func postHeadImg()  {
        let url = BASE_URL + k_modify
        //"token":token,
        let params:Dictionary = ["custId":custId,"headImg":headImgStr]
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
                            self.getData()
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
    func btnClick(btn:UIButton)  {
        print(btn.tag)
        if btn.tag == 100 {
            //修改头像
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
        if btn.tag == 102{
            //修改昵称
            let vc = EditInfoViewController()
            vc.titleStr = "修改昵称"
            navigationController?.pushViewController(vc, animated: true)
        }
        if btn.tag == 104{
            //修改地址
            let vc = EditInfoViewController()
            vc.titleStr = "修改地址"
            navigationController?.pushViewController(vc, animated: true)
            
        }
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
    //MARK :返回
    override func leftEvent() {
        NotificationCenter.default.post(name: NSNotification.Name.init("freshUI"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
}

extension EditMineInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage ?? UIImage()
        let headImg :UIImageView = self.view.viewWithTag(1000) as! UIImageView
        headImg.image = image
        
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
            let params:Dictionary = ["custId":custId,"fileType":"1","sourceType":"2","devType":"1"]
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
                                
                                let data = dict["data"]
                                headImgStr = data["fileUrl"].stringValue
                                self.postHeadImg()
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
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
