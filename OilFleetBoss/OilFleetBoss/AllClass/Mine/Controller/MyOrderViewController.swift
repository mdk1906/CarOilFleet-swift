//
//  MyOrderViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class MyOrderViewController: MDKBaseListViewController{
    var btnStr :String?
    var data = [MyApplymodel]()
    var oilCardData = [MyOilCardListModel]()
    var applyType :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createUI()
        if applyType == "2"{
            self.titleX?.text = "油卡申请"
        }else if applyType == "0"{
            self.titleX?.text = "主卡额度申请"
        }else{
            self.titleX?.text = "分卡额度申请"
        }
        btnStr = "1"
        if applyType == "2" {
            self.getOilCardData()
        }
        else{
           self.getData()
        }
        
        
        
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
        cellID = "MyApplyTableViewCell"
        tableView?.frame = CGRect(x:0,y:114,width:WindowWidth,height:WindowHeight-114)
        let nib = UINib(nibName: String(describing: MyApplyTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        let backView:UIView = UIView()
        backView.backgroundColor = UIColor.white
        backView.frame = CGRect(x:0,y:64,width:WindowWidth,height:50)
        self.view.addSubview(backView)
        let titleArr = ["待审核","已审核","被拒绝"]
        for index in 0..<(titleArr.count) {
            let w = WindowWidth/3
            let btn:UIButton = UIButton()
            backView.addSubview(btn)
            btn.frame = CGRect(x:CGFloat(index)*w,y:4,width:w,height:50)
            btn.tag = index + 1000
            btn.backgroundColor = UIColor.white
            btn.setTitle(titleArr[index], for: .normal)
            btn.setTitleColor(kRGBColorFromHex(rgbValue: 0x333333), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            let hui = UIView.init()
            hui.backgroundColor = homeColor()
            hui.frame = CGRect(x:CGFloat(index)*w+(w-92)/2,y:49,width:92,height:2)
            hui.tag = index + 2000
            backView.addSubview(hui)
            hui.isHidden = true
            if index == 0 {
                btn.setTitleColor(homeColor(), for: .normal)
                hui.isHidden = false
            }
        }
    }
    //MARK: - tableView代理
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if applyType == "2" {
            return self.oilCardData.count
        }
        else{
        return self.data.count
        }
    }
    //绘制cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyApplyTableViewCell
        cell.selectionStyle = .none
        if applyType == "2" {
            cell.MyOilCardListModel = oilCardData[indexPath.row]
        }
        else{
        cell.MyApplymodel = data[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.05
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    func getData()  {
        data = [MyApplymodel]()
        let url = BASE_URL + k_applyList
        let params:Dictionary = ["custId":custId,"offset":"0","limit":"15","applyStatus":btnStr,"applyType":applyType]
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
                                    let post = MyApplymodel(dict: item as! [String: AnyObject])
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
    func getOilCardData()  {
        oilCardData = [MyOilCardListModel]()
        let url = BASE_URL + k_oilCardApplyList
        let params:Dictionary = ["custId":custId,"offset":"0","limit":"15","auditStatus":btnStr]
        print("params = ",params)
        print("url = ",url)
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
                                    let post = MyOilCardListModel(dict: item as! [String: AnyObject])
                                    self.oilCardData.append(post)
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
    func btnClick(btn:UIButton)  {
        if btn.tag == 1000{
            //待审核
            btnStr = "1"
            let btn2 :UIButton = self.view.viewWithTag(1001) as! UIButton
            
            btn2.setTitleColor(UIColor.black, for: .normal)
            
            let btn3 :UIButton = self.view.viewWithTag(1002) as! UIButton
            btn3.setTitleColor(UIColor.black, for: .normal)
            
            let hui1 :UIView = self.view.viewWithTag(2000)!
            hui1.isHidden = false
            let hui2 :UIView = self.view.viewWithTag(2001)!
            hui2.isHidden = true
            let hui3 :UIView = self.view.viewWithTag(2002)!
            hui3.isHidden = true
            
        }
        else if btn.tag == 1001{
            //已审核
            btnStr = "2"
            
            btn.setTitleColor(homeColor(), for: .normal)
            
            let btn2 :UIButton = self.view.viewWithTag(1000) as! UIButton
            
            btn2.setTitleColor(UIColor.black, for: .normal)
            
            let btn3 :UIButton = self.view.viewWithTag(1002) as! UIButton
            btn3.setTitleColor(UIColor.black, for: .normal)
            
            let hui1 :UIView = self.view.viewWithTag(2000)!
            hui1.isHidden = true
            let hui2 :UIView = self.view.viewWithTag(2001)!
            hui2.isHidden = false
            let hui3 :UIView = self.view.viewWithTag(2002)!
            hui3.isHidden = true
            
        }
        else if btn.tag == 1002{
            //拒绝
            btnStr = "3"
            
            btn.setTitleColor(homeColor(), for: .normal)
            
            let btn2 :UIButton = self.view.viewWithTag(1000) as! UIButton
            btn2.setTitleColor(UIColor.black, for: .normal)
            
            let btn3 :UIButton = self.view.viewWithTag(1001) as! UIButton
            btn3.setTitleColor(UIColor.black, for: .normal)
            
            let hui1 :UIView = self.view.viewWithTag(2000)!
            hui1.isHidden = true
            let hui2 :UIView = self.view.viewWithTag(2001)!
            hui2.isHidden = true
            let hui3 :UIView = self.view.viewWithTag(2002)!
            hui3.isHidden = false
            
        }
        if applyType == "2" {
            self.getOilCardData()
        }
        else{
            self.getData()
        }
    }
}
