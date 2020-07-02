//
//  MyConstructionViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class MyConstructionViewController: MDKBaseListViewController {
    let dataArr :NSArray? = nil
    
    var data = [MyConstructionModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "我的工地"
        self.rightBtn?.setTitle("新增", for: .normal)
        // Do any additional setup after loading the view.
        self.createUI()
//        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.getData()
    }
    func createUI()  {
        cellID = "MyConstructionTableViewCell"
        tableView?.frame = CGRect(x:0,y:64,width:WindowWidth,height:WindowHeight-64)
        let nib = UINib(nibName: String(describing: MyConstructionTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        let matchAnimator = FNMatchPullAnimator(frame: CGRect(x: 0, y: 0, width: WindowWidth, height: 80))
        matchAnimator.text = "HELLO,OIL"
        matchAnimator.style = .text
        
        tableView?.addPullToRefreshWithAction({
            OperationQueue().addOperation {
                self.getData()
            }
        }, withAnimator: matchAnimator)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyConstructionTableViewCell
        cell.selectionStyle = .none
        cell.MyConstructionModel = data[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.05
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditSiteViewController()
        vc.model = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    override func rightEvent() {
        let vc = AddNewSiteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func getData()  {
        data = [MyConstructionModel]()
        let url = BASE_URL + k_siteList
        //"token":token,
        let params:Dictionary = ["custId":custId,"offset":"0","limit":"15"]
        loading()
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
    
    
    //返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> MyConstructionTableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? MyConstructionTableViewCell {
                return cell
            }
        }
        return nil
    }
}
