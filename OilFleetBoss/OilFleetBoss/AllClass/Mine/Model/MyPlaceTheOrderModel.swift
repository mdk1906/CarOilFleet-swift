//
//  MyPlaceTheOrderModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/11/6.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyPlaceTheOrderModel: NSObject {
    var oilQuantity :Int?
    var createDate :Int?
    var name :String?
    var custNname :String?
    var arriveDate :Int?
    var uid: Int?
    init(dict: [String:AnyObject]) {
        super.init()
        createDate = dict["createDate"] as?Int
        name = dict["name"] as?String
        oilQuantity = dict["oilQuantity"] as?Int
        custNname = dict["custNname"] as?String
        arriveDate = dict["arriveDate"] as?Int
        uid = dict["uid"] as?Int
    }
}
