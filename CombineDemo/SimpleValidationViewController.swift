//
//  SimpleValidationViewController.swift
//  CombineDemo
//
//  Created by XIABIN on 2019/7/2.
//  Copyright © 2019 Koubei. All rights reserved.
//

import UIKit
import Combine

let minCount = 5

class SimpleValidationViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let validatedUsername = usernameTextField.inputPublisher(debounceInterval: 100)
            .map { $0.count >= minCount ? $0 : nil }
        
        let validatedPassword = passwordTextField.inputPublisher(debounceInterval: 100)
            .map { $0.count >= minCount ? $0 : nil }
        
        _ = validatedUsername
            .print("username")
            .map { $0 != nil ? UIColor.green : UIColor.red }
            .receive(on: RunLoop.main)
            .assign(to: \.backgroundColor, on: usernameTextField)
        
        _ = validatedPassword
            .print("password")
            .map { $0 != nil ? UIColor.green : UIColor.red }
            .receive(on: RunLoop.main)
            .assign(to: \.backgroundColor, on: passwordTextField)
        
        _ = Publishers.CombineLatest(validatedUsername, validatedPassword)
            .print("validatedCredentials")
            .map { (username, password) -> Bool in
                guard let _ = username, let _ = password
                    else {
                        return false
                }
                return true
            }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: signupButton)
    }
        
    /*"
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
