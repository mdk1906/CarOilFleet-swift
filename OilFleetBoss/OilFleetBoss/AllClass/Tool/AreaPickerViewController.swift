//
//  AreaPickerViewController.swift
//  Picker
//
//  Created by lsq on 2017/7/31.
//  Copyright © 2017年 罗石清. All rights reserved.
//

import UIKit
//省模型
struct MyAreaModel {
    let province: String        //省名称(湖南省)
    let citys   : [CityModel]   //市数组([长沙市,株洲市...])
}
//市模型
struct CityModel {
    let city: String    //市名称(长沙市)
    let areas: [String] //区数组([岳麓区,雨花区...])
}


class AreaPickerViewController: UIViewController, UIPickerViewDelegate ,UIPickerViewDataSource {
    //确认回调
    fileprivate var touchHandle: ((String,String,String)->Void)?
    fileprivate var titleT: String? //标题
    fileprivate var frame = CGRect()//坐标
    
    convenience init(title: String?, frame: CGRect, touchHandle: @escaping (String,String,String)->Void){
        self.init(nibName: nil, bundle: nil)
        
        self.touchHandle = touchHandle
        self.frame = frame
        self.titleT = title
    }
    //主要背景视图
    fileprivate var bgView: UIView!
    //标题
    fileprivate var titleLabel: UILabel!
    //地区选择视图
    fileprivate var myPickerView: UIPickerView!
    //底部按钮视图高度
    fileprivate var bottomViewHeight: CGFloat = 40
    
    
    //省市区数据模型
    fileprivate var myAreaDataArray = [MyAreaModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .custom
        
        self.loadSomeView()
        
        //读取地区数据
        if let areaList = Bundle.main.path(forResource: "areas", ofType: "plist"){
            
            if let dic = NSDictionary(contentsOfFile: areaList) as? [String : Any]{
                self.creatSomeArrayData(with: dic)
            }
        }
        
        
    }
    //创建视图
    fileprivate func loadSomeView(){
        //1.背景视图
        bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor.white
        self.view.addSubview(bgView)
        //2.标题label
        titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: bgView.frame.width, height: 25))
        titleLabel.text = self.titleT
        titleLabel.backgroundColor = UIColor.white
        titleLabel.textColor = homeColor()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        bgView.addSubview(titleLabel)
        //3.地区选择视图
        let pickerY = titleLabel.frame.height + titleLabel.frame.origin.y - 5
        let pickerH = self.frame.height - pickerY - self.bottomViewHeight
        myPickerView = UIPickerView(frame: CGRect(x: 0, y: pickerY, width: bgView.frame.width, height: pickerH))
        myPickerView.backgroundColor = UIColor.white
        myPickerView.delegate = self
        myPickerView.dataSource = self
        bgView.addSubview(myPickerView)
        //4.底部按钮
        let bottomY = myPickerView.frame.origin.y + myPickerView.frame.height
        let bottomView = UIView(frame: CGRect(x: 0, y: bottomY, width: bgView.frame.width, height: self.bottomViewHeight))
        bottomView.backgroundColor = UIColor.white
        bgView.addSubview(bottomView)
        //线条
        let line = UIView(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: 0.5))
        line.backgroundColor = UIColor.groupTableViewBackground
        bottomView.addSubview(line)
        //按钮高度
        let btnY = line.frame.height
        let btnH = bottomView.frame.height - btnY
        
        //加载按钮
        let btnArr = ["取消","确定"]
        let btnW = bottomView.frame.width / CGFloat(btnArr.count)
        let bgColorArr = [UIColor.white,homeColor()]
        let titleColorsArr = [homeColor(),UIColor.white]
        
        for i in 0..<btnArr.count{
            let btnX = CGFloat(i) * btnW
            
            let btn = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnW, height: btnH))
            btn.backgroundColor = bgColorArr[i]
            btn.setTitle(btnArr[i], for: .normal)
            btn.setTitleColor(titleColorsArr[i], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.addTarget(self, action: #selector(self.btnAct(_:)), for: .touchUpInside)
            btn.tag = i
            bottomView.addSubview(btn)
        }
        
    }
    //TODO:按钮点击事件
    func btnAct(_ send: UIButton){
        
        let tag = send.tag
        
        print(tag)
        
        if tag == 0 {
            print("取消")
        }else{
            //获取省index
            let proSelect = myPickerView.selectedRow(inComponent: 0)
            //获取市index
            let areaSelect = myPickerView.selectedRow(inComponent: 1)
            //获取区index
            let citySelect = myPickerView.selectedRow(inComponent: 2)
            
            //省(湖南省)
            let pro = self.myAreaDataArray[proSelect].province
            //市(长沙市)
            let area = self.myAreaDataArray[proSelect].citys[areaSelect].city
            //区(岳麓区)
            let city = self.myAreaDataArray[proSelect].citys[areaSelect].areas[citySelect]

            //TODO:回调
            self.touchHandle?(pro,area,city)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    //TODO:根据字典生成数据模型
    fileprivate func creatSomeArrayData(with dic: [String : Any]){
        
        var myAreaModelArray = [MyAreaModel]()
        
        //获取省
        for i in 0..<dic.count{
            
            let tmp1 = dic["\(i)"] as! [String:Any]
            //省份
            let key = Array(tmp1.keys).first!

            //2.市区
            //存放市区数组
            var cityModelArray = [CityModel]()
            let TMPproDic = tmp1[key] as! [String:Any]
            for j in 0..<TMPproDic.count{
                let proDic = TMPproDic["\(j)"] as! [String:Any]
                print(proDic)
                //市名称
                let proKey = Array(proDic.keys).first!

                //地区
                let TMPareaArray = proDic[proKey] as! [String]

                let cityModel = CityModel(city: proKey, areas: TMPareaArray)
                cityModelArray.append(cityModel)
            }
     
            let myAreaModel = MyAreaModel(province: key, citys: cityModelArray)
            myAreaModelArray.append(myAreaModel)
        }
        self.myAreaDataArray = myAreaModelArray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self.bgView)
        if !(self.bgView.layer.contains(point)){
            self.dismiss(animated: false, completion: nil)
        }
    }

 
    //picker代理
    //多少列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    //每行多少个
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.myAreaDataArray.count
        case 1:
            let row0 = pickerView.selectedRow(inComponent: 0)
            return self.myAreaDataArray[row0].citys.count
        default:
            let row0 = pickerView.selectedRow(inComponent: 0)
            let row1 = pickerView.selectedRow(inComponent: 1)
            return self.myAreaDataArray[row0].citys[row1].areas.count
        }
        
    }
    
    //每行什么内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return self.myAreaDataArray[row].province
        case 1:
            let row0 = pickerView.selectedRow(inComponent: 0)
            return self.myAreaDataArray[row0].citys[row].city
        default:
            let row0 = pickerView.selectedRow(inComponent: 0)
            var row1 = pickerView.selectedRow(inComponent: 1)
            //处理同时滑动的bug
            let r0 = self.myAreaDataArray[row0].citys
            var endRow = row
            if row1 >= r0.count{
                row1 = 0
            }
            let r1 = self.myAreaDataArray[row0].citys[row1].areas
            if endRow >= r1.count{
                endRow = 0
            }
            return self.myAreaDataArray[row0].citys[row1].areas[endRow]
        }
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0://滑动了省份
            self.myPickerView.reloadComponent(1)
            self.myPickerView.selectRow(0, inComponent: 1, animated: true)
            
            self.myPickerView.reloadComponent(2)
            self.myPickerView.selectRow(0, inComponent: 2, animated: true)
            
        case 1://滑动了市
            self.myPickerView.reloadComponent(2)
            self.myPickerView.selectRow(0, inComponent: 2, animated: true)
        case 2://滑动了地区
            break
        default:
            break
        }
    }
    
    
    
   

}
