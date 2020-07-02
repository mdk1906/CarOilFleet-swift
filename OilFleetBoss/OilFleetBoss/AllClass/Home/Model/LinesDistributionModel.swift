//
//  LinesDistributionModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/12.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class LinesDistributionModel: NSObject {
    var name : String?
    var balance :Int?
    var list :Array<Any>?
    var remittanceLimit :Int?
    var fenpeiMoney : String?
    var oilCardNum :String?
//    var 
    init(dict: [String:AnyObject]) {
        super.init()
        name = dict["name"] as? String
        balance = dict["balance"] as? Int
        list = dict["list"] as? Array
        remittanceLimit = dict["remittanceLimit"] as? Int
        oilCardNum = dict["oilCardNum"] as? String
    }
}
