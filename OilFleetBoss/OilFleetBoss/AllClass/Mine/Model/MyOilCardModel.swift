//
//  MyOilCardModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2017/10/27.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyOilCardModel: NSObject {
    var balance : Int?
    var custNname :String?
    var oilCardNum :String?
    var uid :Int?
    var createDate :Int?
    var workType :String?
    var sumTotal :Int?
    init(dict: [String:AnyObject]) {
        super.init()
        balance = dict["balance"] as?Int
        custNname = dict["custNname"] as?String
        oilCardNum = dict["oilCardNum"] as?String
        uid = dict["uid"] as?Int
        createDate = dict["createDate"] as?Int
        workType = dict["workType"] as?String
        sumTotal = dict["sumTotal"] as?Int 
    }

}
