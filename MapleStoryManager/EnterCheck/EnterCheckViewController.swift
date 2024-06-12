//
//  EnterCheckViewController.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/2/1.
//

// 模擬情境
// 不需要 reload data 如果 Viewmodel 裡的 data 都有正確更新，那 cell 重新解包的時候，會直接拿資料包裡的資料
// 檢查角色名稱有沒有重複
// 檢查角色職業有沒有重複
// 檢查資訊都有輸入且沒有重複，確認送出按鍵就變色、可以點擊

import UIKit

class EnterCheckViewController: UIViewController {
    /// 輸入資訊的 tableView
    @IBOutlet weak var inputInfoTableView: UITableView!
    /// 確認送出按鍵
    @IBOutlet weak var confirmBtn: UIButton!
    /// 儲存角色輸入資料用
    private var viewModel = IDCardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputInfoTableView.delegate = self
        inputInfoTableView.dataSource = self
        configConfirmBtn()
    }
    
    @objc static func fromSB(charactersNum: Int) -> EnterCheckViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "EnterCheckViewController")
        let vc = controller as! EnterCheckViewController
        vc.viewModel.setup(charactersNum)
        return vc
    }
    
    // MARK: - 綁定
    
    /// 綁定確認按鈕
    private func configConfirmBtn() {
        
        let combinePublisher = viewModel.$characters.combineLatest(viewModel.$checkResults)
        
        /// textPublisher 算是介面輸入資訊，需要在主要線程上獲取才能拿到最新資訊
        combinePublisher.receive(on: DispatchQueue.main)
            .map { [weak self] characters, checkResult  in
                guard let self = self else { return false }
                return self.validateCharactersAndCheckResult(characters: characters, checkResult: checkResult)
            }
            .weakAssign(to: \.comfirmBtnEnable, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        /// 通過條件設定確認按鍵的屬性設定
        viewModel.$comfirmBtnEnable
            .map { return $0 ?? false }
            .weakSink(with: self, onNext: { vc, enable in
                vc.confirmBtn.isEnabled = enable
                vc.confirmBtn.backgroundColor = enable ? .green : .gray
            })
            .store(in: &viewModel.cancellables)
    }
    
    // 定义一个函数来处理 characters 和 checkResult
    func validateCharactersAndCheckResult(characters: [Character], checkResult: [CheckDuplicate]) -> Bool {
        // 检查角色数据是否有缺少输入
        let hasEmptyFields = characters.contains { $0.name.isEmpty || $0.profession.isEmpty }
        // 检查名称和职业是否有重复
        let hasDuplicates = checkResult.contains { $0.name || $0.profession }
        
        return !hasEmptyFields && !hasDuplicates
    }
}

// MARK: UITableViewDelegate
extension EnterCheckViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InputInfoTableViewCell.identifier, for: indexPath)
        guard let inputCell = cell as? InputInfoTableViewCell else { return cell }
        inputCell.selectionStyle = .none
        inputCell.cellIndex = indexPath.row
        inputCell.setupBindings(viewModel)
        return inputCell
    }
}
