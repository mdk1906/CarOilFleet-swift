//
//  MDKConst.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/14.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire


/// 第一次启动
let YMFirstLaunch = "firstLaunch"
/// 是否登录
let isLogin = "isLogin"
//微信工种号
let WX_APPID = "wx1fd6951e3c339a26"
//

let WX_APPSecret = "30283404ce37d48599225cafbc970cc1"
/// code 码 200 操作成功
let RETURN_OK = 200
/// 间距
let kMargin: CGFloat = 10.0
/// 圆角
let kCornerRadius: CGFloat = 5.0
/// 线宽
let klineWidth: CGFloat = 1.0
/// 首页顶部标签指示条的高度
let kIndicatorViewH: CGFloat = 2.0
/// 新特性界面图片数量
let kNewFeatureCount = 4
/// 顶部标题的高度
let kTitlesViewH: CGFloat = 35
/// 顶部标题的y
let kTitlesViewY: CGFloat = 64
/// 动画时长
let kAnimationDuration = 0.25
/// 屏幕的宽
let WindowWidth = UIScreen.main.bounds.size.width
/// 屏幕的高
let WindowHeight = UIScreen.main.bounds.size.height
/// 分类界面 顶部 item 的高
let kitemH: CGFloat = 100
/// 分类界面 顶部 item 的宽
let kitemW: CGFloat = 150
/// 我的界面头部图像的高度
let kYMMineHeaderImageHeight: CGFloat = 200
// 分享按钮背景高度
let kTopViewH: CGFloat = 230


/// RGBA的颜色设置
func MDKColor(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

/// 背景灰色
func GlobalColor() -> UIColor {
    return MDKColor(r: 240, g: 240, b: 240, a: 1)
}

/// 红色
func GlobalRedColor() -> UIColor {
    return MDKColor(r: 245, g: 80, b: 83, a: 1.0)
}
func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {         return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                                                                           green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                                                                           blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                                                                           alpha: 1.0)
}
//homeColor 0xe88713
func homeColor() -> UIColor{
    return kRGBColorFromHex(rgbValue: 0x1e82d0)
}
//灰色
func huiColor() -> UIColor{
    return kRGBColorFromHex(rgbValue: 0xeeeeee)
}
//字体颜色
func fontColor() -> UIColor{
    return kRGBColorFromHex(rgbValue: 0x333333)
}
/// iPhone 5
let isIPhone5 = WindowHeight == 568 ? true : false
/// iPhone 6
let isIPhone6 = WindowHeight == 667 ? true : false
/// iPhone 6P
let isIPhone6P = WindowHeight == 736 ? true : false

let codeOne = "1"

func loading (){
    JavenHUD.showMessage(message: "", type: JWProgressHUDType.loading, complectionClosure: {
        //加载中
        //var timer: Timer?
        
    })
}
func loadSuccess(){
    JavenHUD.showMessage(message: "加载成功", type: JWProgressHUDType.success, complectionClosure: {
        //成功
    })
}
func loadFailure (msg:String){
    JavenHUD.showMessage(message: msg, type: JWProgressHUDType.message, complectionClosure: {
        //成功
    })
}
func saveWithNSUserDefaults(content:String,key:String) {
    // 1、利用NSUserDefaults存储数据
    let defaults = UserDefaults.standard;
    // 2、存储数据
    defaults.set(content, forKey: key);
    // 3、同步数据
    defaults.synchronize();
}
func removeWithKey(key:String){
    // 1、利用NSUserDefaults存储数据
    let defaults = UserDefaults.standard;
    defaults.removeSuite(named: key)
}
func readWithNSUserDefaults(key:String)->String{
    let defaults = UserDefaults.standard;
    let obj = defaults.string(forKey: key)
    return obj!
}
 func timeStampToString(timeStamp:String)->String {
    
    let string = NSString(string: timeStamp)
    
    let timeSta:TimeInterval = string.doubleValue
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="yyyy年MM月dd日 HH:mm"
    let date = NSDate(timeIntervalSince1970: timeSta)
    return dfmatter.string(from: date as Date)
}
//判断手机号
func isPhoneNumber(phoneNumber:String) -> Bool {
    if phoneNumber.count == 0 {
        return false
    }
    let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
    let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    if regexMobile.evaluate(with: phoneNumber) == true {
        return true
    }else
    {
        return false
    }
}
/*!
 验证身份证
 
 - returns: true/false
 */
func chk18PaperId(sfz:String) -> Bool {
    //判断位数
    if sfz.count != 15 && sfz.count != 18 {
        return false
    }
    var carid = sfz
    
    _ = 0
    
    //加权因子
    let R = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
    
    //校验码
    let sChecker: [Int8] = [49,48,88, 57, 56, 55, 54, 53, 52, 51, 50]
    
    //将15位身份证号转换成18位
    let mString = NSMutableString.init(string: sfz)
    
    if sfz.count == 15 {
        mString.insert("19", at: 6)
        var p = 0
        let pid = mString.utf8String
        for i in 0...16 {
            p += (pid![i]-48) * R[i]
        }
        let o = p % 11
        let stringContent = NSString(format: "%c", sChecker[o])
        mString.insert(stringContent as String, at: mString.length)
        carid = mString as String
        return false
    }
    else{
        return true
    }
}

