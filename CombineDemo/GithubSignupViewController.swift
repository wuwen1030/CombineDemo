//
//  GithubSignupViewController.swift
//  CombineDemo
//
//  Created by XIABIN on 2019/7/15.
//  Copyright © 2019 Koubei. All rights reserved.
//

import UIKit
import Combine

class GithubSignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameValidView: UIImageView!
    @IBOutlet weak var passwordValidView: UIImageView!
    @IBOutlet weak var passwordRepeatValidView: UIImageView!
    
    var usernameValidStream: AnyCancellable?
    var signupStream: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernameValidPublisher = usernameTextField.textPublisher()
            .print("username")
            .flatMap { GithubDefaultValidationService.shared.validateUsername($0) }
                
        usernameValidStream = AnyCancellable (
            usernameValidPublisher.receive(on: RunLoop.main)
                .sink { result in
                    switch result {
                    case .empty:
                        self.usernameValidView.image = UIImage(named: "error")
                        self.loadingIndicator.stopAnimating()
                    case .ok:
                        self.usernameValidView.image = UIImage(named: "success")
                        self.loadingIndicator.stopAnimating()
                    case .failed:
                        self.usernameValidView.image = UIImage(named: "error")
                        self.loadingIndicator.stopAnimating()
                    case .validating:
                        self.usernameValidView.image = nil
                        self.loadingIndicator.startAnimating()
                    }
            }
        )
        
        let passwordValidPublisher = passwordTextField.textPublisher()
            .print("password")
            .map {GithubDefaultValidationService.shared.validatePassword($0)}
        
        _ = passwordValidPublisher
            .map{ UIImage(named: $0.isValid ? "success" : "error") }
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: passwordValidView)
        
        let passwordRepeatValidPublisher = Publishers.CombineLatest(
            passwordTextField.textPublisher(),
            passwordRepeatTextField.textPublisher())
            .print("repeatPassword")
            .map {GithubDefaultValidationService.shared.validateRepeatedPassword($0.0, repeatedPassword: $0.1)}
        
        _ = passwordRepeatValidPublisher
            .map{ UIImage(named: $0.isValid ? "success" : "error") }
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: passwordRepeatValidView)

        _ = Publishers.CombineLatest3(usernameValidPublisher, passwordValidPublisher, passwordRepeatValidPublisher)
            .print("signupValid")
            .map { $0.0.isValid && $0.1.isValid && $0.2.isValid}
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submitButton)
        
//        signupStream = AnyCancellable(
//            submitButton.tap.sink { _ in
//                print("tapped")
//        })
    }
}
