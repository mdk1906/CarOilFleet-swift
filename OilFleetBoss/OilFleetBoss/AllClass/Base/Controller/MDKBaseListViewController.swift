//
//  MDKBaseListViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 2018/1/26.
//  Copyright © 2018年 mdk mdk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class MDKBaseListViewController: MDKBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView?
    var cellID = "MDKbaseTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView()
        tableView?.frame = CGRect(x:0,y:64,width:WindowWidth,height:WindowHeight-64)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = huiColor()
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView?.register(MDKbaseTableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return 1
    }
    //绘制cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MDKbaseTableViewCell
        cell.selectionStyle = .none
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
