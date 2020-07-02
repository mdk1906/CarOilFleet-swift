//
//  MDKBaseViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/14.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import SVProgressHUD
import FDFullscreenPopGesture
import Alamofire
import SnapKit
class MDKBaseViewController: UIViewController,UITextFieldDelegate {
    
    var titleX: UILabel?
    var Nav: UIView?
    var leftBtn: UIButton?
    var rightBtn: UIButton?
    var leftImg :UIImageView?
    var rightImg : UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        view.backgroundColor = GlobalColor()
        navigationController?.fd_prefersNavigationBarHidden = true
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5))
        SVProgressHUD.setForegroundColor(UIColor.white)
        
        self.navigationController?.navigationBar.isHidden = true
        self.Nav = UIView.init(frame: CGRect(x:0,y:0,width:WindowWidth,height:64))
        self.Nav?.backgroundColor = homeColor()
        self.view.addSubview(self.Nav!)
        self.leftImg = UIImageView.init(frame: CGRect(x:10,y:31,width:13,height:21))
        self.leftImg?.image = UIImage(named: "Back-icon")
        self.Nav?.addSubview(leftImg!)
        
        self.leftBtn = UIButton.init(frame: CGRect(x:0,y:20,width:40,height:44))
        self.leftBtn?.addTarget(self, action:#selector(leftEvent) , for: .touchUpInside)
        self.Nav?.addSubview(leftBtn!)
        
        self.rightBtn = UIButton.init(frame: CGRect(x:WindowWidth-12-60,y:20,width:60,height:44))
        self.rightBtn?.addTarget(self, action:#selector(rightEvent) , for: .touchUpInside)
        self.rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.Nav?.addSubview(rightBtn!)
        
        self.titleX = UILabel.init(frame: CGRect(x:0,y:20,width:WindowWidth,height:44))
        self.titleX?.font = UIFont.systemFont(ofSize: 18)
        self.titleX?.font = UIFont(name:"Hiragino-Sans",size:18)
        self.titleX?.textColor = UIColor.white
        self.Nav?.addSubview(self.titleX!)
        self.titleX?.textAlignment = .center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftEvent()  {
        self.navigationController?.popViewController(animated: true)
    }
    func rightEvent()  {
        
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
