//
//  LinesDistributionViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class LinesDistributionViewController: MDKBaseViewController ,UITableViewDataSource,UITableViewDelegate {
    
    var tableView:UITableView?
    let cellID = "LinesDistributionTableViewCell"
    var data = [LinesDistributionModel]()
    var xuanzhongCell = Dictionary<LinesDistributionTableViewCell,NSObject>()
    var cellList = Dictionary<String,Any>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "分卡额度分配"
        self.rightBtn?.setTitle("分配记录", for: .normal)
        // Do any additional setup after loading the view.
        self.createUI()
        self.getData()
        NotificationCenter.default.addObserver(self, selector: #selector(addMoney), name: NSNotification.Name.init("addMoney"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newMoney), name: NSNotification.Name.init("newMoney"), object: nil)
        
    }
    func newMoney(noc :Notification)  {
        let dic :Dictionary <String,Any> = noc.object as! Dictionary
        let oilCardNum :String = dic["oilCardNum"] as! String
        cellList[oilCardNum] = dic
        
    }
    func addMoney(noc :Notification)  {
        let dic :Dictionary <String,NSObject> = noc.object as! Dictionary
        //let k = Int((dic["inde"]?.description)!)!
        let money :String = (dic["money"]?.description)!
        let oilCardNum :String = dic["oilCardNum"] as! String
        for (key,_) in cellList {
            if oilCardNum == key {
                var dict :Dictionary<String,Any> = cellList[key] as! Dictionary<String, Any>
                dict["money"] = money
                cellList[key] = dict
                
            }
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
        tableView = UITableView()
        tableView?.frame = CGRect(x:0,y:64,width:WindowWidth,height:WindowHeight-64)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = UIColor.white
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView?.register(LinesDistributionTableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView!)
        
        let matchAnimator = FNMatchPullAnimator(frame: CGRect(x: 0, y: 0, width: WindowWidth, height: 80))
        matchAnimator.text = "HELLO,OIL"
        matchAnimator.style = .text
        
        tableView?.addPullToRefreshWithAction({
            OperationQueue().addOperation {
                self.getData()
            }
        }, withAnimator: matchAnimator)
        
        let tijiaoBtn :UIButton = UIButton.init(frame: CGRect(x:21,y:WindowHeight-50,width:WindowWidth-42,height:44))
        tijiaoBtn.backgroundColor = homeColor()
        tijiaoBtn.layer.masksToBounds = true
        tijiaoBtn.layer.cornerRadius = 5
        tijiaoBtn.setTitle("提交分配", for: .normal)
        self.view.addSubview(tijiaoBtn)
        tijiaoBtn.addTarget(self, action: #selector(tijiaofenpei), for: .touchUpInside)
        tijiaoBtn.setTitleColor(UIColor.white, for: .normal)
        tijiaoBtn.snp.makeConstraints { (make)->Void in
            make.bottom.equalTo(self.view).offset(-10)
            make.left.equalTo(self.view).offset(21)
            make.right.equalTo(self.view).offset(-21)
            make.height.equalTo(44)
        }
        
        
        
    }
    //MARK: - tableView代理
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    //绘制cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! LinesDistributionTableViewCell
        cell.selectionStyle = .none
        cell.LinesDistributionModel = data[indexPath.row]
        
        xuanzhongCell[cell] = "0" as NSObject?
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.data[indexPath.row]
        let height = 40 + (model.list?.count)! * 46
        return CGFloat(height)
        
        
        
    }
    func tijiaofenpei()  {
        let url = BASE_URL + k_oilCardAddBlance
        var arr = Array<JSON>()
        
        for (_,value) in cellList {
            let dict :Dictionary<String,Any> = value as! Dictionary<String, Any>
            print("index" ,index)
            let m :String = dict["money"] as! String
            var mone :Int?
            if m.characters.count == 0 {
                mone = Int(0)
            }else{
                mone  = Int(Double(m)!*100)
            }
            
            
            let dic:JSON = ["mainOilCardNum":dict["mainOilCardNum"] as Any,"custNname":dict["custNname"] as! String? as Any,"oilCardNum":dict["oilCardNum"]as! String? as Any,"money":mone!.description,"status":"1"]
            
            arr.append(dic)
            
        }
        let params:Dictionary = ["custId":custId,"balance":arr.description]
        print(params)
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
                            loadFailure(msg: "已提交审核")
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
    func getData()  {
        data = [LinesDistributionModel]()
        xuanzhongCell = Dictionary<LinesDistributionTableViewCell,NSObject>()
        cellList = Dictionary<String,Any>()
        let url = BASE_URL + k_fenkaList
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
                                    print(item)
                                    let post = LinesDistributionModel(dict: item as! [String: AnyObject])
                                    self.data.append(post)
                                    print(self.data)
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
    /**
     字典转换为JSONString
     
     - parameter dictionary: 字典参数
     
     - returns: JSONString
     */
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    override func rightEvent() {
        let vc = MyOrderViewController()
        vc.applyType = "1"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
