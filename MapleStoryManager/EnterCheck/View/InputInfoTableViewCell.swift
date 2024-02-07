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
        guard let cellIndex = cellIndex else { return }
        
        // 绑定名字输入框到ViewModel的对应CurrentValueSubject
        nameTextField.textPublisher
            .compactMap { $0 }
        // 使用cellIndex选择正确的CurrentValueSubject
            .assign(to: \.nameEntereds[cellIndex].value, on: viewModel)
            .store(in: &cancellables)
        
        // 绑定职业输入框到ViewModel的对应CurrentValueSubject
        professionTextField.textPublisher
            .compactMap { $0 }
        // 使用cellIndex选择正确的CurrentValueSubject
            .assign(to: \.professionEntereds[cellIndex].value, on: viewModel)
            .store(in: &cancellables)
        
        // 监听名字错误并更新UI
        viewModel?.nameErrorPublishers[cellIndex]
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] errorMessage in
                self?.nameNoticeLabel.isHidden = errorMessage.isEmpty
                self?.nameNoticeLabel.text = errorMessage
            })
            .store(in: &cancellables)
        
        // 监听职业错误并更新UI
        viewModel?.professionErrorPublishers[cellIndex]
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] errorMessage in
                self?.professionNoticeLabel.isHidden = errorMessage.isEmpty
                self?.professionNoticeLabel.text = errorMessage
            })
            .store(in: &cancellables)
    }
}
