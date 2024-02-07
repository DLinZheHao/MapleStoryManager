//
//  InputInfoTableViewCell.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/2/1.
//

import UIKit
import Combine

class InputInfoTableViewCell: UITableViewCell {
    /// 新增角色的編號
    @IBOutlet weak var characterNumLabel: UILabel!
    /// 角色名稱
    @IBOutlet weak var nameTextField: UITextField!
    /// 角色職業
    @IBOutlet weak var professionTextField: UITextField!
    /// 角色名稱重複通知
    @IBOutlet weak var nameNoticeLabel: UILabel!
    /// 角色職業重複通知
    @IBOutlet weak var professionNoticeLabel: UILabel!
    
    var viewModel: IDCardViewModel!
    // 新增一个属性用于存储当前单元格的索引
    var cellIndex: Int!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupBindings() {
           guard let cellIndex = cellIndex, viewModel != nil else { return }
           
           // 监听来自ViewModel的错误状态更新
           viewModel.errorsPublisher
               .receive(on: RunLoop.main)
               .sink { [weak self] errors in
                   // 确保cellIndex没有越界
                   guard errors.indices.contains(cellIndex) else { return }
                   let error = errors[cellIndex]
                   
                   // 更新名字和职业的错误提示UI
                   self?.nameNoticeLabel.isHidden = !error.name
                   self?.nameNoticeLabel.text = error.name ? "名字重复了！" : ""
                   
                   self?.professionNoticeLabel.isHidden = !error.profession
                   self?.professionNoticeLabel.text = error.profession ? "职业重复了！" : ""
               }
               .store(in: &cancellables)
       }
}
