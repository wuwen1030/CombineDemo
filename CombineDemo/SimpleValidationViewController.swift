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
    @Published var username: String = ""
    @Published var password: String = ""
    
    var signupButtonStream: AnyCancellable?
    var usernameStream: AnyCancellable?
    var passwordStream: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let validatedUsername = $username
            .removeDuplicates()
            .map {
                $0.count >= minCount ? $0 : nil
            }
        
        let validatedPassword = $password
            .removeDuplicates()
            .map {
                $0.count >= minCount ? $0 : nil
            }
        
        let validatedCredentials = Publishers.CombineLatest(validatedUsername, validatedPassword)
            .map { (username, password) -> (String, String)? in
                guard let uname = username, let pwd = password else { return nil }
                return (uname, pwd)
            }
        
        
        usernameStream = validatedUsername
            .print("username")
            .map {
                $0 != nil ? UIColor.green : UIColor.red
            }
            .assign(to: \.backgroundColor, on: usernameTextField)

        passwordStream = validatedPassword
            .print("password")
            .map {
                $0 != nil ? UIColor.green : UIColor.red
            }
            .assign(to: \.backgroundColor, on: passwordTextField)
        
        signupButtonStream = validatedCredentials
            .print("validatedCredentials")
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: signupButton)
        
        self.username = self.usernameTextField.text ?? ""
        self.password = self.passwordTextField.text ?? ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func usernameChanged(_ sender: UITextField) {
        username = sender.text ?? ""
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        password = sender.text ?? ""
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
