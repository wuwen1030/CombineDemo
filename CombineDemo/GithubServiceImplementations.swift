//
//  GithubServiceImplementations.swift
//  CombineDemo
//
//  Created by XIABIN on 2019/7/16.
//  Copyright © 2019 Koubei. All rights reserved.
//

import Foundation
import Combine

class GithubDefaultValidationService: GithubValidationService {
    static let shared = GithubDefaultValidationService(API: GithubDefaultAPI.shared)
    let API: GithubAPI

    init(API: GithubAPI) {
        self.API = API
    }
    
    func validateUsername(_ username: String) -> AnyPublisher<ValidationResult, Never> {
        if username.isEmpty {
            return Just(.empty)
                .eraseToAnyPublisher()
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return Just(.failed(message: "Username can only contain numbers or digits"))
                .eraseToAnyPublisher()
        }

        return API
            .usernameAvailable(username)
            .map { valid -> ValidationResult in
                return valid ? .ok(message: "Username available") : .failed(message: "Username already taken")
            }
            .prepend(.validating)
            .eraseToAnyPublisher()
    }
    
    let minPasswordCount = 5
    
    func validatePassword(_ password: String) -> ValidationResult {
        if password.count == 0 {
            return .empty
        }
        
        if password.count < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        
        return .ok(message: "Password acceptable")
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }
        
        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }
    }
    
}

class GithubDefaultAPI: GithubAPI {
    static let shared = GithubDefaultAPI()
    
    func usernameAvailable(_ username: String) -> AnyPublisher<Bool, Never> {
        let url = URL(string: "https://github.com/\(username)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { tuple in
                let response = tuple.response as! HTTPURLResponse
                return response.statusCode == 404
            }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
//    func signup(_ username: String, password: String) -> AnyPublisher<Bool, Never> {
//
//    }
}
