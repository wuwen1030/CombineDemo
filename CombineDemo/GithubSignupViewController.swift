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
            .eraseToAnyPublisher()
    }
}

class GithubSignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var loadingStream: AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let usernameValidPublisher = usernameTextField.inputPublisher()
            .flatMap {
                GithubDefaultValidationService.shared.validateUsername($0)
        }
        
        _ = usernameValidPublisher.receive(on: RunLoop.main)
            .sink { result in
                switch result {
                case .empty:
                    self.usernameTextField.backgroundColor = .clear
                    self.loadingIndicator.stopAnimating()
                case .ok:
                    self.usernameTextField.backgroundColor = .green
                    self.loadingIndicator.stopAnimating()
                case .failed:
                    self.usernameTextField.backgroundColor = .red
                    self.loadingIndicator.stopAnimating()
                case .validating:
                    self.usernameTextField.backgroundColor = .clear
                    self.loadingIndicator.startAnimating()
                }
        }
    }
    
    func inputPublisher(_ textField: UITextField) -> AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
            .map { notication -> String in
                let sender = notication.object as! UITextField
                return sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    func setupUI() {
        
    }
}
