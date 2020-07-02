//
//  MyWorkerModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/26.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyWorkerModel: NSObject {
    var custId :String?
    var custNname :String?
    var custPhone :String?
    var engName :String?
    var workType:String?
    var settlementMoney :Int?
    var createDate :Int?
    var oilCardNum :String?
    var uid :Int?
    //选中1 未选中2 未编辑0
    var xuanzhong :String?
    init(dict: [String:AnyObject]) {
        super.init()
        custNname = dict["custNname"] as? String
        workType = dict["workType"] as? String
        engName = dict["engName"] as? String
        custId = dict["custId"] as? String
        custPhone = dict["custPhone"] as? String
        settlementMoney = dict["settlementMoney"] as? Int
        createDate = dict["createDate"] as? Int
        oilCardNum = dict["oilCardNum"] as? String
        uid = dict["uid"] as? Int
        
    }
    
}
