//
//  OilOrderModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/10/18.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class OilOrderModel: NSObject {
    var name : String?
    var list :Array<Any>?
    var total :Int?
    var address:String?
    var county :String?
    var province :String?
    var city: String?
    var uid :Int?
    init(dict: [String:AnyObject]) {
        super.init()
        name = dict["name"] as? String
        list = dict["list"] as? Array
        total = dict["total"] as? Int
        address = dict["address"] as? String
        county = dict["county"] as? String
        province = dict["province"] as? String
        city = dict["city"] as?String
        uid = dict["uid"] as? Int
    }
    
}
