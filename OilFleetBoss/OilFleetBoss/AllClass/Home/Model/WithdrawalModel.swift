//
//  WithdrawalVC.swift
//  OilFleetDelivery
//
//  Created by mdk mdk on 2018/4/28.
//  Copyright © 2018年 czt. All rights reserved.
//

import UIKit

class WithdrawalModel: NSObject {
    //积分
    var completeTime :Int?
    var cost :String?
    var custNname :String?
    var engineeringName :String?
    var level :Int?
    var litre:Int?
    var orderId: String?
    var score: Int?
    //提成
    var oilQuantity :Int?
    var shippingFee :Int?
    //佣金
    var createTime :Int?
    var info :Int?
    var phoneReg :Int?
    var total :Int?
    var userOrder :Int?
    var workType :String?
    init(dict: [String:AnyObject]) {
        super.init()
        completeTime = dict["completeTime"] as? Int
        cost = dict["cost"] as? String
        custNname = dict["custNname"] as? String
        engineeringName = dict["engineeringName"] as? String
        level = dict["level"] as? Int
        litre = dict["litre"] as? Int
        orderId = dict["orderId"] as? String
        score = dict["score"] as? Int
        oilQuantity = dict["oilQuantity"] as? Int
        shippingFee = dict["shippingFee"] as? Int
        info = dict["info"] as? Int
        createTime = dict["createTime"] as? Int
        phoneReg = dict["phoneReg"] as? Int
        total = dict["total"] as? Int
        userOrder = dict["userOrder"] as? Int
        workType = dict["workType"] as? String
    }
}
