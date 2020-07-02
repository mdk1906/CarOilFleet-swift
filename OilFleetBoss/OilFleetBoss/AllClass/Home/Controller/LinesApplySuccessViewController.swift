//
//  LinesApplySuccessViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class LinesApplySuccessViewController: MDKBaseViewController {

    
    
    @IBOutlet weak var fnishBtn: UIButton!
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var cardNum: UILabel!
    @IBOutlet weak var siteName: UILabel!
    
    
    var siteStr :String?
    var cardStr:String?
    var moneyStr :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "主卡额度申请"
        // Do any additional setup after loading the view.
        let money  = Double(moneyStr!)!/100
        moneyLab.text = "¥" + (money.description)
        cardNum.text = (cardStr)!
        siteName.text = siteStr
        fnishBtn.layer.cornerRadius = 4
        fnishBtn.layer.masksToBounds = true
        
        let contentLab = UILabel.init()
        self.view.addSubview(contentLab)
        contentLab.frame = CGRect(x:0,y:240,width:WindowWidth,height:30)
        contentLab.text = "平台将于24个小时内帮您充值完成，\n 我们将会短信提示您充值成功，请查收"
        contentLab.textAlignment = .center
        contentLab.textColor = kRGBColorFromHex(rgbValue: 0x333333)
        contentLab.numberOfLines = 2
        contentLab.font = UIFont.systemFont(ofSize: 13)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func leftEvent() {
        let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController = mainStoryboard.instantiateInitialViewController()
        self.present(viewController!, animated: true, completion:nil)
    }

    @IBAction func finshBtn(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController = mainStoryboard.instantiateInitialViewController()
        self.present(viewController!, animated: true, completion:nil)
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
