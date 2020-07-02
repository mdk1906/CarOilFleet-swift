//
//  OilCardApplyTableViewCell.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/9/28.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class OilCardApplyTableViewCell: UITableViewCell {

    var titleLab :UILabel?
    var contentTF:UITextField?
    var hui:UIView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLab = UILabel()
        self.contentView.addSubview(titleLab!)
//        titleLab?.font = UIFont.systemFont(ofSize: 14)
        titleLab?.font = UIFont.systemFont(ofSize: 14)
        titleLab?.snp.makeConstraints({ (make)->Void in
            make.left.equalTo(23)
            make.top.equalTo(0)
            make.height.equalTo(50)
            make.width.equalTo(200)
        })
        
        contentTF = UITextField()
        contentTF?.textAlignment = .right
        self.contentView.addSubview(contentTF!)
        contentTF?.font = UIFont.systemFont(ofSize: 14)
        contentTF?.snp.makeConstraints({ (make)->Void in
            make.right.equalTo(-21)
            make.width.equalTo(200)
            make.top.equalTo(0)
            make.height.equalTo(50)
        })
        
        hui = UIView()
        hui?.backgroundColor = huiColor()
        self.contentView.addSubview(hui!)
        hui?.snp.makeConstraints({ (make)->Void in
            make.top.equalTo(49)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var OilCardApplyModel :OilCardApplyModel? {
        didSet {
            titleLab?.text = OilCardApplyModel?.title
            contentTF?.placeholder = OilCardApplyModel?.content
        }
    }
}
