//
//  OilOrderViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/27.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class OilOrderViewController: MDKBaseListViewController {
    
    
    var data = [OilOrderModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "加油下单"
        // Do any additional setup after loading the view.
        self.createUI()
        self.getData()

    }
    
    func createUI()  {
        cellID = "OilOrderTableViewCell"
        tableView?.register(OilOrderTableViewCell.self, forCellReuseIdentifier: cellID)
        let matchAnimator = FNMatchPullAnimator(frame: CGRect(x: 0, y: 0, width: WindowWidth, height: 80))
        matchAnimator.text = "HELLO,OIL"
        matchAnimator.style = .text
        tableView?.addPullToRefreshWithAction({
            OperationQueue().addOperation {
                self.getData()
            }
        }, withAnimator: matchAnimator)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - tableView代理
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        //        return 1
    }
    //绘制cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! OilOrderTableViewCell
        cell.selectionStyle = .none
        cell.OilOrderModel = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.data[indexPath.row]
        let height = 146+5 + (model.list?.count)! * 41 + 40
        
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NowCallOilViewController()
        vc.model = self.data[indexPath.row]
        if (vc.model?.total)! < 2000 {
            loadFailure(msg: "订单需大于2000升")
        }
        else{
        navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getData()  {
        self.data = [OilOrderModel]()
        let url = BASE_URL + k_oilList
        let params:Dictionary = ["offset":"0","limit":"200","custId":custId]
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
                            if let items = dict["data"].arrayObject {
                                for item in items {
                                    print(item)
                                    let post = OilOrderModel(dict: item as! [String: AnyObject])
                                    
                                    self.data.append(post)
                                }
                                if self.data.count == 0{
                                    let alertVC = UIAlertController(title: "提示", message: "请创建工地", preferredStyle: UIAlertControllerStyle.alert)
                                    let acSure = UIAlertAction(title: "跳转", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
                                        //我的工地
                                        let vc = MyConstructionViewController()
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
                                        print("click Cancel")
                                    }
                                    alertVC.addAction(acSure)
                                    alertVC.addAction(acCancel)
                                    self.present(alertVC, animated: true, completion: nil)
                                }
                                //self.createUI()
                                self.tableView?.stopPullToRefresh()
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
}
