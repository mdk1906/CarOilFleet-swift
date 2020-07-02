//
//  MineModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/25.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MineModel: NSObject {
    var title : String?
    var leftImg :String?
    init(dict: [String:AnyObject]) {
        super.init()
        title = dict["title"] as? String
        leftImg = dict["leftImg"] as? String
    }
    
}
