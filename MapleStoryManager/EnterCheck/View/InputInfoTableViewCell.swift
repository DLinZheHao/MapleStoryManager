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
        
        let character = viewModel.characters[cellIndex]
        character.$name
            .compactMap { $0 }
            .assign(to: \.text, on: nameTextField)
            .store(in: &cancellables)
        character.$profession
            .compactMap { $0 }
            .assign(to: \.text, on: professionTextField)
            .store(in: &cancellables)

        viewModel.$checkResults
            .compactMap { result in
                result.map { $0 }
            }
            .sink { [weak self] checkDuplicate in
                guard let self = self else { return }
                self.nameNoticeLabel.isHidden = !checkDuplicate[cellIndex].name
                self.nameNoticeLabel.text = checkDuplicate[cellIndex].name ? "名稱重複了！" : ""
                self.professionNoticeLabel.isHidden = !checkDuplicate[cellIndex].profession
                self.professionNoticeLabel.text = checkDuplicate[cellIndex].profession ? "職業重複了！" : ""
                
            }
            .store(in: &cancellables)
        
        // 绑定名字输入框到ViewModel的对应CurrentValueSubject
        nameTextField.textPublisher
            .compactMap { $0 }
            //.print()
        // 使用cellIndex选择正确的CurrentValueSubject
            .assign(to: \.characters[cellIndex].name, on: viewModel)
            .store(in: &cancellables)
        
        // 绑定职业输入框到ViewModel的对应CurrentValueSubject
        professionTextField.textPublisher
            .compactMap { $0 }
        // 使用cellIndex选择正确的CurrentValueSubject
            .assign(to: \.characters[cellIndex].profession, on: viewModel)
            .store(in: &cancellables)
        
        // 监听来自ViewModel的错误状态更新
        viewModel.errorsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] errors in
                // 确保cellIndex没有越界
                guard errors.indices.contains(cellIndex) else { return }
                let error = errors[cellIndex]
                
                // 更新名字和职业的错误提示UI
                self?.nameNoticeLabel.isHidden = !error.name
                self?.nameNoticeLabel.text = error.name ? "名稱重複了！" : ""
                
                self?.professionNoticeLabel.isHidden = !error.profession
                self?.professionNoticeLabel.text = error.profession ? "職業重複了" : ""
            }
            .store(in: &cancellables)
    }
}
