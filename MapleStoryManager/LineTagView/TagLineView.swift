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
    
    override func draw(_ rect: CGRect) {}
    
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
        
        // 儲存使用的 section (View) item (Label)
        var bgViews = [UIView]()
        var tagLabels = [UILabel]()
        
        // 管理儲存的 section (View) item (Label) 怎麼使用
        var widCount: CGFloat = 0
        var bgViewIndex = 0
        var tagIndex = 0
        var isNewSectionCreate = false
        // 預設建設第一個 section
        addSection(&bgViews)
        
        for (index, tagStr) in tagStrs.enumerated() {
            
            let tagLabel = paddingLabelSet(tagStr, borderWidth)
            
            // 计算 label 在特定高度限制下的尺寸
            let maxSize = CGSize(width: maxWid, height: tagLabel.font.lineHeight)
            let requiredSize = tagLabel.sizeThatFits(maxSize)
            
            // 2 -> 上下兼具 8 -> item 之間 spacing 12 -> 左右兼具，超過可用就要產一個新的 bgView (換行)
            if widCount + requiredSize.width + 12 + 2 + 8 >= maxWid {
                // 換行就要清空
                tagLabels = []
                widCount = 0
                tagIndex = 0
                    
                if index != 0 {
                    addSection(&bgViews)
                    bgViewIndex += 1
                }
                
                bgViews[bgViewIndex].addSubview(tagLabel)
                setAllConstraint(tagLabel, bgViews[bgViewIndex], requiredSize.height)
                isNewSectionCreate = true
            } else {
                if isNewSectionCreate {
                    bgViewIndex += 1
                    addSection(&bgViews)
                    isNewSectionCreate = false
                }
                bgViews[bgViewIndex].addSubview(tagLabel)
                setViewHConstraint(bgViews[bgViewIndex], requiredSize.height)

                tagLabel.translatesAutoresizingMaskIntoConstraints = false
                
                if tagLabels.isEmpty {
                    setTagConstraint(tagLabel, bgViews[bgViewIndex], isTag: false)
                } else {
                    setTagConstraint(tagLabel, bgViews[bgViewIndex], tagLabels[tagIndex - 1], isTag: true)
                }
                
                tagLabels.append(tagLabel)
                tagIndex += 1
                widCount += requiredSize.width + 12 + 2 + 8
                
            }
            
        }
        
    }
    
    private func addSection(_ bgViews: inout [UIView]) {
        let bgView = UIView()
        bgStackView.addArrangedSubview(bgView)
        bgViews.append(bgView)
    }

    /// 設置 tag label 屬性
    private func paddingLabelSet(_ str: String, _ borderWid: CGFloat) -> UILabelPadding {
        let tagLabel = UILabelPadding()
        tagLabel.numberOfLines = 0
        tagLabel.font = UIFont.systemFont(ofSize: 17)
        tagLabel.textLineHeight(str)
        tagLabel.layer.borderWidth = borderWid
        tagLabel.layer.borderColor = UIColor.black.cgColor
        tagLabel.layer.cornerRadius = 2
        tagLabel.textAlignment = .left
        tagLabel.paddingLeft = 4
        tagLabel.paddingRight = 4
        tagLabel.paddingTop = 1
        tagLabel.paddingBottom = 1
        
        return tagLabel
    }
    
    private func setViewHConstraint(_ view: UIView, _ height: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.priority = UILayoutPriority(1000)
        heightConstraint.isActive = true
    }
    
    private func setAllConstraint(_ label: UILabel, _ view: UIView, _ height: CGFloat) {
        setViewHConstraint(view, height)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setTagConstraint(_ label: UILabel, _ view: UIView, _ label2: UILabel? = nil, isTag: Bool) {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if isTag, let label2 = label2 {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor),
                label.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
                label.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 8)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor),
                label.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            ])
        }
    }
}


