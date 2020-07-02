
//
//  SetUpViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class SetUpViewController: MDKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "设置"
        // Do any additional setup after loading the view.
        self.createUI()
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
        let view :UIView = UIView()
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
        view.snp.makeConstraints { (make)->Void in
            make.left.equalTo(0)
            make.top.equalTo(64)
            make.right.equalTo(0)
            make.height.equalTo(46)
        }
        
        let titleLab:UILabel = UILabel()
        titleLab.text = "修改密码"
        titleLab.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(titleLab)
        titleLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        titleLab.snp.makeConstraints { (make)->Void in
            make.left.equalTo(14)
            make.top.equalTo(0)
            make.width.equalTo(100)
            make.height.equalTo(46)
        }
        
        let rightImg :UIImageView = UIImageView()
        rightImg.image = UIImage(named:"箭头")
        view.addSubview(rightImg)
        rightImg.snp.makeConstraints { (make)->Void in
            make.right.equalTo(-14)
            make.top.equalTo(14)
            make.height.equalTo(18)
            make.width.equalTo(10)
        }
        let editPassBtn:UIButton = UIButton()
        editPassBtn.frame = CGRect(x:0,y:64,width:WindowWidth,height:46)
        
        editPassBtn.addTarget(self, action:#selector(editPassBtnClick) , for: .touchUpInside)
        self.view.addSubview(editPassBtn)

        let nextBtn:UIButton = UIButton()
        nextBtn.frame = CGRect(x:25,y:WindowHeight-116-40,width:WindowWidth-50,height:40)
        nextBtn.backgroundColor = homeColor()
        nextBtn.setTitle("退出登录", for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action:#selector(btnClick) , for: .touchUpInside)
        self.view.addSubview(nextBtn)
    }
    
    func btnClick()  {
        let defaults = UserDefaults.standard;
        defaults.removeSuite(named: "custImg")
        defaults.removeSuite(named: "custNname")
        defaults.removeSuite(named: "custNo")
        defaults.removeSuite(named: "phoneNum")
        defaults.removeSuite(named: "passWord")
        defaults.removeSuite(named: "custId")
        OilValue.shared.token = ""
        print("token123 = ",OilValue.shared.token)
        let vc = LoginViewController()
        vc.tuichu = "1"
        navigationController?.pushViewController(vc, animated: true)
    }
    func editPassBtnClick()  {
        let vc = EditPassWordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
