//
//  TagLineView.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/6/12.
//

import UIKit

enum TagLineViewsIndex: Int {
    /// 主容器
    case container = 0
    /// tag
    case tag
}

class TagLineView: UIView {
    /// 裝 tags 的容器
    @IBOutlet weak var bgStackView: UIStackView!
    /// 行之間的距離
    let lineSpace: CGFloat = 1
    /// tag 之間得距離
    let itemSpace: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadInterface()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
         loadInterface()
    }
    
    override func draw(_ rect: CGRect) {
//        layer.cornerRadius = 6
//        clipsToBounds = true
//        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 載入xib
    private func loadInterface() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TagLineView", bundle: bundle)
        let index = TagLineViewsIndex.container.rawValue
        // nib來取得xibView
        let xibView = nib.instantiate(withOwner: self, options: nil)[index] as! UIView
        addSubview(xibView)
        // 設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            xibView.topAnchor.constraint(equalTo: self.topAnchor),
            xibView.leftAnchor.constraint(equalTo: self.leftAnchor),
            xibView.rightAnchor.constraint(equalTo: self.rightAnchor),
            xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /// 創建物件使用
    class func fromXib(maxWidth: CGFloat, tagStrs: [String]) -> TagLineView {
        let nib = UINib(nibName: "TagLineView", bundle: nil)
        let index = TagLineViewsIndex.container.rawValue
        let view = nib.instantiate(withOwner: nil, options: nil)[index] as! TagLineView
        return view
    }
    
    
    func setup(maxWid: CGFloat, _ borderWidth: CGFloat = 1, tagStrs: [String]) {
        
        var stackViews = [UIStackView]()
        var widCount: CGFloat = 0
        var bgStackViewIndex = 0
        
        for (index, tagStr) in tagStrs.enumerated() {
            /// 初始化第一個容器 || 超過可用就要產一個新的 bgView (換行)
            if index == 0 {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .fill
                stackView.distribution = .fill
                stackView.spacing = 8
                bgStackView.addArrangedSubview(stackView)
                stackViews.append(stackView)
            }
            
            
            let tagLabel = UILabel()
            tagLabel.font = UIFont.systemFont(ofSize: 17)
            tagLabel.textLineHeight(tagStr)
            tagLabel.layer.borderWidth = borderWidth
            tagLabel.layer.borderColor = UIColor.black.cgColor
            tagLabel.textAlignment = .center
            
            // 计算 label 在特定高度限制下的尺寸
            let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: tagLabel.font.lineHeight)
            let requiredSize = tagLabel.sizeThatFits(maxSize)
            
            tagLabel.translatesAutoresizingMaskIntoConstraints = false
            tagLabel.widthAnchor.constraint(equalToConstant: requiredSize.width + 12).isActive = true
            
            
            if widCount + requiredSize.width + 12 + 2 + 8 >= maxWid {
                widCount = 0
                let stackView = UIStackView()
                stackView.axis = .vertical
                stackView.alignment = .fill
                stackView.distribution = .fill
                stackView.spacing = 8
                bgStackView.addArrangedSubview(stackView)
                stackViews.append(stackView)
                bgStackViewIndex += 1
                stackViews[bgStackViewIndex].addArrangedSubview(tagLabel)
            } else {
                widCount += requiredSize.width + 12 + 2 + 8
                stackViews[bgStackViewIndex].addArrangedSubview(tagLabel)
            }
            
        }
        
    }
    
}