let custImg = UserDefaults.standard.string(forKey: "custImg")
let custNname = UserDefaults.standard.string(forKey: "custNname")
let custNo = UserDefaults.standard.string(forKey: "custNo")
// MARK: 账号密码
let phoneNum = UserDefaults.standard.string(forKey: "phone")
let passWord = UserDefaults.standard.string(forKey: "passWord")
let custId = UserDefaults.standard.string(forKey: "custId")

var headImgStr = "默认头像"
//全局变量
var workerXuanZe = "未编辑"
// MARK: token
//let token = UserDefaults.standard.string(forKey: "token")
var token = OilValue.shared.token
//电话
var userPhone = OilValue.shared.userPhone

//用户昵称
var userName = OilValue.shared.userName

// MARK : - 扫码
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}
//判断是真机还是模拟器的方法
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

//这样就是在建立宏

let kIOS8 = Double(UIDevice.current.systemVersion) >= 8.0 ? 1 : 0

let kScreenHeight = UIScreen.main.bounds.size.height-64
let kScreenWidth = UIScreen.main.bounds.size.width

// MARK: 接口地址
let headers: HTTPHeaders = [
    "Accept": "application/json",
    "devType":"1"
]
/// 服务器地址
var BASE_URL = "http://test.chezutong.com/my-security/api/v1"
//文件域名
var FEIL_URL = "http://test.chezutong.com"
//上传文件接口
var k_file = "/file/fileUpload"

//注册/user/register
var k_register = "/user/register"

//登录
var k_Login = "/user/login"

//找回密码
var k_forgetPass = "/user/forgotPassword"

//发送验证码
var k_sendSms = "/user/sendSms"

//添加工地
var k_add = "/engineering/add"

//我的工地列表
var k_siteList = "/engineering/list"

//删除工地engineering/del
var k_delSite = "/engineering/del"

//修改工地信息
var k_editSite = "/engineering/edit"

//oilcard/cardlist我的油卡
var k_cardList = "/oilcard/list2"

//oilcard/applycard申请油卡填写信息
var k_applyCard = "/oilcard/applycard"

//oilcard/editcard上传身份证
var k_editCard = "/oilcard/editcard"

//下单money改油
var K_oilAdd = "/station/add"

//user/getcustbyid查询用户数据
var k_getCus = "/user/getcustbyid"

//修改用户信息
var k_modify = "/user/modify"

//油卡额度申请
var k_applyBlance = "/oilcard/applybalance"

//首页banner图/config/getbykey
var k_getByKey = "/config/getbykey"

//分卡列表/oilcard/list
var k_fenkaList = "/oilcard/list"

//我的雇工列表/employee/list
var k_employeeList = "/employee/list"

//接触绑定/employee/del
var k_employeeDel = "/employee/del"

//批量解绑
var k_delEmpoys = "/employee/delEmployees"
//新增雇工/employee/add
var k_employAdd = "/employee/add"

//分卡额度分配
var k_oilCardAddBlance = "/oilcard/addbalance"

//下单列表
var k_oilList = "/station/list2"

//banners
var k_banners = "/config/getlistbykey"

//我的下单列表
var k_myOrder = "/station/oillist"

//我的申请
var k_applyList = "/oilcard/applylist"

//油卡申请
var k_oilCardApplyList = "/oilcard/applyOilCardList"

//分卡账单/order/orderList
var k_orderList = "/order/orderList"

var k_editPassword = "/user/editPassword"

//查询绑定微信公众号
var k_isBangding = "/applycash/isBindWx"

//绑定微信公众号
var k_bangdingWX = "/order/bindWx"

//提现申请
var k_tixianApply = "/applycash/apply"

//提现记录
var k_accountHistory = "/applycash/accountHistory"

//订单列表详情
var k_orderDetail = "/station/detail"

//查询雇工
var k_bindEmployee = "/employee/bindEmployee"

//个人积分账户信息
var k_custInfo = "/oil/app/oil00001"

//删除订单
var k_cancelOrder = "/order/cancelOrder"

//提成列表
var k_commissionList = "/oil/app/oil000010"

//积分列表
var k_IntegralWithdrawalList = "/oil/app/oil000011"

//佣金列表
var k_CommissionWithdrawalList = "/oil/app/oil000012"

//申请提现
var k_applyMoney = "/oil/app/oil000013"

//申请提现列表
var k_WithdrawalRecord = "/oil/app/oil000015"

//查询是否绑定微信
var k_isbangdingWX = "/oil/app/oil000016"

//用户二维码
var k_QRCode = "/wx/bindWxCode"
