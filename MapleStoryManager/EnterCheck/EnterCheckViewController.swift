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
        
//        viewModel.characters = [Character(name: "哲豪", profession: "工程師"),
//                                Character(name: "歐爾斯", profession: "劍豪")]
        
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
        characters = (0..<3).map { _ in Character() } // 假定有3個角色輸入
        
        let namePublisers = createNamePublishers(characters)
        let professionPublishers = createProfessionPublisers(characters)
        
        let combinedPublisher = namePublisers.combineLatest(professionPublishers)
            .map { firstArray, secondArray in
                let combinedArray = firstArray.enumerated().map { (index, element1) in
                    (index, element1, secondArray[index])
                }
                
                return combinedArray.map { index, names, professions in (index, names, professions)}
            }
            .eraseToAnyPublisher() // 转换为 AnyPublisher
        
        combinedPublisher
            .sink { [weak self] info in
                self?.checkForDuplicates(info)
            }
            .store(in: &cancellables)

    }

    private func checkForDuplicates(_ combinedInfo: [(Int, String, String)]) {
        // 初始化检查结果数组，假设初始时没有错误
        var checkResults = Array(repeating: CheckDuplicate(name: false, profession: false), count: combinedInfo.count)

        // 提取名称和职业列表
        let namesWithIndex = combinedInfo.map { (index, name, _) in return (index, name) } // (Index, Name)
        let professionsWithIndex = combinedInfo.map { (index, _, profession) in return (index, profession) } // (Index, Profession)

        // 检查名称重复
        for (index, name) in namesWithIndex {
            let duplicateNamesCount = namesWithIndex.filter { $1 == name && !$1.isEmpty }.count
            if duplicateNamesCount > 1 {
                checkResults[index].name = true
            }
        }

        // 检查职业重复
        for (index, profession) in professionsWithIndex {
            let duplicateProfessionsCount = professionsWithIndex.filter { $1 == profession && !$1.isEmpty }.count
            if duplicateProfessionsCount > 1 {
                checkResults[index].profession = true
            }
        }

        // 发送更新的错误状态
        errorsPublisher.send(checkResults)
    }
    
    private func createNamePublishers(_ characters: [Character]) -> AnyPublisher<[String], Never> {
        let initialPublisher = Just<[String]>([]).eraseToAnyPublisher()
        let combinedPublisher = characters.enumerated().map { index, character in
            character.$name
                .map{ $0 }
                .eraseToAnyPublisher()
        }.reduce(initialPublisher) { combined, publisher in
            combined
                .combineLatest(publisher) { $0 + [$1] }
                .eraseToAnyPublisher()
        }
        return combinedPublisher
    }
    
    private func createProfessionPublisers(_ characters: [Character]) -> AnyPublisher<[String], Never> {
        let initialPublisher = Just<[String]>([]).eraseToAnyPublisher()
        let combinedPublisher = characters.enumerated().map { index, character in
            character.$profession
                .map{ $0 }
                .eraseToAnyPublisher()
        }.reduce(initialPublisher) { combined, publisher in
            combined
                .combineLatest(publisher) { $0 + [$1] }
                .eraseToAnyPublisher()
        }
        return combinedPublisher
    }
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
    
