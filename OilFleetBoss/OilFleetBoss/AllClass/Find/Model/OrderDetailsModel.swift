//
//  OrderDetailsModel.swift
//  CarOilFleetService
//
//  Created by mdk mdk on 2017/10/18.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class OrderDetailsModel: NSObject {

    var oilQuantity :Int?
    var custNname:String?
    var tel :Int?
    init(dict: [String:AnyObject]) {
        super.init()
        tel = dict["tel"] as?Int
        oilQuantity = dict["oilQuantity"] as?Int
        custNname = dict["custNname"] as?String
    }
}
