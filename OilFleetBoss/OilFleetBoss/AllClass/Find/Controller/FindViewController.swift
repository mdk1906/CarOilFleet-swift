
//
//  FindViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/14.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class FindViewController: MDKBaseListViewController{
    var data = [MyWorkerModel]()
    var jiebangBtn :UIButton?
    var postDic = Dictionary<String, NSObject>()
    var xuanzhongCell = Dictionary<MyWorkerTableViewCell,NSObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.titleX?.text = "我的雇工"
        self.rightBtn?.setTitle("新增", for: .normal)
        self.createUI()
        self.createTable()
        self.getData()
        self.dibuBtn()
        postDic = ["custId":custId! as NSObject]
        NotificationCenter.default.addObserver(self, selector: #selector(fresh), name: NSNotification.Name.init("freshUI"), object: nil)
    }
    func fresh()  {
        self.getData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createTable()  {
        cellID = "MyWorkerTableViewCell"
        tableView?.frame = CGRect(x:0,y:104,width:WindowWidth,height:WindowHeight-49)
        let nib = UINib(nibName: String(describing: MyWorkerTableViewCell.self), bundle: nil)
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
    func createUI()  {
        let headView2:UIView = UIView.init(frame: CGRect(x:0,y:64,width:WindowWidth,height:40))
        headView2.backgroundColor = kRGBColorFromHex(rgbValue: 0xeeeeee)
        self.view.addSubview(headView2)
        
        let tf:UITextField = UITextField(frame:
            CGRect(origin: CGPoint(x: 10, y: 5),
                   size: CGSize(width: WindowWidth-25-90, height: 30)))
        tf.delegate = self
        tf.placeholder = "搜索"
        tf.backgroundColor = UIColor.white
        tf.textAlignment = .center
        tf.layer.cornerRadius = 4
        tf.layer.masksToBounds = true
        headView2.addSubview(tf)
        
        let finshBtn:UIButton = UIButton.init(frame: CGRect(x:WindowWidth-25-90+5+15,y:5,width:90,height:30))
        finshBtn.layer.cornerRadius = 4
        finshBtn.layer.masksToBounds = true
        finshBtn.backgroundColor = homeColor()
        finshBtn.setTitle("编辑", for: .normal)
        finshBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        finshBtn.setTitleColor(UIColor.white, for: .normal)
        headView2.addSubview(finshBtn)
    }
    func dibuBtn()  {
        
        jiebangBtn = UIButton.init(frame: CGRect(x:20,y:WindowHeight-49-50,width:WindowWidth-40,height:40))
        jiebangBtn?.backgroundColor = homeColor()
        jiebangBtn?.setTitle("解绑选中雇工", for: .normal)
        jiebangBtn?.setTitleColor(UIColor.white, for: .normal)
        jiebangBtn?.addTarget(self, action: #selector(jiebangWorker), for: .touchUpInside)
        jiebangBtn?.layer.cornerRadius = 4
        jiebangBtn?.layer.masksToBounds = true
        jiebangBtn?.isHidden = true
        self.view.addSubview(jiebangBtn!)
        
        
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
        //let cell = MyWorkerTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "MyWorkerTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyWorkerTableViewCell
        cell.selectionStyle = .none
        cell.MyWorkerModel = data[indexPath.row]
        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:WindowWidth-80,y:0,width:80,height:40)
        
        nextBtn.addTarget(self, action:#selector(phoCall) , for: .touchUpInside)
        cell.contentView.addSubview(nextBtn)
        if cell.MyWorkerModel?.xuanzhong == "2"{
            cell.xuanzhongBtn.addTarget(self, action: #selector(xuanze), for: .touchUpInside)
        }
        else if cell.MyWorkerModel?.xuanzhong == "1"{
            cell.xuanzhongBtn.addTarget(self, action: #selector(fanxuan), for: .touchUpInside)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.05
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WorkerDetaileViewController()
        vc.model = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - 选择按钮
    func xuanze(btn:UIButton)  {
        let cell:MyWorkerTableViewCell = superUITableViewCell(of: btn)!
        workerXuanZe = "开始编辑"
        cell.MyWorkerModel?.xuanzhong = "1"
        postDic["uid"] = cell.MyWorkerModel?.uid?.description as NSObject?
        xuanzhongCell[cell] = "0" as NSObject?
        print(xuanzhongCell)
        self.tableView?.reloadData()
        
    }
    func fanxuan(btn:UIButton)  {
        let cell:MyWorkerTableViewCell = superUITableViewCell(of: btn)!
        workerXuanZe = "开始编辑"
        cell.MyWorkerModel?.xuanzhong = "2"
        xuanzhongCell.removeValue(forKey: cell)
        
        self.tableView?.reloadData()
        
    }
    //MARK: - 编辑按钮
    func btnClick(btn:UIButton)  {
        workerXuanZe = "编辑"
        jiebangBtn?.isHidden = false
        self.rightBtn?.isHidden = true
        self.tableView?.reloadData()
        btn.setTitle("完成", for: .normal)
        btn.addTarget(self, action: #selector(finish), for: .touchUpInside)
    }
    //MARK: - 完成按钮
    func finish(btn :UIButton)  {
        workerXuanZe = "未编辑"
        jiebangBtn?.isHidden = true
        self.rightBtn?.isHidden = false
        self.tableView?.reloadData()
        btn.setTitle("编辑", for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
    }
    func jiebangWorker(btn:UIButton) {
        let url = BASE_URL + k_delEmpoys
        
        var uid:String = ""
        var uidArr = [Int]()
        for (key, _) in xuanzhongCell {
            let cell :MyWorkerTableViewCell = key
            uid = uid + (cell.MyWorkerModel?.uid?.description)! + ","
            uidArr.append((cell.MyWorkerModel?.uid)!)
        }
        let params:Dictionary = ["uids":uid]
        print(params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
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
    override func rightEvent() {
        let vc = AddNewWorkerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK : - 获取数据
    
    func getData()  {
        data = [MyWorkerModel]()
        workerXuanZe = "未编辑"
        xuanzhongCell = Dictionary<MyWorkerTableViewCell,NSObject>()
        let url = BASE_URL + k_employeeList
        let params:Dictionary = ["custId":custId,"offset":"0","limit":"200"]
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
                                for  item in items {
                                    //
                                    print(item)
                                    let post = MyWorkerModel(dict: item as! [String: AnyObject])
                                    
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
    //MARK: - 打电话
    func phoCall(btn:UIButton)  {
        let cell:MyWorkerTableViewCell = superUITableViewCell(of: btn)!
        let Pho = cell.MyWorkerModel?.custPhone
        let phoStr = "telprompt://" + Pho!
        UIApplication.shared.openURL(NSURL(string :phoStr)! as URL)
        
    }
    //MARK: - 返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> MyWorkerTableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? MyWorkerTableViewCell {
                return cell
            }
        }
        return nil
    }
    
}
