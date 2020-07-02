//
//  MyOilCardListModel.swift
//  OilFleetBoss
//
//  Created by qingwen on 2018/4/19.
//  Copyright © 2018年 mdk mdk. All rights reserved.
//

import UIKit

class MyOilCardListModel: NSObject {
    var balance : Int?
    var custNname :String?
    var oilCardNum :String?
    var uid :Int?
    var createTime :Int?
    var applyStatus :Int?
    var applyType :Int?
    var cardCount:Int?
    init(dict: [String:AnyObject]) {
        super.init()
        balance = dict["balance"] as?Int
        oilCardNum = dict["oilCardNum"] as?String
        uid = dict["uid"] as?Int
        applyStatus = dict["applyStatus"] as?Int
        createTime = dict["createTime"] as?Int
        applyType = dict["applyType"] as?Int
        cardCount = dict["cardCount"] as?Int
        custNname = dict["custNname"] as?String
    }
}
