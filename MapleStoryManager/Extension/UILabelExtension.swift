//
//  UILabelExtension.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/1/31.
//

import Foundation
import UIKit

extension UILabel {
    private func textLineHeight(text: String?, font: UIFont, align: NSTextAlignment, customLineHeight: CGFloat, color: UIColor) {
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.minimumLineHeight = customLineHeight
        paragrahStyle.maximumLineHeight = customLineHeight
        paragrahStyle.lineBreakMode = .byTruncatingTail
        paragrahStyle.alignment = align

        let attributedText = NSMutableAttributedString(string: text ?? "")
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrahStyle, range: NSMakeRange(0, attributedText.length)) // 文字
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedText.length)) // 顏色
        let offset = (customLineHeight - font.lineHeight) / 4 // 微調行距
        attributedText.addAttribute(NSAttributedString.Key.baselineOffset, value: offset, range: NSMakeRange(0, attributedText.length))
        self.font = font
        self.attributedText = attributedText
    }
}
