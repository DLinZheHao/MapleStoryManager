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
    // 新增一个属性用于存储当前单元格的索引
    var cellIndex: Int!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterNumLabel.text = ""
        nameTextField.text = ""
        professionTextField.text = ""
        nameNoticeLabel.text = ""
        professionNoticeLabel.text = ""
        nameNoticeLabel.isHidden = true
        professionNoticeLabel.isHidden = true
        cancellables.removeAll()
    }
    
    func setupBindings(_ viewModel: IDCardViewModel) {
        guard let cellIndex = cellIndex else { return }
        characterNumLabel.text = "角色\(cellIndex + 1)"
        
        // 绑定名字输入框到ViewModel的对应CurrentValueSubject
        nameTextField.textPublisher
            .compactMap { $0 }
            // 使用cellIndex选择正确的CurrentValueSubject
            .assign(to: \.characters[cellIndex].name, on: viewModel)
            .store(in: &cancellables)
        
        // 绑定职业输入框到ViewModel的对应CurrentValueSubject
        professionTextField.textPublisher
            .compactMap { $0 }
            // 使用cellIndex选择正确的CurrentValueSubject
            .assign(to: \.characters[cellIndex].profession, on: viewModel)
            .store(in: &cancellables)
        
        // 從 DataModel 中取出
        let character = viewModel.characters[cellIndex]
        character.$name
            .compactMap { $0 }
            .assign(to: \.text, on: nameTextField)
            .store(in: &cancellables)
        
        character.$profession
            .compactMap { $0 }
            .assign(to: \.text, on: professionTextField)
            .store(in: &cancellables)

        // 更新名稱错误提示UI
        viewModel.$checkResults
            .compactMap { result in
                result.map { $0 }
            }
            .sink { [weak self] errors in
                // 确保cellIndex没有越界
                guard errors.indices.contains(cellIndex) else { return }
                let error = errors[cellIndex]
                self?.nameNoticeLabel.isHidden = !error.name
                self?.nameNoticeLabel.text = error.name ? "名稱重複了！" : ""
            }
            .store(in: &cancellables)
        
        // 更新职业错误提示UI
        viewModel.$checkResults
            .compactMap { result in
                result.map { $0 }
            }
            .sink { [weak self] errors in
                // 确保cellIndex没有越界
                guard errors.indices.contains(cellIndex) else { return }
                let error = errors[cellIndex]
                self?.professionNoticeLabel.isHidden = !error.profession
                self?.professionNoticeLabel.text = error.profession ? "職業重複了" : ""
            }
            .store(in: &cancellables)
    }
}
