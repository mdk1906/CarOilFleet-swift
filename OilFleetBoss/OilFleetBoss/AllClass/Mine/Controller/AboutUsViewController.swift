//
//  AboutUsViewController.swift
//  CarOilFleetService
//
//  Created by mdk mdk on 17/10/16.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class AboutUsViewController: MDKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "关于我们"
        self.createUI()
        self.view.backgroundColor = huiColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI()   {
        let headView :UIView = UIView.init()
        headView.backgroundColor = UIColor.white
        self.view.addSubview(headView)
        headView.snp.makeConstraints { (make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(64)
            make.height.equalTo(289-15)
        }
        
        let headImg :UIImageView = UIImageView.init()
        headView.addSubview(headImg)
        headImg.image = UIImage(named:"180")
        headImg.layer.cornerRadius = 35
        headImg.layer.masksToBounds = true
        headImg.snp.makeConstraints { (make)->Void in
            make.centerX.equalTo(headView)
            make.top.equalTo(21)
            make.height.equalTo(70)
            make.width.equalTo(70)
        }

        let banbenLab :UILabel = UILabel.init()
        banbenLab.textAlignment = .center
        banbenLab.text = "版本：V1.2"
        banbenLab.font = UIFont.systemFont(ofSize: 14)
        banbenLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        headView.addSubview(banbenLab)
        banbenLab.snp.makeConstraints { (make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(headImg.snp.bottom).offset(17)
            make.height.equalTo(14)
        }
        
        let titleArr = ["平台介绍","去评价","联系我们"]
        
        for index in 0..<(titleArr.count) {
            let view :UIButton = UIButton.init()
            headView.addSubview(view)
            view.tag = 1000 + index
            view.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            view.snp.makeConstraints({ (make)->Void in
                make.top.equalTo(banbenLab.snp.bottom).offset(index*45+22)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(51)
            })
            
            let hui :UIView = UIView.init()
            hui.backgroundColor = huiColor()
            view.addSubview(hui)
            hui.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(0)
                make.top.equalTo(44)
                make.right.equalTo(0)
                make.height.equalTo(1)
                
            })
            
            let titleLab :UILabel = UILabel.init()
            titleLab.text = titleArr[index]
            titleLab.font = UIFont.systemFont(ofSize: 14)
            titleLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
            view.addSubview(titleLab)
            titleLab.snp.makeConstraints({ (make)->Void in
                make.left.equalTo(23)
                make.top.equalTo(1)
                make.height.equalTo(45)
                make.width.equalTo(200)
            })
            
            
        }
    }
    func btnClick(btn:UIButton)  {
        if btn.tag == 1000{
            
        }
        else if btn.tag == 1001{
            //去评价
            self.gotoAppStore()
        }
        else if btn.tag == 1002{
            //联系我们
            let Pho = "4000275006"
            let phoStr = "telprompt://" + Pho
            UIApplication.shared.openURL(NSURL(string :phoStr)! as URL)
        }
        
    }
    func gotoAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/id1308161355"
        if let url = URL(string: urlString) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
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
