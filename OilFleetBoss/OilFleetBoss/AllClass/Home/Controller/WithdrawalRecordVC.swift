//
//  WithdrawalRecordVC.swift
//  OilFleetDelivery
//
//  Created by mdk mdk on 2018/4/28.
//  Copyright © 2018年 czt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class WithdrawalRecordVC: MDKBaseListViewController {
    var data  = [WithdrawalRecordModel]()
    var btnArr = [UIButton]()
    var btnStr :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "提现记录"
        btnStr = "3"
        // Do any additional setup after loading the view.
        self.createUI()
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createUI()  {
        cellID = "WithdrawalRecordTableViewCell"
        tableView?.frame = CGRect(x:0,y:114,width:WindowWidth,height:WindowHeight-114)
        let nib = UINib(nibName: String(describing: WithdrawalRecordTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        
        let backView:UIView = UIView()
        backView.backgroundColor = UIColor.white
        backView.frame = CGRect(x:0,y:64,width:WindowWidth,height:50)
        self.view.addSubview(backView)
        let titleArr = ["提成","积分","佣金"]
        for index in 0..<(titleArr.count) {
            let w = WindowWidth/3
            let btn:UIButton = UIButton()
            backView.addSubview(btn)
            btn.frame = CGRect(x:CGFloat(index)*w,y:4,width:w,height:50)
            btn.tag = index
            btn.backgroundColor = UIColor.white
            btn.setTitle(titleArr[index], for: .normal)
            btn.setTitleColor(kRGBColorFromHex(rgbValue: 0x333333), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            btnArr.append(btn)
            let hui = UIView.init()
            hui.backgroundColor = homeColor()
            hui.frame = CGRect(x:(w-92)/2,y:49,width:92,height:1)
            hui.tag = index + 2000
            btn.addSubview(hui)
            hui.isHidden = true
            if index == 0 {
                btn.setTitleColor(homeColor(), for: .normal)
                hui.isHidden = false
                let matchAnimator = FNMatchPullAnimator(frame: CGRect(x: 0, y: 0, width: WindowWidth, height: 80))
                matchAnimator.text = "HELLO,OIL"
                matchAnimator.style = .text
                
                tableView?.addPullToRefreshWithAction({
                    OperationQueue().addOperation {
                        //                        self.getData()
                    }
                }, withAnimator: matchAnimator)
                
            }
        }
    }

    func btnClick(btn:UIButton)  {
        for index in btnArr {
            let huitag = index.tag + 2000
            let huiView : UIView = self.view.viewWithTag(huitag)!
            if index == btn{
                btn.setTitleColor(homeColor(), for: .normal)
                huiView.isHidden = false
            }
            else{
                index.setTitleColor(kRGBColorFromHex(rgbValue: 0x333333), for: .normal)
                huiView.isHidden = true
            }
        }
        
        if btn.tag == 0 {
            btnStr = "3"
        }
        else if btn.tag == 1 {
            btnStr = "2"
        }
        else if btn.tag == 2 {
            btnStr = "1"
        }
        self.getData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! WithdrawalRecordTableViewCell
                cell.selectionStyle = .none
                cell.WithdrawalRecordModel = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.05
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.data.count
        return self.data.count
    }
    func getData()  {
        self.data = [WithdrawalRecordModel]()
        let url = BASE_URL + k_WithdrawalRecord
        let params:Dictionary = ["offset":"0","limit":"200","custId":custId,"fromType":btnStr]
        print("url = ",url)
        print("params = ",params)
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
                            if let items = dict["data"].arrayObject {
                                for item in items {
                                    print(item)
                                    let post = WithdrawalRecordModel(dict: item as! [String: AnyObject])
                                    self.data.append(post)
                                }
                                self.tableView?.reloadData()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
