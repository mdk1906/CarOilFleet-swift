//
//  MyApplymodel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/10/30.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyApplymodel: NSObject {
    var balance : Int?
    var custNname :String?
    var oilCardNum :String?
    var uid :Int?
    var createDate :Int?
    var applyStatus :Int?
    var applyType :Int?
    var money : Int?
    
    init(dict: [String:AnyObject]) {
        super.init()
        balance = dict["balance"] as?Int
        oilCardNum = dict["oilCardNum"] as?String
        uid = dict["uid"] as?Int
        applyStatus = dict["applyStatus"] as?Int
        createDate = dict["createDate"] as?Int
        applyType = dict["applyType"] as?Int
        money = dict["money"] as?Int
    }
}
