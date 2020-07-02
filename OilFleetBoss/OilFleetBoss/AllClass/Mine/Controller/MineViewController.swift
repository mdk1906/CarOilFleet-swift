//
//  MineViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/14.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MineViewController: MDKBaseListViewController {
    var data = [MineModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        let dataArr:Array<Dictionary<String, String>> =
            [["leftImg":"账户","title":"我的账户" ],
             ["leftImg":"icon_现场签证","title":"我的工地" ],
             ["leftImg":"工人","title":"我的雇工" ],
             ["leftImg":"设置","title":"设置" ],
             ["leftImg":"我们","title":"关于我们"]]
        for item in dataArr {
            let post = MineModel(dict: item as [String : AnyObject] )
            data.append(post)
        }
        cellID = "MineTableViewCell"
        tableView?.frame = CGRect(x:0,y:0,width:WindowWidth,height:WindowHeight-49)
        tableView?.bounces = false
        let nib = UINib(nibName: String(describing: MineTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        self .createHeadView()
        NotificationCenter.default.addObserver(self, selector: #selector(fresh), name: NSNotification.Name.init("freshUI"), object: nil)
        // Do any additional setup after loading the view.
        
    }
    func fresh()  {
        createHeadView()
        self.tableView?.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createHeadView()  {
        let view:UIView? = UIView.init(frame: CGRect(x:0,y:0,width:WindowWidth,height:115+46+10))
//        view?.backgroundColor = homeColor()
        self.tableView?.tableHeaderView = view
        
        let backImg = UIImageView.init()
        view?.addSubview(backImg)
        backImg.frame = CGRect(x:0,y:0,width:WindowWidth,height:115)
        backImg.image = UIImage(named:"背景拷贝")
        let imgView:UIImageView = UIImageView.init(frame: CGRect(x:21,y:38,width:60,height:60))
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
        view?.addSubview(imgView)
        
        let InfoBtn :UIButton = UIButton.init(frame: CGRect(x:21,y:38,width:60,height:60))
        view?.addSubview(InfoBtn)
        InfoBtn.addTarget(self, action: #selector(mineInfo), for: .touchUpInside)
        
        let nameLab:UILabel = UILabel.init(frame: CGRect(x:94,y:47,width:WindowWidth,height:17))
        nameLab.text = userName
        nameLab.textAlignment = .left
        nameLab.textColor = UIColor.white
        nameLab.font = UIFont.systemFont(ofSize: 13)
        view?.addSubview(nameLab)
        
        let vipNum:UILabel = UILabel.init(frame: CGRect(x:94,y:73,width:WindowWidth,height:17))
        vipNum.text = "会员号：" + custNo!
        vipNum.textAlignment = .left
        vipNum.textColor = UIColor.white
        vipNum.font = UIFont.systemFont(ofSize: 13)
        view?.addSubview(vipNum)
        
        let titleArr = ["油卡申请","主卡额度申请","分卡额度申请"]
        let imgArr = ["油卡(1)","加油卡充值","卡"]
        for index in 0..<titleArr.count {
            let view2 = UIButton.init()
            view?.addSubview(view2)
            view2.backgroundColor = UIColor.white
            view2.frame = CGRect(x:CGFloat(index)*(WindowWidth/3),y:115,width:WindowWidth/3,height:46)
            let image = UIImageView.init()
            view2.addSubview(image)
            image.image = UIImage(named:imgArr[index])
            image.snp.makeConstraints { (make)->Void in
                make.left.equalTo(10)
                make.top.equalTo(15)
                make.width.equalTo(17)
                make.height.equalTo(17)
            }
            let titleLab = UILabel.init()
            view2.tag = 3000+index
            view2.addTarget(self, action: #selector(applyClick), for: .touchUpInside)
            view2.addSubview(titleLab)
            titleLab.text = titleArr[index]
            titleLab.font = UIFont.systemFont(ofSize: 13)
            titleLab.textAlignment = .center
            titleLab.textColor = kRGBColorFromHex(rgbValue: 0x999999)
            titleLab.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(46)
                make.top.equalTo(0)
                
            })
            let hui :UIView = UIView.init()
            view2.addSubview(hui)
            hui.snp.makeConstraints({ (make)->Void in
                make.right.equalTo(-1)
                make.height.equalTo(32)
                make.width.equalTo(1)
                make.top.equalTo(7)
            })
            hui.backgroundColor = huiColor()
        }
        let hui :UIView = UIView.init()
        view?.addSubview(hui)
        hui.snp.makeConstraints({ (make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(10)
            make.top.equalTo(115+46)
            
        })
        hui.backgroundColor = huiColor()
        
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.row == 2 {
           return 56.5
        }
        else{
            return 46.5
        }
    }
    //绘制cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MineTableViewCell
        cell.selectionStyle = .none
        cell.MineModel = data[indexPath.row]
        if  indexPath.row == 2 {
            let hui2 = UIView.init()
            hui2.frame = CGRect(x:0,y:46.5,width:WindowWidth,height:10)
            hui2.backgroundColor = huiColor()
            cell.contentView.addSubview(hui2)
            cell.hui.isHidden = true
        }
        if indexPath.row == 4  {
            cell.hui.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.05
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //我的账单
            let vc = MyMainOilCardViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
//        if indexPath.row == 1 {
//            //我的申请
//
//        }
        if indexPath.row == 1 {
            //我的工地
            let vc = MyConstructionViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 2 {
            //我的雇工
            let vc = FindViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
//        if indexPath.row == 4 {
//            //提现申请
//            let vc = WithdrawalViewController()
//            navigationController?.pushViewController(vc, animated: true)
//        }
        if indexPath.row == 3 {
            //设置
            let vc = SetUpViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 4 {
            //关于我们
            let vc = AboutUsViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // MARK : - 点击头像
    func mineInfo()   {
        let vc = EditMineInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func applyClick(btn:UIButton)  {
        switch btn.tag {
        case 3000:
            //油卡申请
//            let vc = MyOrderViewController()
//            vc.applyType = "2"
//
//            navigationController?.pushViewController(vc, animated: true)
            let vc = OilCardApplyViewController()
            //            let vc = FillIdCardViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3001:
            //主卡申请
//            let vc = MyOrderViewController()
//            vc.applyType = "0"
//
//            navigationController?.pushViewController(vc, animated: true)
            let vc = MainCardLimitApplyViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3002:
            //分卡申请
//            let vc = MyOrderViewController()
//            vc.applyType = "1"
//
//            navigationController?.pushViewController(vc, animated: true)
            let vc = LinesDistributionViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
