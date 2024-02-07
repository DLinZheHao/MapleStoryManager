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
    var errorsPublisher = PassthroughSubject<[CheckDuplicate], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 监听每个Character的变化
        for _ in 0..<3 { // 假定有3个角色输入
            let newCharacter = Character()
            characters.append(newCharacter)
            
            newCharacter.$name
                //.dropFirst()
                .sink { [weak self] _ in
                    self?.checkForDuplicates()
                }
                .store(in: &cancellables)
            
            newCharacter.$profession
                //.dropFirst()
                .sink { [weak self] _ in
                    self?.checkForDuplicates()
                }
                .store(in: &cancellables)
        }
    }
    
    private func checkForDuplicates() {
        let names = characters.map { $0.name }
        let professions = characters.map { $0.profession }
        
        // 计算重复
        let nameErrors = names.map { name in names.filter { $0 == name }.count > 1 }
        let professionErrors = professions.map { profession in professions.filter { $0 == profession }.count > 1 }
        
        // 将错误状态发送给所有监听者
        var states = [CheckDuplicate]()
        for i in 0..<nameErrors.count {
            let state = CheckDuplicate(name: nameErrors[i], profession: professionErrors[i])
            states.append(state)
        }
        errorsPublisher.send(states)
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

struct CheckDuplicate {
    var name: Bool
    var profession: Bool
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
