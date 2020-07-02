//
//  MyBillViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class MyBillViewController: MDKBaseListViewController{
    var model :MyOilCardModel?
    var data = [MyBillModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "分卡详情"
        // Do any additional setup after loading the view.
        self.createUI()
        
        self.getData()
        self.rightBtn?.setTitle("额度分配", for: .normal)

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
        cellID = "MyBillTableViewCell"
        tableView?.frame = CGRect(x:0,y:179+64,width:WindowWidth,height:WindowHeight-64-179)
        let nib = UINib(nibName: String(describing: MyBillTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        let backView:UIView = UIView()
        backView.backgroundColor = huiColor()
        self.view.addSubview(backView)
        backView.snp.makeConstraints { (make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(179)
            make.top.equalTo(64)
        }
        
        let cardView:UIView = UIView()
        cardView.backgroundColor = homeColor()
        cardView.layer.cornerRadius = 4
        cardView.layer.masksToBounds = true
        backView.addSubview(cardView)
        cardView.snp.makeConstraints { (make)->Void in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(15)
            make.height.equalTo(124)
        }
        let diImg = UIImageView.init()
        cardView.addSubview(diImg)
        diImg.snp.makeConstraints { (make)->Void in
            make.top.equalTo(10)
            make.height.equalTo(102)
            make.width.equalTo(113)
            make.right.equalTo(-15)
        }
        diImg.image = UIImage(named:"图层1拷贝1")
        
        let manImg = UIImageView.init()
        cardView.addSubview(manImg)
        manImg.snp.makeConstraints { (make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(12)
            make.height.equalTo(18)
            make.width.equalTo(19)
        }
        manImg.image = UIImage(named:"姓名")
        
        let custNameLab:UILabel = UILabel()
        custNameLab.textColor = UIColor.white
        custNameLab.textAlignment = .left
        custNameLab.font = UIFont.systemFont(ofSize: 18)
        if model?.custNname == nil{
            custNameLab.text = "未绑定"
        }
        else{
            custNameLab.text =  (model?.custNname)!
        }
        cardView.addSubview(custNameLab)
        custNameLab.snp.makeConstraints { (make)->Void in
            make.left.equalTo(45)
            make.top.equalTo(14)
            make.height.equalTo(18)
            make.right.equalTo(-32)
        }
        
        let workTypeLab:UILabel = UILabel()
        workTypeLab.textColor = UIColor.white
        workTypeLab.textAlignment = .right
        workTypeLab.font = UIFont.systemFont(ofSize: 13)
        workTypeLab.text = model?.workType
        cardView.addSubview(workTypeLab)
        workTypeLab.snp.makeConstraints { (make)->Void in
            make.width.equalTo(200)
            make.top.equalTo(16)
            make.height.equalTo(13)
            make.right.equalTo(-15)
        }
        
        let carImg = UIImageView.init()
        cardView.addSubview(carImg)
        carImg.snp.makeConstraints { (make)->Void in
            make.top.equalTo(16)
            make.height.equalTo(15)
            make.width.equalTo(20)
            make.right.equalTo(-60)
        }
        carImg.image = UIImage(named:"车")
        
        let cardImg = UIImageView.init()
        cardView.addSubview(cardImg)
        cardImg.snp.makeConstraints { (make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(47)
            make.height.equalTo(13)
            make.width.equalTo(17)
        }
        cardImg.image = UIImage(named:"卡-12")
        
        let cardIdLab:UILabel = UILabel()
        cardIdLab.textColor = UIColor.white
        cardIdLab.textAlignment = .left
        cardIdLab.font = UIFont.systemFont(ofSize: 15)
        cardIdLab.text =  (model?.oilCardNum)!
        cardView.addSubview(cardIdLab)
        cardIdLab.snp.makeConstraints { (make)->Void in
            make.left.equalTo(45)
            make.top.equalTo(49)
            make.height.equalTo(15)
            make.right.equalTo(-32)
        }
        
        let xiaofeiLab:UILabel = UILabel()
        xiaofeiLab.textColor = UIColor.white
        xiaofeiLab.textAlignment = .left
        xiaofeiLab.font = UIFont.systemFont(ofSize: 13)
        let sumtotal  = Double((model?.balance)!)/100
        xiaofeiLab.text = "累计消费：" + sumtotal.description
        cardView.addSubview(xiaofeiLab)
        xiaofeiLab.snp.makeConstraints { (make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(78)
            make.height.equalTo(14)
            make.width.equalTo(200)
        }
        
        let bangdingTimeLab:UILabel = UILabel()
        bangdingTimeLab.textColor = UIColor.white
        bangdingTimeLab.textAlignment = .left
        bangdingTimeLab.font = UIFont.systemFont(ofSize: 11)
        bangdingTimeLab.text = "绑定时间：" + timeStampToString(timeStamp: (((model?.createDate)!/1000).description))
        cardView.addSubview(bangdingTimeLab)
        bangdingTimeLab.snp.makeConstraints { (make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(103)
            make.height.equalTo(11)
            make.width.equalTo(200)
        }
        
        let yueLab:UILabel = UILabel()
        yueLab.textColor = UIColor.white
        yueLab.font = UIFont.systemFont(ofSize: 24)
        yueLab.textAlignment = .right
        let money  = Double((model?.balance)!)/100
        yueLab.text = "¥" + (money.description)
        cardView.addSubview(yueLab)
        yueLab.snp.makeConstraints { (make)->Void in
           make.right.equalTo(-14)
            make.top.equalTo(95)
            //make.right.equalTo(-45)
            make.height.equalTo(24)
            make.width.equalTo(200)
            
        }
        
        let zhangdanImg = UIImageView.init()
        self.view.addSubview(zhangdanImg)
        zhangdanImg.snp.makeConstraints { (make)->Void in
            make.left.equalTo(14)
            make.top.equalTo(217)
            make.height.equalTo(17)
            make.width.equalTo(18)
        }
        zhangdanImg.image = UIImage(named:"订单")
        
        let titleLab2:UILabel = UILabel()
        titleLab2.font = UIFont.systemFont(ofSize: 15)
        titleLab2.text = "账单记录"
        self.view.addSubview(titleLab2)
        titleLab2.textColor = homeColor()
        titleLab2.snp.makeConstraints { (make)->Void in
            make.left.equalTo(40)
            make.top.equalTo(219)
            make.width.equalTo(200)
            make.height.equalTo(15)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyBillTableViewCell
        cell.selectionStyle = .none
        cell.MyBillModel = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }

    func getData()  {
        data = [MyBillModel]()
        let url = BASE_URL + k_orderList
        let params:Dictionary = ["cardNum":model?.oilCardNum,"custType":"2","custId":custId]
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
                            let data = dict["data"].dictionaryValue
                            if let items = data["order"]?.arrayObject {
                                for item in items {
                                    let post = MyBillModel(dict: item as! [String: AnyObject])
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
    override func rightEvent() {
        let vc = LinesDistributionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
