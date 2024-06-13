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
        
        var bgViews = [UIView]()
        var tagLabels = [UILabel]()
        
        var widCount: CGFloat = 0
        var bgViewIndex = 0
        var tagIndex = 0
        
        for (index, tagStr) in tagStrs.enumerated() {
            
            let tagLabel = UILabelPadding()
            tagLabel.numberOfLines = 0
            tagLabel.font = UIFont.systemFont(ofSize: 17)
            tagLabel.textLineHeight(tagStr)
            tagLabel.layer.borderWidth = borderWidth
            tagLabel.layer.borderColor = UIColor.black.cgColor
            tagLabel.layer.cornerRadius = 2
            tagLabel.textAlignment = .left
            tagLabel.paddingLeft = 4
            tagLabel.paddingRight = 4
            tagLabel.paddingTop = 1
            tagLabel.paddingBottom = 1
            
            // 计算 label 在特定高度限制下的尺寸
            let maxSize = CGSize(width: maxWid, height: tagLabel.font.lineHeight)
            let requiredSize = tagLabel.sizeThatFits(maxSize)
            
            /// 初始化第一個容器
            if index == 0 {
                let bgView = UIView()
                bgStackView.addArrangedSubview(bgView)
                bgViews.append(bgView)
                
                if widCount + requiredSize.width + 12 + 2 + 8 >= maxWid {
                    tagLabel.backgroundColor = .white
                    bgViews[bgViewIndex].addSubview(tagLabel)
                    bgViews[bgViewIndex].translatesAutoresizingMaskIntoConstraints = false
                    let heightConstraint = bgViews[bgViewIndex].heightAnchor.constraint(equalToConstant: requiredSize.height)
                    heightConstraint.priority = UILayoutPriority(1000) // 設置優先級，範圍是 1 到 1000
                    heightConstraint.isActive = true
                    tagLabel.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        tagLabel.topAnchor.constraint(equalTo: bgViews[bgViewIndex].topAnchor),
                        tagLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bgViews[bgViewIndex].bottomAnchor),
                        tagLabel.leadingAnchor.constraint(equalTo: bgViews[bgViewIndex].leadingAnchor),
                        tagLabel.trailingAnchor.constraint(equalTo: bgViews[bgViewIndex].trailingAnchor)
                    ])
                    
                    bgViewIndex += 1
                    let bgView = UIView()
                    bgStackView.addArrangedSubview(bgView)
                    bgViews.append(bgView)
                }
                
            }
            // 2 -> 上下兼具 8 -> item 之間 spacing 12 -> 左右兼具  超過可用就要產一個新的 bgView (換行)
            else if widCount + requiredSize.width + 12 + 2 + 8 >= maxWid {
                tagLabels = []
                widCount = 0
                tagIndex = 0
                let bgView = UIView()
                bgStackView.addArrangedSubview(bgView)
                bgViews.append(bgView)
                bgViewIndex += 1
                bgViews[bgViewIndex].addSubview(tagLabel)
                
                bgView.translatesAutoresizingMaskIntoConstraints = false
                let heightConstraint = bgView.heightAnchor.constraint(equalToConstant: 20)
                heightConstraint.priority = UILayoutPriority(750) // 設置優先級，範圍是 1 到 1000
                heightConstraint.isActive = true
                tagLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    tagLabel.topAnchor.constraint(equalTo: bgView.topAnchor),
                    tagLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bgView.bottomAnchor),
                    tagLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
                    tagLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor)
                ])
            } else {
                tagLabel.backgroundColor = .white
                bgViews[bgViewIndex].addSubview(tagLabel)
                
                bgViews[bgViewIndex].translatesAutoresizingMaskIntoConstraints = false
                bgViews[bgViewIndex].heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
                
                tagLabel.translatesAutoresizingMaskIntoConstraints = false
                
                if tagLabels.isEmpty {
                    NSLayoutConstraint.activate([
                        tagLabel.topAnchor.constraint(equalTo: bgViews[bgViewIndex].topAnchor),
                        tagLabel.bottomAnchor.constraint(lessThanOrEqualTo: bgViews[bgViewIndex].bottomAnchor),
                        tagLabel.leadingAnchor.constraint(equalTo: bgViews[bgViewIndex].leadingAnchor)
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        tagLabel.topAnchor.constraint(equalTo: bgViews[bgViewIndex].topAnchor),
                        tagLabel.bottomAnchor.constraint(lessThanOrEqualTo: bgViews[bgViewIndex].bottomAnchor),
                        tagLabel.leadingAnchor.constraint(equalTo: tagLabels[tagIndex - 1].trailingAnchor, constant: 8)
                    ])
                }
                
                tagLabels.append(tagLabel)
                tagIndex += 1
                widCount += requiredSize.width + 12 + 2 + 8
                
            }
            
        }
        
    }
    
}


