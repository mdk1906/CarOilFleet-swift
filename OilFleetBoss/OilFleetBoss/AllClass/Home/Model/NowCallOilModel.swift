//
//  NowCallOilModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/10/18.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class NowCallOilModel: NSObject {
    var custNname :String?
    var oilQuantity: Int?
    var uid :Int?
    var custPhone :String?
    var tel: String?
    init(dict: [String:AnyObject]) {
        super.init()
        custNname = dict["custNname"] as?String
        oilQuantity = dict["oilQuantity"] as?Int
        uid = dict["uid"] as? Int
        tel = dict["tel"] as? String
//        custPhone = 
    }
}
