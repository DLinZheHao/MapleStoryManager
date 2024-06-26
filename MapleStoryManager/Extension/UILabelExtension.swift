//
//  UILabelExtension.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/1/31.
//

import Foundation
import UIKit

extension UILabel {
    /**
     設定文字的Height

     - parameter text: 文字
     - returns: AttributedString
     */
    @objc func textLineHeight(_ text: String?) {
        textLineHeight(text, font: font)
    }

    /**
     設定文字的Height

     - parameter text: 文字
     - parameter font: 字型
     - returns: AttributedString
     */
    @objc func textLineHeight(_ text: String?, font: UIFont) {
        textLineHeight(text: text, font: font, align: textAlignment, customLineHeight: UIFont.getLineHeight(for: font), color: textColor)
    }

    /**
     設定文字的Height

     - parameter text: 文字
     - parameter font: 字型
     - parameter align: 對齊
     */
    @objc func textLineHeight(_ text: String?, font: UIFont, align: NSTextAlignment) {
        textLineHeight(text: text, font: font, align: align, customLineHeight: UIFont.getLineHeight(for: font), color: textColor)
    }

    /**
     設定文字的Height，字型大小用 self.font

     - parameter text: 文字
     - parameter align: 對齊
     */
    @objc func textLineHeight(_ text: String?, align: NSTextAlignment) {
        textLineHeight(text, font: font, align: align)
    }

    /// 設定文字的Height
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - font: 字型
    ///   - color: 顏色
    @objc func textLineHeight(_ text: String?, font: UIFont, color: UIColor) {
        textLineHeight(text: text, font: font, align: textAlignment, customLineHeight: UIFont.getLineHeight(for: font), color: color)
    }

    /// 設定文字的Height
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - font: 字型
    ///   - align: 對齊
    ///   - customLineHeight: 行高
    ///   - color: 顏色
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

/// 設定內間距的 UILabel
class UILabelPadding : UILabel {

    private var padding = UIEdgeInsets.zero

    @IBInspectable
    var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }

    @IBInspectable
    var paddingRight: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }

    @IBInspectable
    var paddingTop: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }

    @IBInspectable
    var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = self.padding
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}
