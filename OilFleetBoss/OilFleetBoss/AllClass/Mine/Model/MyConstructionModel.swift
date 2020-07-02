//
//  MyConstructionModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/9.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyConstructionModel: NSObject {
    var address : String?
    var city:String?
    var contacts:String?
    var county:String?
    var createDate:Int?
    var custId:String?
    var engStatus:Int?
    var engType:Int?
    var isDelete:String?
    var name:String?
    var province:String?
    var startDate:Int?
    var tel:String?
    var uid:Int?
    var oilCardNum:String?
    var custNname:String?
    var balance:Int?
    init(dict: [String:AnyObject]) {
        super.init()
        address = dict["address"] as? String
        city = dict["city"] as? String
        contacts = dict["contacts"] as? String
        county = dict["county"] as? String
        createDate = dict["createDate"] as? Int
        custId = dict["custId"] as? String
        engStatus = dict["engStatus"] as? Int
        engType = dict["engType"] as? Int
        isDelete = dict["isDelete"] as? String
        name = dict["name"] as? String
        startDate = dict["startDate"] as? Int
        province = dict["province"] as? String
        tel = dict["tel"] as? String
        uid = dict["uid"] as? Int
        oilCardNum = dict["oilCardNum"] as? String
        custNname = dict["custNname"] as? String
        balance = dict["balance"] as? Int
    }
}
