//
//  UITextFieldExtension.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/2/17.
//

import UIKit
import Combine

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }

}
