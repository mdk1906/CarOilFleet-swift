//
//  BannersModel.swift
//  CarOilFleetService
//
//  Created by mdk mdk on 2017/10/19.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class BannersModel: NSObject {
    var banners :String?
    var url:String?
    init(dict: [String:AnyObject]) {
        super.init()
        banners =  dict["banners"] as?String
        url = dict["url"] as?String
        
    }

}
