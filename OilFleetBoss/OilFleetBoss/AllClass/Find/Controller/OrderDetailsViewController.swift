//
//  OrderDetailsViewController.swift
//  CarOilFleetService
//
//  Created by mdk mdk on 17/10/13.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class OrderDetailsViewController: MDKBaseListViewController {
    var data = [OrderDetailsModel]()
    var uid :Int?
    var dataDic:Dictionary<String,Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "订单详情"
        self.createUI()
        self.getData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI()  {
        cellID = "OrderDetailsTableViewCell"
        tableView?.frame = CGRect(x:0,y:64,width:WindowWidth,height:WindowHeight-64)
        let nib = UINib(nibName: String(describing: OrderDetailsTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        
        
        
    }
    func createHeadView()  {
        let headView :UIView = UIView.init()
        headView.backgroundColor = UIColor.white
        tableView?.tableHeaderView = headView
        headView.frame = CGRect(x:0,y:0,width:0,height:270)
        
        let orderNumLab :UILabel = UILabel.init()
        let pr:String = dataDic?["province"] as! String
        let county :String = dataDic?["county"] as! String
        let city :String = dataDic?["city"] as! String
        let address :String = dataDic?["address"] as!String
        orderNumLab.text = "要油品类：柴油"
        orderNumLab.font = UIFont.systemFont(ofSize: 14)
        headView.addSubview(orderNumLab)
        orderNumLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        orderNumLab.snp.makeConstraints { (make)->Void in
            make.top.equalTo(16)
            make.left.equalTo(14)
            make.right.equalTo(0)
            make.height.equalTo(14)
        }
        
        let oilSiteLab :UILabel = UILabel.init()
        oilSiteLab.text = "油品单价（当日）：6.38元/升"
        oilSiteLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        oilSiteLab.font = UIFont.systemFont(ofSize: 14)
        headView.addSubview(oilSiteLab)
        oilSiteLab.snp.makeConstraints { (make)->Void in
            make.top.equalTo(orderNumLab.snp.bottom).offset(17)
            make.left.equalTo(14)
            make.right.equalTo(0)
            make.height.equalTo(14)
        }
        
        let oilTypeLab :UILabel = UILabel.init()
        let oilNum :Int = dataDic?["oilQuantity"] as! Int
        oilTypeLab.text = "油品数量：" + oilNum.description
        oilTypeLab.font = UIFont.systemFont(ofSize: 14)
        oilTypeLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        headView.addSubview(oilTypeLab)
        oilTypeLab.snp.makeConstraints { (make)->Void in
            make.top.equalTo(oilSiteLab.snp.bottom).offset(17)
            make.left.equalTo(14)
            make.right.equalTo(0)
            make.height.equalTo(14)
        }
        
        let oilAmountLab :UILabel = UILabel.init()
        oilAmountLab.font = UIFont.systemFont(ofSize: 15)
        headView.addSubview(oilAmountLab)
        oilAmountLab.textAlignment = .right
        oilAmountLab.snp.makeConstraints { (make)->Void in
            make.top.equalTo(oilSiteLab.snp.bottom).offset(21)
            make.width.equalTo(200)
            make.right.equalTo(-20)
            make.height.equalTo(15)
        }
        
        let oilTimeLab :UILabel = UILabel.init()
        let craeteTime:Int = dataDic?["arriveDate"] as! Int
        oilTimeLab.text = "送达时间：" + timeStampToString(timeStamp: ((craeteTime/1000).description))
        oilTimeLab.font = UIFont.systemFont(ofSize: 14)
        oilTimeLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        headView.addSubview(oilTimeLab)
        oilTimeLab.snp.makeConstraints { (make)->Void in
            make.top.equalTo(oilTypeLab.snp.bottom).offset(17)
            make.left.equalTo(14)
            make.right.equalTo(0)
            make.height.equalTo(15)
        }
        
        let placeTimeLab :UILabel = UILabel.init()
        placeTimeLab.text = "送达地址：" + pr + county + city + address
        placeTimeLab.font = UIFont.systemFont(ofSize: 14)
        placeTimeLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        headView.addSubview(placeTimeLab)
        placeTimeLab.snp.makeConstraints { (make)->Void in
            make.top.equalTo(oilTimeLab.snp.bottom).offset(17)
            make.left.equalTo(14)
            make.right.equalTo(0)
            make.height.equalTo(14)
        }
        
        let placeUserLab :UILabel = UILabel.init()
        if dataDic?["custNname"] == nil{
             placeUserLab.text = "联系人：油站加油"
        }else{
            let custName :String = dataDic?["custNname"] as! String
            placeUserLab.text = "联系人：" + custName
        }
        placeUserLab.font = UIFont.systemFont(ofSize: 14)
        headView.addSubview(placeUserLab)
        placeUserLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        placeUserLab.snp.makeConstraints { (make)->Void in
            make.top.equalTo(placeTimeLab.snp.bottom).offset(17)
            make.left.equalTo(14)
            make.right.equalTo(0)
            make.height.equalTo(14)
        }
        
        let phoBtn :UIButton = UIButton.init()
        phoBtn.setImage(UIImage(named:"电话-拷贝"), for: .normal)
        headView.addSubview(phoBtn)
        phoBtn.snp.makeConstraints { (make)->Void in
            make.right.equalTo(-19)
            make.top.equalTo(placeTimeLab.snp.bottom).offset(21)
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
        let phoNumLab :UILabel = UILabel.init()
        let phoStr :String = dataDic?["tel"] as! String
        phoNumLab.text =  "联系方式：" + phoStr
        phoNumLab.font = UIFont.systemFont(ofSize: 14)
        phoNumLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        headView.addSubview(phoNumLab)
        phoNumLab.textAlignment = .left
        phoNumLab.snp.makeConstraints { (make)->Void in
            make.top.equalTo(placeUserLab.snp.bottom).offset(17)
            make.width.equalTo(200)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        let hui:UIView = UIView.init()
        hui.backgroundColor = huiColor()
        headView.addSubview(hui)
        hui.snp.makeConstraints { (make)->Void in
            make.top.equalTo(phoNumLab.snp.bottom).offset(17)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(39)
        }
        
        let detailsLab = UILabel.init()
        hui.addSubview(detailsLab)
        detailsLab.text = "用油详情"
        detailsLab.font = UIFont.systemFont(ofSize: 14)
        detailsLab.textColor = homeColor()
        detailsLab.snp.makeConstraints { (make)->Void in
            make.left.equalTo(14)
            make.width.equalTo(200)
            make.top.equalTo(0)
            make.height.equalTo(39)
        }
    }
    //MARK: - tableView代理
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    //绘制cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! OrderDetailsTableViewCell
        cell.selectionStyle = .none
        cell.OrderDetailsModel = data[indexPath.row]
        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:WindowWidth-80,y:0,width:80,height:40)
        
        nextBtn.addTarget(self, action:#selector(phoCall) , for: .touchUpInside)
        cell.contentView.addSubview(nextBtn)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    
    func getData()  {
        let url = BASE_URL + k_orderDetail
        let params:Dictionary = ["uid":uid?.description]
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
                            let data = dict["data"]
                            self.dataDic = data.dictionaryObject
                            if let items = data["list"].arrayObject {
                                for item in items {
                                    let post = OrderDetailsModel(dict: item as! [String: AnyObject])
                                    self.data.append(post)
                                }
                                self.createUI()
                                self.createHeadView()
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
    func phoCall(btn:UIButton)  {
        let cell:OrderDetailsTableViewCell = superUITableViewCell(of: btn)!
        let Pho = cell.OrderDetailsModel?.tel?.hexedString()
        let phoStr = "telprompt://" + Pho!
        UIApplication.shared.openURL(NSURL(string :phoStr)! as URL)
        
    }
    //MARK: - 返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> OrderDetailsTableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? OrderDetailsTableViewCell {
                return cell
            }
        }
        return nil
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
