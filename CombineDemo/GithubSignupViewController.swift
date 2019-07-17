//
//  GithubSignupViewController.swift
//  CombineDemo
//
//  Created by XIABIN on 2019/7/15.
//  Copyright © 2019 Koubei. All rights reserved.
//

import UIKit
import Combine

extension UITextField {
    func inputPublisher(debounceInterval: Int = 500) -> AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                             object: self)
            .map { notication -> String in
                let sender = notication.object as! UITextField
                return sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            .debounce(for: .milliseconds(debounceInterval), scheduler: RunLoop.main)
            .removeDuplicates()
            .prepend(self.text ?? "")
            .eraseToAnyPublisher()
    }
}

class GithubSignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameValidView: UIImageView!
    @IBOutlet weak var passwordValidView: UIImageView!
    @IBOutlet weak var passwordRepeatValidView: UIImageView!
    
    var signupStream: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let usernameValidPublisher = usernameTextField.inputPublisher()
            .print("username")
            .flatMap { GithubDefaultValidationService.shared.validateUsername($0) }
        
        _ = usernameValidPublisher.receive(on: RunLoop.main)
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
        
        let passwordValidPublisher = passwordTextField.inputPublisher()
            .print("password")
            .map {GithubDefaultValidationService.shared.validatePassword($0)}
        
        _ = passwordValidPublisher
            .receive(on: RunLoop.main)
            .sink { self.passwordValidView.image = UIImage(named: $0.isValid ? "success" : "error") }
        
        let passwordRepeatValidPublisher = Publishers.CombineLatest(
            passwordTextField.inputPublisher(),
            passwordRepeatTextField.inputPublisher())
            .print("repeatPassword")
            .map {GithubDefaultValidationService.shared.validateRepeatedPassword($0.0, repeatedPassword: $0.1)}
        
        _ = passwordRepeatValidPublisher
            .receive(on: RunLoop.main)
            .sink { self.passwordRepeatValidView.image = UIImage(named: $0.isValid ? "success" : "error") }

        signupStream = Publishers.CombineLatest3(usernameValidPublisher, passwordValidPublisher, passwordRepeatValidPublisher)
            .map { $0.0.isValid && $0.1.isValid && $0.2.isValid}
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submitButton)
    }
    
    func setupUI() {
        
    }
}
