//
//  OilValue.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2018/4/19.
//  Copyright © 2018年 mdk mdk. All rights reserved.
//

import Foundation

public class OilValue {
    private static let sharedInstance = OilValue()
    private init() {}
    //提供静态访问方法
    public static var shared: OilValue {
        return self.sharedInstance
    }
    
    // —— 存储值
    var token:String = ""
    var userPhone :String = ""
    var userName :String = ""
}
