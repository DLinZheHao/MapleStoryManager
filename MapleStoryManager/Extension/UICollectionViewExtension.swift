//
//  UICollectionViewExtension.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/2/1.
//

import UIKit

extension UICollectionView {

    /// 註冊 cell xib
    /// - Parameters:
    ///   - identifier: cell 名稱
    ///   - bundle:  一般為 nil
    func registerCellWithNib(identifier: String, bundle: Bundle?) {
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    /// 註冊 header, footer cell xib
    /// - Parameters:
    ///   - identifier: cell 名稱
    ///   - bundle:  一般為 nil
    func registerReusableViewWithNib(identifier: String, bundle: Bundle?) {
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
}

extension UICollectionViewCell {
    
    /// 取得 cell 名稱
    static var identifier: String {
        return String(describing: self)
    }
}

