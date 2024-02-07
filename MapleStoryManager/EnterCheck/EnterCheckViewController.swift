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

import UIKit
import Combine

class EnterCheckViewController: UIViewController {

    @IBOutlet weak var inputInfoTableView: UITableView!
    
    /// 儲存角色輸入資料用
    private var viewModel = IDCardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.characters = [Character(name: "哲豪", profession: "工程師"),
                                Character(name: "歐爾斯", profession: "劍豪")]
        
        inputInfoTableView.delegate = self
        inputInfoTableView.dataSource = self
    }
    
    @objc static func fromSB() -> EnterCheckViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "EnterCheckViewController")
        let vc = controller as! EnterCheckViewController
        return vc
    }

}

extension EnterCheckViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InputInfoTableViewCell.identifier, for: indexPath)
        guard let inputCell = cell as? InputInfoTableViewCell else { return cell }
        inputCell.viewModel = viewModel
        inputCell.cellIndex = indexPath.row
        inputCell.setupBindings()
        return inputCell
    }
}

class IDCardViewModel {
    // 存储角色信息的数组
    var characters: [Character] = []
    
    // 存储输入数据的Subjects
    var nameEntereds = [
        CurrentValueSubject<String?, Never>(""),
        CurrentValueSubject<String?, Never>(""),
        CurrentValueSubject<String?, Never>("")
    ]
    var professionEntereds = [
        CurrentValueSubject<String?, Never>(""),
        CurrentValueSubject<String?, Never>(""),
        CurrentValueSubject<String?, Never>("")
    ]
    
    var nameErrorPublishers = [
        PassthroughSubject<String, Never>(),
        PassthroughSubject<String, Never>(),
        PassthroughSubject<String, Never>()
    ]
    
    var professionErrorPublishers = [
        PassthroughSubject<String, Never>(),
        PassthroughSubject<String, Never>(),
        PassthroughSubject<String, Never>()
    ]
    
    // 存储输入数据的Subject
    var nameEntered = CurrentValueSubject<String?, Never>("")
    var professionEntered = CurrentValueSubject<String?, Never>("")
    
    // 发布错误消息的 Subject
    var nameErrorPublisher = PassthroughSubject<String, Never>()
    var professionErrorPublisher = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let count = 3 // 假设我们有三组输入
        // 绑定并检查输入的名字和职业
        for index in 0..<count {
            bindInput(index: index)
        }
    }
    
    private func checkForDuplicates() {
        let names = nameEntereds.map { $0.value ?? "" }
        let professions = professionEntereds.map { $0.value ?? "" }
        
        // 检查名字重复
        for (index, name) in names.enumerated() {
            let duplicateIndexes = names.enumerated().filter { $0.element == name && !$0.element.isEmpty && $0.offset != index }.map { $0.offset }
            if !duplicateIndexes.isEmpty || characters.contains(where: { $0.name == name }) {
                nameErrorPublishers[index].send("名字重复了！")
            } else {
                nameErrorPublishers[index].send("")
            }
        }
        
        // 检查职业重复
        for (index, profession) in professions.enumerated() {
            let duplicateIndexes = professions.enumerated().filter { $0.element == profession && !$0.element.isEmpty && $0.offset != index }.map { $0.offset }
            if !duplicateIndexes.isEmpty || characters.contains(where: { $0.profession == profession }) {
                professionErrorPublishers[index].send("职业重复了！")
            } else {
                professionErrorPublishers[index].send("")
            }
        }
    }

    private func bindInput(index: Int) {
        nameEntereds[index]
            .compactMap { $0 }
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.checkForDuplicates()
            }
            .store(in: &cancellables)
            
        professionEntereds[index]
            .compactMap { $0 }
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.checkForDuplicates()
            }
            .store(in: &cancellables)
    }


    
//    func addCharacter(name: String, profession: String) {
//        let newCharacter = Character(name: name, profession: profession)
//        if !self.characters.contains(newCharacter) {
//            self.characters.append(newCharacter)
//        } else {
//            // Handle the error, perhaps using the error publishers
//        }
//    }
    
    // 这个方法可以在用户按下确认按钮时调用
    func sendData() {
        // 发送数据的逻辑...
    }
}

// 你的角色模型，需要遵守Equatable来比较
class Character: ObservableObject {
    @Published var name: String
    @Published var profession: String
    
    init(name: String = "", profession: String = "") {
        self.name = name
        self.profession = profession
    }
}

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
