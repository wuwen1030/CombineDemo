//
//  NumbersViewController.swift
//  CombineDemo
//
//  Created by XIABIN on 2019/7/12.
//  Copyright © 2019 Koubei. All rights reserved.
//

import UIKit
import Combine

class NumbersViewController: UIViewController {

    @IBOutlet weak var number1TextField: UITextField!
    @IBOutlet weak var number2TextField: UITextField!
    @IBOutlet weak var number3TextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    var resultStream: AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()

        let number1 = self.nu mber1TextField.uicb.textPublisher().print("number1")
        let number2 = self.number2TextField.uicb.textPublisher().print("number2")
        let number3 = self.number3TextField.uicb.textPublisher().print("number3")
                
        resultStream = Publishers.CombineLatest3(number1, number2, number3)
            .print("result")
            .map { (value) -> String in
                let result = (Int(value.0) ?? 0) + (Int(value.1) ?? 0) + (Int(value.2) ?? 0)
                return result.description
            }
            .assign(to: \.text, on: resultLabel)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
