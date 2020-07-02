//
//  EditMineInfoModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/11.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class EditMineInfoModel: NSObject {
    
    var custNname : String?
    var custLevel :Int?
    var custPhone :String?
    var custType :String?//1:工地工人2:工地承包人3加油站员工
    var headImg :String?
    var location:String?
    init(dict: [String:AnyObject]) {
        super.init()
        custNname = dict["custNname"] as? String
        custLevel = dict["custLevel"] as?Int
        custPhone = dict["custPhone"] as?String
        headImg = dict["headImg"] as?String
        location = dict["location"] as?String
        
    }

}
