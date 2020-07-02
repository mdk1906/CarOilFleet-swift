//
//  OrderDetailsTableViewCell.swift
//  CarOilFleetService
//
//  Created by mdk mdk on 17/10/16.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var workType: UILabel!
    @IBOutlet weak var oilTotal: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var OrderDetailsModel:OrderDetailsModel? {
        didSet {
            workType.isHidden = true
            
            nameLab.text = OrderDetailsModel?.custNname
            let m = OrderDetailsModel?.oilQuantity
            oilTotal.text = "申请叫油" + (m?.description)! + "升"
            
        }
    }
}
