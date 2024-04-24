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
            .sink { [weak self] characters, checkResult  in
                guard let self = self else { return }
                var pass = true
                /// 檢查角色資料是否有少輸入
                characters.forEach { character in
                    if character.name.isEmpty || character.profession.isEmpty {
                        pass = false
                    }
                }
                /// 檢查名稱與職業是否有重複
                checkResult.forEach { result in
                    if result.name || result.profession {
                        pass = false
                    }
                }
                self.viewModel.comfirmBtnEnable.send(pass)
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.comfirmBtnEnable
            .map { $0 }
            .weakSink(with: self, onNext: { vc, enable in
                vc.confirmBtn.isEnabled = enable
                vc.confirmBtn.backgroundColor = enable ? .green : .gray
            })
            .store(in: &viewModel.cancellables)
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

//    func addCharacter(name: String, profession: String) {
//        let newCharacter = Character(name: name, profession: profession)
//        if !self.characters.contains(newCharacter) {
//            self.characters.append(newCharacter)
//        } else {
//            // Handle the error, perhaps using the error publishers
//        }
//    }

//var nameEntered = CurrentValueSubject<String?, Never>("")
//   var professionEntered = CurrentValueSubject<String?, Never>("")
//
//   // 发布错误消息的 Subject
//   var nameErrorPublisher = PassthroughSubject<String, Never>()
//   var professionErrorPublisher = PassthroughSubject<String, Never>()
//
//   private var cancellables = Set<Any取消lable>()
//
//   init() {
//       // 绑定并检查输入的名字
//       nameEntered
//           .compactMap { $0 }
//           .removeDuplicates()
//           .sink { [weak self] name in
//               if let self = self, self.characters.contains(where: { $0.name == name }) {
//                   self.nameErrorPublisher.send("名字重复了！")
//               } else if let self = self {
//                   self.nameErrorPublisher.send("")
//               }
//           }
//           .store(in: &cancellables)
//
//       // 绑定并检查输入的职业
//       professionEntered
//           .compactMap { $0 }
//           .removeDuplicates()
//           .sink { [weak self] profession in
//               if let self = self, self.characters.contains(where: { $0.profession == profession }) {
//                   self.professionErrorPublisher.send("职业重复了！")
//               } else if let self = self {
//                   self.nameErrorPublisher.send("")
//               }
//           }
//           .store(in: &cancellables)
//   }
//
//   func addCharacter(name: String, profession: String) {
//       let newCharacter = Character(name: name, profession: profession)
//       if !self.characters.contains(newCharacter) {
//           self.characters.append(newCharacter)
//       } else {
//           // Handle the error, perhaps using the error publishers
//       }
//   }
//
//   // 这个方法可以在用户按下确认按钮时调用
//   func sendData() {
//       // 发送数据的逻辑...
//   }
//}
//            newCharacter.$name
//                .sink { [weak self] newName in
//                    print("New name: \(newName)")
//                    self?.checkForDuplicates()
//                }
//                .store(in: &cancellables)
//
//            newCharacter.$profession
//                .sink { [weak self] newProfession in
//                    print("New profession: \(newProfession)")
//                    self?.checkForDuplicates()
//                }
//                .store(in: &cancellables)
//
//    private func configReapetPersonId(of cellVMs: [TripPsgCellViewModel]) {
//        // 利用 reduce 去組合出此房所有身分證 Publisher 這樣 sink 閉包拿到的 ids 才會都是新值
//        let initialPublisher = Just<[(Int, String)]>([]).eraseToAnyPublisher()
//        let combinedPublisher = cellVMs
//            .enumerated()
//            .map { index, cellVM in
//                cellVM.userInput.$personId
//                    .map { personId in (index, personId) }
//                    .eraseToAnyPublisher()
//            }
//            .reduce(initialPublisher) { combined, publisher in
//                combined
//                    .combineLatest(publisher) { $0 + [$1] }
//                    .eraseToAnyPublisher()
//            }
//
//        combinedPublisher
//            .drive(with: self) { vm, indexedPersonIds in
//                vm.checkForDuplicatePersonIds(of: cellVMs, personIds: indexedPersonIds)
//            }
//            .store(in: &cancellables)
//    }
    
