//
//  UITableViewExtension.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/1/30.
//

import Foundation
import UIKit

extension UITableView {
    /// 註冊 cell xib
    /// - Parameters:
    ///   - identifier: cell 名稱
    ///   - bundle:  一般為 nil
    func registerCellWithNib(identifier: String, bundle: Bundle?) {
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: identifier)
    }

    /// 註冊 header, footer cell xib
    /// - Parameters:
    ///   - identifier: cell 名稱
    ///   - bundle:  一般為 nil
    func registerHeaderWithNib(identifier: String, bundle: Bundle?) {
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}

extension UITableViewCell {
    /// 取得 cell 名稱
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    /// 取得 header, footer 名稱
    static var identifier: String {
        return String(describing: self)
    }
}
