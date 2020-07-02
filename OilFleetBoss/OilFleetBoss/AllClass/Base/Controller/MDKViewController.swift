//
//  MDKViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/14.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class MDKViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = MDKColor(r: 245, g: 90, b: 93, a: 1/0)
        tabBar.tintColor = homeColor()
        addChildViewControllers()
        // Do any additional setup after loading the view.
    }

    
    
    /**
     * 添加子控制器
     */
    private func addChildViewControllers(){
        addChildViewController(childController: HomeViewController(), title: "加油", imageName: "加油")
        addChildViewController(childController: MyPlaceTheOrderViewController(), title: "订单", imageName: "订单")
        addChildViewController(childController: MineViewController(), title: "我的", imageName: "我的")
    }
    /**
     # 初始化子控制器
     
     - parameter childControllerName: 需要初始化的控制器
     - parameter title:               标题
     - parameter imageName:           图片名称
     */
    private func addChildViewController(childController: UIViewController, title: String, imageName: String) {
        childController.tabBarItem.image = UIImage(named: imageName)
         childController.tabBarItem.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "selected")
        childController.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        childController.title = title
        let navC = MDKNavigationController(rootViewController: childController)
        addChildViewController(navC)
    }


}
