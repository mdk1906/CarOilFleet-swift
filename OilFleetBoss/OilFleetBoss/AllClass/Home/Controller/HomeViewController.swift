//
//  HomeViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/27.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class HomeViewController: MDKBaseListViewController {
    
    
    var bannerS = [BannersModel]()
    var bannerImg = Array<String>()
    var titleArr = [String]()
    var data = [OilOrderModel]()
    var headview :UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Nav?.isHidden = true
        titleArr = ["","",""]
        //        self.createUI()
        //        self.newUI()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        //        self.getBanners()
        
        cellID = "OilOrderTableViewCell"
        self.tableView?.frame = CGRect(x:0,y:157+93+10,width:WindowWidth,height:WindowHeight-(157+93+10)-49)
        tableView?.register(OilOrderTableViewCell.self, forCellReuseIdentifier: cellID)
        let matchAnimator = FNMatchPullAnimator(frame: CGRect(x: 0, y: 0, width: WindowWidth, height: 80))
        matchAnimator.text = "HELLO,OIL"
        matchAnimator.style = .text
        tableView?.addPullToRefreshWithAction({
            OperationQueue().addOperation {
                self.getData()
            }
        }, withAnimator: matchAnimator)
        self.view.addSubview(self.tableView!)
        self.getData()
        self.getmoney()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletefun), name: NSNotification.Name.init("deleteCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clickfun), name: NSNotification.Name.init("ClickCell"), object: nil)
        
    }
    
    func deletefun(noc :Notification)  {
        let dict :Dictionary<String,Any> = noc.object as! Dictionary<String, Any>
        print("dict = ",dict)
        let alertView = UIAlertView.bk_alertView(withTitle: "提示", message: "确定撤销该订单吗？" ) as! UIAlertView
        alertView.bk_addButton(withTitle: "确定") {
            self.cancelOrder(uid: dict["uid"] as? String)
        }
        alertView.bk_addButton(withTitle: "取消") {
            
        }
        alertView.show()
    }
    func cancelOrder(uid:String?)  {
        let url = BASE_URL + k_cancelOrder
        //"token":token,
        let params:Dictionary = ["custId":custId,"uid":uid]
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
    func clickfun(noc :Notification)  {
        let vc = NowCallOilViewController()
        vc.model = noc.object as! OilOrderModel
        if (vc.model?.total)! < 2000 {
            loadFailure(msg: "订单需大于2000升")
        }
        else{
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newUI()  {
        let imgArr = ["油卡(1)","加油卡充值","卡"]
        let titleArr = ["油卡申请","额度申请","额度分配"]
        for index in 0..<imgArr.count {
            let view :UIView = UIView.init()
            self.view.addSubview(view)
            view.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(CGFloat(index)*(WindowWidth/3))
                make.top.equalTo(251)
                make.width.equalTo(WindowWidth/3)
                make.height.equalTo(WindowHeight*0.28)
            })
            view.backgroundColor = UIColor.white
            let titleImg = UIImageView.init()
            view.addSubview(titleImg)
            titleImg.snp.makeConstraints({ (make)->Void in
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.top.equalTo(55)
                make.left.equalTo((WindowWidth/3-30)/2)
            })
            titleImg.image = UIImage(named:imgArr[index])
            
            let titleLab = UILabel.init()
            view.addSubview(titleLab)
            titleLab.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(0)
                make.height.equalTo(14)
                make.width.equalTo(WindowWidth/3)
                make.top.equalTo(101)
            })
            titleLab.font = UIFont.systemFont(ofSize: 14)
            titleLab.text = titleArr[index]
            titleLab.textAlignment = .center
            titleLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            let viewBtn = UIButton.init()
            view.addSubview(viewBtn)
            viewBtn.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(0)
                make.top.equalTo(0)
                make.height.equalTo(WindowHeight*0.28)
                make.width.equalTo(WindowWidth/3)
            })
            viewBtn.tag = index + 1000
            viewBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        }
        
        let orderImg = UIImageView.init()
        self.view.addSubview(orderImg)
        orderImg.snp.makeConstraints { (make)->Void in
            make.height.equalTo(WindowHeight*0.28)
            make.left.equalTo(0)
            make.bottom.equalTo(-45)
            make.width.equalTo(WindowWidth)
        }
        orderImg.image = UIImage(named:"矩形18")
        
        let titleImg = UIImageView.init()
        orderImg.addSubview(titleImg)
        titleImg.snp.makeConstraints({ (make)->Void in
            make.width.equalTo(28)
            make.height.equalTo(27)
            make.top.equalTo(67)
            make.left.equalTo((WindowWidth-28)/2)
        })
        titleImg.image = UIImage(named:"下单管理")
        
        let titleLab = UILabel.init()
        orderImg.addSubview(titleLab)
        titleLab.snp.makeConstraints({ (make)->Void in
            make.left.equalTo(0)
            make.height.equalTo(14)
            make.width.equalTo(WindowWidth)
            make.top.equalTo(116)
        })
        titleLab.font = UIFont.systemFont(ofSize: 14)
        titleLab.text = "加油下单"
        titleLab.textColor = UIColor.white
        titleLab.textAlignment = .center
        
        let orderBtn = UIButton.init()
        self.view.addSubview(orderBtn)
        orderBtn.snp.makeConstraints { (make)->Void in
            make.height.equalTo(WindowHeight*0.28)
            make.left.equalTo(0)
            make.bottom.equalTo(-45)
            make.width.equalTo(WindowWidth)
        }
        orderBtn.addTarget(self, action: #selector(orderClick), for: .touchUpInside)
    }
    
    
    func titleBtnClick(btn:UIButton)  {
        switch btn.tag {
        case 1000:
            //油卡申请
            let vc = OilCardApplyViewController()
            //            let vc = FillIdCardViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1001:
            let vc = MainCardLimitApplyViewController()
            navigationController?.pushViewController(vc, animated: true)
        //额度申请
        case 1002:
            //额度分配
            let vc = LinesDistributionViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    func orderClick()  {
        let vc = OilOrderViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK :获取数据
    func getBanners()  {
        let url = BASE_URL + k_banners
        let params:Dictionary = ["key":"banners2"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
            }
        }, to:url,headers :["devType":"1"])
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
                                    let post = BannersModel(dict: item as! [String: AnyObject])
                                    self.bannerS.append(post)
                                }
                            }
                            print("banners",self.bannerS)
                            for  model  in self.bannerS {
                                let imgStr = FEIL_URL + model.banners!
                                self.bannerImg.append(imgStr)
                                print(self.bannerImg)
                            }
                            
                            let cycleScrollView = MYCycleScrollView.init(frame: CGRect(x:0,y:0,width:WindowWidth,height:220))
                            cycleScrollView.imageURLs = self.bannerImg
                            cycleScrollView.autoScrollTimeInterval = 5
                            cycleScrollView.imageViewContentMode = .scaleAspectFill
                            cycleScrollView.delegate = self
                            self.view.addSubview(cycleScrollView)
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
    
    func createHeadView() {
        self.headview = UIView.init(frame: CGRect(x:0,y:0,width:WindowWidth,height:157+93+10))
        //        view?.backgroundColor = homeColor()
        self.view.addSubview(self.headview!)
        let backImg = UIImageView.init()
        headview?.addSubview(backImg)
        backImg.frame = CGRect(x:0,y:0,width:WindowWidth,height:157)
        backImg.image = UIImage(named:"背景拷贝")
        let imgView:UIImageView = UIImageView.init(frame: CGRect(x:(WindowWidth-60)/2,y:40,width:60,height:60))
        imgView.backgroundColor = UIColor.white
        
        if headImgStr != "默认头像" {
            loading()
            let urlStr = String(FEIL_URL + headImgStr)
            let url = URL.init(string: urlStr!)
            imgView.downloadedFrom(url: url!)
            loadSuccess()
        }else{
            imgView.image = UIImage(named:(headImgStr))
        }
        
        imgView.layer.cornerRadius = 30
        imgView.layer.masksToBounds = true
        headview?.addSubview(imgView)
        
        let nameLab:UILabel = UILabel.init(frame: CGRect(x:0,y:122,width:WindowWidth,height:17))
        nameLab.text = userName
        nameLab.textAlignment = .center
        nameLab.textColor = UIColor.white
        nameLab.font = UIFont.systemFont(ofSize: 13)
        headview?.addSubview(nameLab)
        
        let imgArr = ["提成","积分","佣金"]
        for index in 0..<titleArr.count {
            let view2 = UIButton.init()
            headview?.addSubview(view2)
            view?.backgroundColor = UIColor.white
            view2.frame = CGRect(x:CGFloat(index)*(WindowWidth/3),y:157,width:WindowWidth/3,height:93)
            view2.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            view2.tag = 3000 + index
            let imgView = UIImageView.init()
            imgView.image = UIImage(named:imgArr[index])
            view2.addSubview(imgView)
            imgView.snp.makeConstraints { (make)->Void in
                make.left.equalTo((WindowWidth/3-26)/2)
                make.top.equalTo(24)
                make.height.equalTo(27)
                make.width.equalTo(26)
            }
            let titleLab = UILabel.init()
            view2.addSubview(titleLab)
            titleLab.text = titleArr[index]
            titleLab.font = UIFont.systemFont(ofSize: 14)
            titleLab.textAlignment = .center
            titleLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            titleLab.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(14)
                make.top.equalTo(62)
                
            })
            
            let hui :UIView = UIView.init()
            view2.addSubview(hui)
            hui.snp.makeConstraints({ (make)->Void in
                make.right.equalTo(-1)
                make.height.equalTo(93)
                make.width.equalTo(1)
                make.top.equalTo(0)
            })
            hui.backgroundColor = huiColor()
        }
        let hui :UIView = UIView.init()
        headview?.addSubview(hui)
        hui.snp.makeConstraints({ (make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(10)
            make.top.equalTo(157+93)
            
        })
        hui.backgroundColor = huiColor()
        

        
    }
    func btnClick(btn:UIButton)  {
        if btn.tag == 3000 {
            //提成
            let vc = WithdrawalVC()
            let str = self.titleArr[0]
            let index = str.index(str.startIndex, offsetBy:3)//获取字符d的索引
            vc.count = str.substring(from: index)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if btn.tag == 3001{
            //积分
            let vc = IntegralWithdrawalVC()
            let str = self.titleArr[1]
            let index = str.index(str.startIndex, offsetBy:3)//获取字符d的索引
            vc.count = str.substring(from: index)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if btn.tag == 3002{
            //佣金
            let vc = CommissionWithdrawalVC()
            let str = self.titleArr[2]
            let index = str.index(str.startIndex, offsetBy:3)//获取字符d的索引
            vc.count = str.substring(from: index)
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
//                                if self.data.count == 0{
//                                    let alertVC = UIAlertController(title: "提示", message: "请创建工地", preferredStyle: UIAlertControllerStyle.alert)
//                                    let acSure = UIAlertAction(title: "跳转", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
//                                        //我的工地
//                                        let vc = MyConstructionViewController()
//                                        self.navigationController?.pushViewController(vc, animated: true)
//                                    }
//                                    let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
//                                        print("click Cancel")
//                                    }
//                                    alertVC.addAction(acSure)
//                                    alertVC.addAction(acCancel)
//                                    self.present(alertVC, animated: true, completion: nil)
//                                }
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
        let height = 46+5 + (model.list?.count)! * 41
        
        return CGFloat(height)
    }
    
    func getmoney()  {
        loading()
        self.headview?.removeFromSuperview()
        let url = BASE_URL + k_custInfo
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
                            let money  = Double(data["extractBalance"].stringValue)!/100
                            let extractBalance = "提成：" + money.description
                            let virtualBalance = "积分：" + data["virtualBalance"].stringValue
                            let money2 = Double(data["commissTotal"].stringValue)!/100
                            let commissTotal = "佣金：" + money2.description
                            self.titleArr = [extractBalance,virtualBalance,commissTotal]
                            self.createHeadView()
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
// MARK: - 滚动banner代理方法
extension HomeViewController: MYCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: MYCycleScrollView, didScrollTo index: Int) {
        //print("didScrollTo: \(index)")
    }
    func cycleScrollView(_ cycleScrollView: MYCycleScrollView, didSelectItemAt index: Int) {
        //print("didSelectItemAt: \(index)")
    }
}
