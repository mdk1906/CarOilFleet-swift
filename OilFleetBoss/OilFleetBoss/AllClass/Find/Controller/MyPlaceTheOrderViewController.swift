//
//  MyPlaceTheOrderViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/10/25.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class MyPlaceTheOrderViewController: MDKBaseListViewController {
    var btnStr :String?
    var data = [MyPlaceTheOrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "订单"
        // Do any additional setup after loading the view.
        self.createUI()
        self.leftBtn?.isHidden = true
        self.leftImg?.isHidden = true
        btnStr = "3"
        self.getData()
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
        cellID = "MyOrderTableViewCell"
        tableView?.frame = CGRect(x:0,y:114,width:WindowWidth,height:WindowHeight-114-45)
        let nib = UINib(nibName: String(describing: MyOrderTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        
        let backView:UIView = UIView()
        backView.backgroundColor = UIColor.white
        backView.frame = CGRect(x:0,y:64,width:WindowWidth,height:50)
        self.view.addSubview(backView)
        let titleArr = ["待接单","待配送","配送中","已支付"]
        for index in 0..<(titleArr.count) {
            let w = WindowWidth/4
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
                        self.getData()
                    }
                }, withAnimator: matchAnimator)
                
            }
        }
    }
    //MARK: - tableView代理
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
        //        return 1
    }
    //绘制cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyOrderTableViewCell
        cell.selectionStyle = .none
        cell.MyPlaceTheOrderModel = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.05
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 181
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderDetailsViewController()
        vc.uid = self.data[indexPath.row].uid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getData()  {
        data = [MyPlaceTheOrderModel]()
        //合并后未抢订单3，完成订单4，
        print("token789 = ",OilValue.shared.token)
        let url = BASE_URL + k_myOrder
        let params:Dictionary = ["custId":custId,"offset":"0","limit":"15","detailsLevel":"2","detailsStatus":btnStr]
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
                                    let post = MyPlaceTheOrderModel(dict: item as! [String: AnyObject])
                                    self.data.append(post)
                                }
                                self.tableView?.reloadData()
                                self.tableView?.stopPullToRefresh()
                                
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
            //待接单
            btnStr = "3"
            btn.setTitleColor(homeColor(), for: .normal)
            
            let btn2 :UIButton = self.view.viewWithTag(1001) as! UIButton
            btn2.setTitleColor(UIColor.black, for: .normal)
            
            let btn3 :UIButton = self.view.viewWithTag(1002) as! UIButton
            btn3.setTitleColor(UIColor.black, for: .normal)
            let btn4 :UIButton = self.view.viewWithTag(1003) as! UIButton
            btn4.setTitleColor(UIColor.black, for: .normal)
            
            let hui1 :UIView = self.view.viewWithTag(2000)!
            hui1.isHidden = false
            let hui2 :UIView = self.view.viewWithTag(2001)!
            hui2.isHidden = true
            let hui3 :UIView = self.view.viewWithTag(2002)!
            hui3.isHidden = true
            let hui4 :UIView = self.view.viewWithTag(2003)!
            hui4.isHidden = true
            self.getData()
        }
        else if btn.tag == 1001{
            //待配送
            btnStr = "4"
            btn.setTitleColor(homeColor(), for: .normal)
            
            let btn2 :UIButton = self.view.viewWithTag(1000) as! UIButton
            btn2.setTitleColor(UIColor.black, for: .normal)
            
            let btn3 :UIButton = self.view.viewWithTag(1002) as! UIButton
            btn3.setTitleColor(UIColor.black, for: .normal)
            let btn4 :UIButton = self.view.viewWithTag(1003) as! UIButton
            btn4.setTitleColor(UIColor.black, for: .normal)
            
            let hui1 :UIView = self.view.viewWithTag(2000)!
            hui1.isHidden = true
            let hui2 :UIView = self.view.viewWithTag(2001)!
            hui2.isHidden = false
            let hui3 :UIView = self.view.viewWithTag(2002)!
            hui3.isHidden = true
            let hui4 :UIView = self.view.viewWithTag(2003)!
            hui4.isHidden = true
            self.getData()
        }
        else if btn.tag == 1002{
            //配送中
            btnStr = "6"
            
            btn.setTitleColor(homeColor(), for: .normal)
            
            let btn2 :UIButton = self.view.viewWithTag(1000) as! UIButton
            btn2.setTitleColor(UIColor.black, for: .normal)
            
            let btn3 :UIButton = self.view.viewWithTag(1001) as! UIButton
            btn3.setTitleColor(UIColor.black, for: .normal)
            let btn4 :UIButton = self.view.viewWithTag(1003) as! UIButton
            btn4.setTitleColor(UIColor.black, for: .normal)
            
            let hui1 :UIView = self.view.viewWithTag(2000)!
            hui1.isHidden = true
            let hui2 :UIView = self.view.viewWithTag(2002)!
            hui2.isHidden = false
            let hui3 :UIView = self.view.viewWithTag(2001)!
            hui3.isHidden = true
            let hui4 :UIView = self.view.viewWithTag(2003)!
            hui4.isHidden = true
            self.getData()
        }
        else if btn.tag == 1003{
            //已支付
            btnStr = "5"
            btn.setTitleColor(homeColor(), for: .normal)
            
            let btn2 :UIButton = self.view.viewWithTag(1000) as! UIButton
            btn2.setTitleColor(UIColor.black, for: .normal)
            
            let btn3 :UIButton = self.view.viewWithTag(1001) as! UIButton
            btn3.setTitleColor(UIColor.black, for: .normal)
            let btn4 :UIButton = self.view.viewWithTag(1002) as! UIButton
            btn4.setTitleColor(UIColor.black, for: .normal)
            
            let hui1 :UIView = self.view.viewWithTag(2000)!
            hui1.isHidden = true
            
            let hui2 :UIView = self.view.viewWithTag(2001)!
            hui2.isHidden = true
            let hui4 :UIView = self.view.viewWithTag(2002)!
            hui4.isHidden = true
            let hui3 :UIView = self.view.viewWithTag(2003)!
            hui3.isHidden = false
            
            self.getData()
        }
    }
    
}
