//
//  UITextField+Combine.swift
//  CombineDemo
//
//  Created by XIABIN on 2019/8/20.
//  Copyright © 2019 Koubei. All rights reserved.
//

import UIKit
import Combine

extension UIKitCombineExtension where ExtendedType: UITextField {
    func textPublisher(debounceInterval: Int = 500) -> AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                                object: self.type)
            .map { notication -> String in
                let sender = notication.object as! UITextField
                return sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            .debounce(for: .milliseconds(debounceInterval), scheduler: RunLoop.main)
            .removeDuplicates()
            .prepend(self.type.text ?? "")
            .eraseToAnyPublisher()
    }
}
