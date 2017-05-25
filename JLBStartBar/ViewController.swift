//
//  ViewController.swift
//  JLBStartBar
//
//  Created by andehang on 2017/5/25.
//  Copyright © 2017年 andehang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var startBar: JLBStartBar!
    @IBOutlet weak var scoreTextFeild: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        scoreTextFeild.text = nil
        
        let score = (string as NSString).floatValue
        print("\(score)")
        if score >= 0 && score <= 5
        {
            startBar.score = CGFloat(score)
            return true
        }
        else
        {
            return false
        }
    }
}

