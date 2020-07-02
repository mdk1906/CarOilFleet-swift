
//
//  MyCommissionModel.swift
//  CarOilFleetService
//
//  Created by mdk mdk on 2017/12/7.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MyCommissionModel: NSObject {
    var total :Int?
    var createDate :Int?
    init(dict: [String:AnyObject]) {
        super.init()
        total = dict["total"] as?Int
        createDate = dict["createDate"] as?Int
    }
}
