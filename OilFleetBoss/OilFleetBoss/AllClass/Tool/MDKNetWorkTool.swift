//
//  MDKNetWorkTool.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/14.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class MDKNetWorkTool: NSObject {
    /// 单例
    static let shareNetworkTool = MDKNetWorkTool()
    static let headers: HTTPHeaders = [
        "Accept": "application/json",
        "devType":"1"
    ]

     //登录
    func loginInfo(phone:String,passWord:String,finished:@escaping (_ loginItems :[LoginModel]) -> ()) {
        
        
       

    }
    /// 获取首页数据
    func loadHomeInfo(id: Int, finished:@escaping (_ homeItems: [MDKHomeItem]) -> ()) {
        //        let url = BASE_URL + "v1/channels/\(id)/items?gender=1&generation=1&limit=20&offset=0"
        let url = BASE_URL + "v1/channels/\(id)/items"
        let params = ["gender": 1,
                      "generation": 1,
                      "limit": 20,
                      "offset": 0]
        Alamofire
            .request(url, parameters: params)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    let data = dict["data"].dictionary
                    //  字典转成模型
                    if let items = data!["items"]?.arrayObject {
                        var homeItems = [MDKHomeItem]()
                        for item in items {
                            let homeItem = MDKHomeItem(dict: item as! [String: AnyObject])
                            homeItems.append(homeItem)
                        }
                        finished(homeItems)
                    }
                }
        }
    }
   
    
        
}
