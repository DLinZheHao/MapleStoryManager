//
//  UIFontExtension.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/5/15.
//

import UIKit

/// 可否設定行高倍數
private var multiple = 0
extension UIFont {
    /// 行高倍數
    @objc var lineHeightMultiple: CGFloat {
        get {
            return objc_getAssociatedObject(self, &multiple) as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, &multiple, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIFont {
    // MARK: 一般細體
    @objc static func iOS_font26() -> UIFont {
        return UIFont.systemFont(ofSize: 26.0)
    }
    @objc static func iOS_font25() -> UIFont {
        return UIFont.systemFont(ofSize: 25.0)
    }
    @objc static func iOS_font22() -> UIFont {
        return UIFont.systemFont(ofSize: 22.0)
    }
    @objc static func iOS_font20() -> UIFont {
        return UIFont.systemFont(ofSize: 20.0)
    }
    @objc static func iOS_font19() -> UIFont {
        return UIFont.systemFont(ofSize: 19.0)
    }
    @objc static func iOS_font18() -> UIFont {
        return UIFont.systemFont(ofSize: 18.0)
    }
    @objc static func iOS_font17() -> UIFont {
        return UIFont.systemFont(ofSize: 17.0)
    }
    @objc static func iOS_font16() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0)
    }
    @objc static func iOS_font14() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0)
    }
    @objc static func iOS_font13() -> UIFont {
        return UIFont.systemFont(ofSize: 13.0)
    }
    @objc static func iOS_font12() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0)
    }
    @objc static func iOS_font10() -> UIFont {
        return UIFont.systemFont(ofSize: 10.0)
    }
    @objc static func iOS_font9() -> UIFont {
        return UIFont.systemFont(ofSize: 9.0)
    }

    // MARK: 粗體
    @objc static func iOS_boldFont26() -> UIFont {
        return UIFont.systemFont(ofSize: 26.0, weight: .semibold)
    }
    @objc static func iOS_boldFont25() -> UIFont {
        return UIFont.systemFont(ofSize: 25.0, weight: .semibold)
    }
    @objc static func iOS_boldFont22() -> UIFont {
        return UIFont.systemFont(ofSize: 22.0, weight: .semibold)
    }
    @objc static func iOS_boldFont20() -> UIFont {
        return UIFont.systemFont(ofSize: 20.0, weight: .semibold)
    }
    @objc static func iOS_boldFont19() -> UIFont {
        return UIFont.systemFont(ofSize: 19.0, weight: .semibold)
    }
    @objc static func iOS_boldFont18() -> UIFont {
        return UIFont.systemFont(ofSize: 18.0, weight: .semibold)
    }
    @objc static func iOS_boldFont17() -> UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    }
    @objc static func iOS_boldFont16() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: .semibold)
    }
    @objc static func iOS_boldFont14() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    }
    @objc static func iOS_boldFont13() -> UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: .semibold)
    }
    @objc static func iOS_boldFont12() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: .semibold)
    }
    @objc static func iOS_boldFont10() -> UIFont {
        return UIFont.systemFont(ofSize: 10.0, weight: .semibold)
    }
    @objc static func iOS_boldFont9() -> UIFont {
        return UIFont.systemFont(ofSize: 9.0, weight: .semibold)
    }

    ///  取得對應的 line height
    /// - Parameter font: 字型
    /// - Returns: line height
    @objc static func getLineHeight(for font: UIFont) -> CGFloat {
        var lineHeight = font.lineHeight
        if font.lineHeightMultiple > 0 {
            return font.pointSize * font.lineHeightMultiple
        }
        switch font.pointSize {
        case 26:
            lineHeight = 38
        case 34:
            lineHeight = 34
        case 22:
            lineHeight = 32
        case 20:
            lineHeight = 28
        case 19:
            lineHeight = 28
        case 18:
            lineHeight = 26
        case 17:
            lineHeight = 24
        case 16:
            lineHeight = 22
        case 14:
            lineHeight = 20
        case 13:
            lineHeight = 18
        case 12:
            lineHeight = 18
        case 10:
            lineHeight = 12
        case 9:
            lineHeight = 12
        default:
            break
        }
        return lineHeight
    }
}

