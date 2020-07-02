//
//  AppDelegate.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/14.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,JPUSHRegisterDelegate,WXApiDelegate {


    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.sharedManager().enable = true
        //向微信注册
        WXApi.registerApp("wx1fd6951e3c339a26")
        
        //MARK jpush
        
        //通知类型（这里将声音、消息、提醒角标都给加上）
        let userSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                      categories: nil)
        if ((UIDevice.current.systemVersion as NSString).floatValue >= 8.0) {
            //可以添加自定义categories
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue,
                                  categories: nil)
        }
        else {
            //categories 必须为nil
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue,
                                  categories: nil)
        }
        
        // 启动JPushSDK
        JPUSHService.setup(withOption: nil, appKey: "3de63d9457b131f365d7a7fe",
                           channel: "Publish Channel", apsForProduction: false)
    
        UIApplication.shared.applicationIconBadgeNumber = 0
      
      window?.rootViewController = LoginViewController()
        
        return true
    }
   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //MARK : 微信
    private func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpen(url as URL!, delegate: self)
    }
    private func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpen(url as URL!, delegate: self)
    }
    private func onResp(resp: BaseResp!) {
        print(resp.type)
        if resp.isKind(of: SendMessageToWXResp.self){//确保是对我们分享操作的回调
            
            if resp.errCode == WXSuccess.rawValue{//分享成功
                NSLog("分享成功")
            }else{//分享失败
                NSLog("分享失败，错误码：%d, 错误描述：%@", resp.errCode, resp.errStr)
            }
        }
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        WXApi.handleOpen(url, delegate: self)
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        WXApi.handleOpen(url, delegate: self)
        return true
    }
    func onResp(_ resp: BaseResp!) {
        if resp.errCode == 0 && resp.type == 0 {//授权成功
            let response = resp as! SendAuthResp
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
        }
        
    }
    //MARK : 推送
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        print("userInfo123 = ",userInfo)
        completionHandler(.newData)
        if application.applicationState == .active {
            if  (userInfo["aps"] != nil){
                let aps :Dictionary <String,Any> = userInfo["aps"] as! Dictionary
                let alertView = UIAlertView.bk_alertView(withTitle: "提示", message: aps["alert"] as! String ) as! UIAlertView
                        alertView.bk_addButton(withTitle: "确定") {
                        }
                        alertView.bk_addButton(withTitle: "取消") {
                
                        }
                        alertView.show()
            }
        }
//
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        if application.applicationState == .active {
            if  (userInfo["aps"] != nil){
                let aps :Dictionary <String,Any> = userInfo["aps"] as! Dictionary
                let alertView = UIAlertView.bk_alertView(withTitle: "提示", message: aps["alert"] as! String ) as! UIAlertView
                alertView.bk_addButton(withTitle: "确定") {
                }
                alertView.bk_addButton(withTitle: "取消") {
                    
                }
                alertView.show()
            }
        }
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
        let userInfo = response.notification.request.content.userInfo
        print("userInfo = ",userInfo)
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
}

