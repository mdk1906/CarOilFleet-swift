//
//  NowCallOilViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class NowCallOilViewController: MDKBaseListViewController,UITextViewDelegate {
    
    var siteName:String?
    var oilType:String?
    var time:String?
    var add:String?
    var telName:String?
    var telNum:String?
    var remark:String?
    var pro1:String?
    var area1:String?
    var city1:String?
    var model :OilOrderModel?
    var data = [NowCallOilModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "立即要油"
        remark = "无备注"
        oilType = "1"
        
        if let items = model?.list {
            for item in items {
                print(item)
                let post = NowCallOilModel(dict: item as! [String: AnyObject])
                
                self.data.append(post)
            }
           
        }
        siteName = model?.name
        cellID = "NowCallOilTableViewCell"
        tableView?.frame = CGRect(x:0,y:64,width:WindowWidth,height:WindowHeight-64-50)
        tableView?.register(NowCallOilTableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView!)
        self.createUI()
        self.createFoot()
        // Do any additional setup after loading the view.
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
        let headView :UIView = UIView()
        headView.backgroundColor = UIColor.white
        tableView?.tableHeaderView = headView
        headView.frame = CGRect(x:0,y:0,width:WindowWidth,height:405)
        let titleArr = ["要油工地","要油品类","要油总数量","送达时间","送油地址","详细地址","联系人","联系方式","用油详情"]
        
        let contentArr = [(model?.name)!,"柴油",(model?.total?.description)! ,"请选择时间","请选择地址","请填写送油地址","请填写联系人","请填写联系电话",""] as [Any]
        for index in 0..<(titleArr.count) {
            let view :UIView = UIView()
            headView.addSubview(view)
            view.frame = CGRect(x:0,y:45*(index),width:Int(WindowWidth),height:45)
            
            let titleLab :UILabel = UILabel()
            titleLab.text = titleArr[index]
            titleLab.frame = CGRect(x:14,y:0,width:100,height:50)
            titleLab.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(titleLab)
            
            let tf:UITextField = UITextField()
            tf.frame = CGRect(x:WindowWidth-300-16,y:0,width:300,height:45)
            tf.font = UIFont.systemFont(ofSize: 14)
            tf.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            tf.placeholder = String(describing: contentArr[index])
            tf.textAlignment = .right
            tf.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
            tf.tag = index+100
            tf.delegate = self
            view.addSubview(tf)
            if (index == 0 || index == 2||index == 8 || index == 1) {
                tf.isEnabled = false
                tf.text = String(describing: contentArr[index])
            }
            if index == 3 {
                let dateF:DateFormatter = DateFormatter()
                dateF.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let startInputView:JWDatePickerKeyBoardView = JWDatePickerKeyBoardView(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height: 45*3+64))
                
                startInputView.didConfirmDateClosure = {
                    (date) -> Void in
                    tf.text = dateF.string(from: date)
                    let dateStamp:TimeInterval = date.timeIntervalSince1970
                    let dateSt:Int = Int(dateStamp)*(1000)
                    self.time = String(dateSt)
                };
                
                tf.inputView =  startInputView
                
            }
            if index == 4{
                let btn :UIButton = UIButton.init()
                view.addSubview(btn)
                btn.addTarget(self, action: #selector(cityClick), for: .touchUpInside)
                btn.frame = CGRect(x:120,y:0,width:WindowWidth-140,height:45)
            }
            if index == 8{
                view.backgroundColor = huiColor()
                titleLab.textColor = homeColor()
                titleLab.font = UIFont.systemFont(ofSize: 15)
            }
            let hui:UIView = UIView()
            hui.frame = CGRect(x:0,y:44,width:WindowWidth,height:1)
            hui.backgroundColor = huiColor()
            view.addSubview(hui)
        }
    }
    func createFoot()  {
        let footView :UIView = UIView()
        footView.backgroundColor = UIColor.white
        footView.frame = CGRect(x:0,y:0,width:WindowWidth,height:120)
        tableView?.tableFooterView = footView
        
        let titleLab :UILabel = UILabel()
        titleLab.text = "备注"
        titleLab.frame = CGRect(x:20,y:0,width:WindowWidth,height:40)
        titleLab.font = UIFont.systemFont(ofSize: 15)
        footView.addSubview(titleLab)
        
        let textView:UITextView = UITextView()
        textView.frame = CGRect(x:20,y:40,width:WindowWidth-40,height:80)
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 4
        textView.layer.borderColor = homeColor().cgColor
        textView.layer.borderWidth = 1
        footView.addSubview(textView)
        textView.delegate = self
        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:20,y:WindowHeight-50,width:WindowWidth-40,height:44)
        nextBtn.backgroundColor = homeColor()
        nextBtn.setTitle("立即要油", for: .normal)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action:#selector(btnClick) , for: .touchUpInside)
        self.view.addSubview(nextBtn)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! NowCallOilTableViewCell
        cell.selectionStyle = .none
        cell.NowCallOilModel = data[indexPath.row]
        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:WindowWidth-80,y:0,width:80,height:40)
        
        nextBtn.addTarget(self, action:#selector(phoCall) , for: .touchUpInside)
        cell.contentView.addSubview(nextBtn)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 280
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 120
//    }
    //MARK :tf输入
    func tfInPut(tf:UITextField)  {
        
        if tf.tag == 100 {
            siteName = tf.text!
        }
        
        else if tf.tag == 105{
            add = tf.text!
        }
        else if tf.tag == 106{
            telName = tf.text!
        }
        else if tf.tag == 107{
            telNum = tf.text!
        }
        

    }
    func textViewDidChange(_ textView: UITextView) {
        remark = textView.text!
    }
    func cityClick()  {
        let rect = CGRect(x: 0, y: WindowHeight-300, width: self.view.frame.width, height: 300)
        let areaVC = AreaPickerViewController(title: "选择省市区", frame: rect) { (pro,area,city) in
            //省市区选择回调
            print(pro,area,city)
            let tf :UITextField = self.view.viewWithTag(104) as! UITextField
            tf.text = (pro) + (area) + (city)
            self.pro1 = pro
            self.area1 = area
            self.city1 = city
        }
        areaVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.present(areaVC, animated: false, completion: nil)
    }

    func btnClick() {
        if (model?.total?.description)! == "0" {
            loadFailure(msg: "订单需大于0升")
        }
        else if siteName == nil {
            loadFailure(msg: "请填写要油工地")
        }
        else if oilType == nil{
            loadFailure(msg: "请填写油品")
        }
        else if time == nil{
            loadFailure(msg: "请选择时间")
        }
        else if area1 == nil{
            loadFailure(msg: "请选择地址")
        }
        else if add == nil{
            loadFailure(msg: "请填写详细地址")
        }
        else if telName == nil{
            loadFailure(msg: "请填写联系人")
        }
        else if telNum == nil{
            loadFailure(msg: "请填写联系方式")
        }
        else{
            var arr :String = ""
            for items in self.data {
                let ids = (items.uid?.description)! + ","
                print("ids" ,ids)
                arr += ids
            }
            let uid = model?.uid?.description
            let total = model?.total?.description
            let url = BASE_URL + K_oilAdd
            let params:Dictionary = ["ids":arr,"oilType":oilType,"arriveDate":time,"tel":telNum,"address":add,"contacts":telName,"remark":remark,"custId":custId,"detailsLevel":"2","engineeringId":uid,"province":pro1,"city":area1,"county":city1,"oilQuantity":(total)!,"detailsStatus":"3"]
            print("params",params)
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
                                sleep(UInt32(0.5))
                                let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
                                let viewController = mainStoryboard.instantiateInitialViewController()
                                self.present(viewController!, animated: true, completion:nil)
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 107 {
            guard let text = textField.text else{
                return true
            }
            
            let textLength = text.characters.count + string.characters.count - range.length
            
            return textLength<=11
        }
        else {
            return true
        }
        
    }
    func phoCall(btn:UIButton)  {
        let cell:NowCallOilTableViewCell = superUITableViewCell(of: btn)!
        let Pho = cell.NowCallOilModel?.tel
        let phoStr = "telprompt://" + (Pho)!
        UIApplication.shared.openURL(NSURL(string :phoStr)! as URL)
        
    }
    //MARK: - 返回button所在的UITableViewCell
    func superUITableViewCell(of: UIButton) -> NowCallOilTableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? NowCallOilTableViewCell {
                return cell
            }
        }
        return nil
    }
    
}
