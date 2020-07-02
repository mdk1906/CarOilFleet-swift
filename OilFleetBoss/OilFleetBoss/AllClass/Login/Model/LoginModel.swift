//
//  LoginModel.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/14.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class LoginModel: NSObject {
    //推荐人id
    var custRecommendId: String?
    //会员号
    var custNo: String?
    //密码
    var custPwd: String?
    //等级
    var custLevel: NSNumber?
    //id
    var id: NSNumber?
    //1,wx 2,wb 3,qq 4,phone
    var custRegType: String?
    //用户昵称
    var custNname: String?
    //token
    var token: String?
    //邀请者ID
    var custRegInviter : String?
    //注册频道
    var custRegChannel : String?
    //个人签名
    var custSignature : String?
    //创建时间
    var createDate : NSNumber?
    //头像
    var  custImg : String?
    //用户类型
    var  custType  :String?
    //用户ID
    var  custId :String?
    //备注
    var  custDesc : String?
    //手机
    var custPhone : String?
    //二维码 
    var custQr : String?
    //注册地址 
    var custLocation :String?
    //更新时间
    var  updateDate : NSNumber?
    //性别0女1男
    var  custSex : NSNumber?
    //设备号
    var  custDeviceId :String?
    //真实姓名
    var custName :String?
    //用户状态0-禁用 1-正常
    var custStatus :String?
    
    
    init(dict: [String: AnyObject]) {
        id = dict["id"] as? NSNumber
        custRecommendId = dict["custRecommendId"] as? String
        custNo = dict["custNo"] as? String
        custPwd = dict["custPwd"] as? String
        custLevel = dict["custLevel"] as? NSNumber
        id = dict["id"] as? NSNumber
        custRegType = dict["custRegType"] as? String
        custNname = dict["custNname"] as? String
        token = dict["token"] as? String
        custRegInviter = dict["custRegInviter"] as? String
        custRegChannel = dict["custRegChannel"] as? String
        custSignature = dict["custSignature"] as? String
        createDate = dict["createDate"] as? NSNumber
        custImg = dict["custImg"] as? String
        custType = dict["custType"] as? String
        custId = dict["custId"] as? String
        custDesc = dict["custDesc"] as? String
        custPhone = dict["custPhone"] as? String
        custQr = dict["custQr"] as? String
        custLocation = dict["custLocation"] as? String
        updateDate = dict["updateDate"] as? NSNumber
        custSex = dict["custSex"] as? NSNumber
        custDeviceId = dict["custDeviceId"] as? String
        custName = dict["custName"] as? String
        custStatus = dict["custStatus"] as? String
    }

}
