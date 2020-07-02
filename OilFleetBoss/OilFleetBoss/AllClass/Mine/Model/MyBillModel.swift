//
//  MyBillModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/11/4.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyBillModel: NSObject {
    var cost : Int?
    var custNname :String?
    var oilCardNum :String?
    var uid :Int?
    var completeTime :Int?
    var orderType :Int?
    var orderId :String?
    var province:String?
    var county:String?
    var city:String?
    var address:String?
    init(dict: [String:AnyObject]) {
        super.init()
        cost = dict["cost"] as?Int
        oilCardNum = dict["oilCardNum"] as?String
        uid = dict["uid"] as?Int
        orderId = dict["orderId"] as?String
        completeTime = dict["completeTime"] as?Int
        orderType = dict["orderType"] as?Int
        province = dict["province"] as?String
        county = dict["county"] as?String
        city = dict["city"] as?String
        address = dict["address"] as?String
    }
}
