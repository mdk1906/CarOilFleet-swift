//
//  OilCardApplyModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class OilCardApplyModel: NSObject {
    var title : String?
    var content :String?
    init(dict: [String:AnyObject]) {
        super.init()
        title = dict["title"] as? String
        content = dict["content"] as? String
    }

}
