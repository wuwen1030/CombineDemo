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

    @Published var number1: String = ""
    @Published var number2: String = ""
    @Published var number3: String = ""
    @IBOutlet weak var number1TextField: UITextField!
    @IBOutlet weak var number2TextField: UITextField!
    @IBOutlet weak var number3TextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    var resultStream: AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()

        resultStream = Publishers.CombineLatest3($number1, $number2, $number3)
            .map { (value) -> String in
                let result = (Int(value.0) ?? 0) + (Int(value.1) ?? 0) + (Int(value.2) ?? 0)
                return result.description
            }
            .assign(to: \.text, on: resultLabel)
        
        number1TextField.text = "1"
        number2TextField.text = "2"
        number1TextField.text = "3"
        number1 = "1"
        number2 = "2"
        number3 = "3"
    }
    

    @IBAction func number1Changed(_ sender: UITextField) {
        number1 = sender.text ?? ""
    }
    
    @IBAction func number2Changed(_ sender: UITextField) {
        number2 = sender.text ?? ""
    }
    
    
    @IBAction func number3Changed(_ sender: UITextField) {
        number3 = sender.text ?? ""
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
