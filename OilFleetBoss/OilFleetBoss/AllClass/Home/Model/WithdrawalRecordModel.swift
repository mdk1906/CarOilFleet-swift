//
//  WithdrawalRecordModel.swift
//  OilFleetDelivery
//
//  Created by mdk mdk on 2018/4/28.
//  Copyright © 2018年 czt. All rights reserved.
//

import UIKit

class WithdrawalRecordModel: NSObject {
    var completeDate :Int?
    var createDate :Int?
    var status :Int?
    var total:Int?
    init(dict: [String:AnyObject]) {
        super.init()
        completeDate = dict["completeDate"] as? Int
        createDate = dict["createDate"] as? Int
        status = dict["status"] as? Int
        total = dict["total"] as? Int
        
    }
}
