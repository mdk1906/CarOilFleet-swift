//
//  RegistPhoViewController.swift
//  OilFleetBoss
//
//  Created by mdk mdk on 17/10/9.
//  Copyright © 2017年 mdk mdk. All rights reserved.
//

import UIKit

class RegistPhoViewController: MDKBaseViewController{
    
    @IBOutlet weak var phoTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleX?.text = "注册"
        phoTf.layer.cornerRadius = 4
        phoTf.layer.masksToBounds = true
        phoTf.layer.borderColor = homeColor().cgColor
        phoTf.layer.borderWidth = 1
        phoTf.keyboardType = .phonePad
        phoTf.delegate = self
        phoTf.addTarget(self, action: #selector(tfInPut), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tfInPut(tf:UITextField)  {
        
        if tf.text?.characters.count == 11{
             if isPhoneNumber(phoneNumber: tf.text!) == false {
                loadFailure(msg: "请输入正确的手机号码")
             }else{
            let vc = RegistCodeViewController()
            vc.phoStr = tf.text
            self.present(vc, animated: true, completion: nil)
            }
        }
    }
    override func leftEvent() {
        self.dismiss(animated: true, completion: nil)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.characters.count + string.characters.count - range.length
        
        return textLength<=11
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
