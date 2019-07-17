//
//  GithubServiceProtocols.swift
//  CombineDemo
//
//  Created by XIABIN on 2019/7/16.
//  Copyright © 2019 Koubei. All rights reserved.
//

import Combine
import Foundation

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

protocol GithubValidationService {
    func validateUsername(_ username: String) -> AnyPublisher<ValidationResult, Never>
}

protocol GithubAPI {
    func usernameAvailable(_ username: String) -> AnyPublisher<Bool, Never>
//    func signup(_ username: String, password: String) -> AnyPublisher<Bool, Never>
}
