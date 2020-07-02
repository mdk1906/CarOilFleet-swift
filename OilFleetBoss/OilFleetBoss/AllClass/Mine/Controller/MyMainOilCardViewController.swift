//
//  MyMainOilCardViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class MyMainOilCardViewController: MDKBaseListViewController{
    var data = [MyConstructionModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "我的账户"
        // Do any additional setup after loading the view.
        cellID = "MyMainOilCardTableViewCell"
        tableView?.frame = CGRect(x:0,y:64,width:WindowWidth,height:WindowHeight-49)
        let nib = UINib(nibName: String(describing: MyMainOilCardTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        
        let matchAnimator = FNMatchPullAnimator(frame: CGRect(x: 0, y: 0, width: WindowWidth, height: 80))
        matchAnimator.text = "HELLO,OIL"
        matchAnimator.style = .text
        
        tableView?.addPullToRefreshWithAction({
            OperationQueue().addOperation {
                self.getData()
            }
        }, withAnimator: matchAnimator)
        
        self.getData()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyMainOilCardTableViewCell
        cell.selectionStyle = .none
        cell.MyConstructionModel = data[indexPath.row]
        cell.contentView.backgroundColor = huiColor()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyOilCardViewController()
        vc.oilCardNum = self.data[indexPath.row].oilCardNum
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 211
    }
    //MARK :获取数据
    func getData()  {
        data = [MyConstructionModel]()
        let url = BASE_URL + k_siteList
        //"token":token,
        let params:Dictionary = ["custId":custId,"offset":"0","limit":"15"]
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
                                    let post = MyConstructionModel(dict: item as! [String: AnyObject])
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
    
}
