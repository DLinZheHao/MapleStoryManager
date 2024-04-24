//
//  IDCardViewModel.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/4/23.
//

import UIKit
import Combine

class IDCardViewModel {
    /// 存储角色信息的数组
    @Published var characters: [Character] = []
    /// 儲存驗證錯誤狀態
    @Published var checkResults: [CheckDuplicate] = []
    /// 錯誤訊息
    var errorsPublisher = PassthroughSubject<[CheckDuplicate], Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    /// 名稱的發布（全部加總再一起）
    var namePublisers = Just<[String]>([]).eraseToAnyPublisher()
    /// 職業的發布（全部加總再一起）
    var professionPublishers = Just<[String]>([]).eraseToAnyPublisher()
    /// 檢查資料有無重複 true -> pass false -> not ok
    var duplicateCheck = PassthroughSubject<Bool, Never>()
    /// 按鍵是否可以啟用
    var comfirmBtnEnable = PassthroughSubject<Bool, Never>()
    
    /// 初始化整個紀錄模組
    func setup( _ charactersNum: Int) {
        // 假定有 n 個角色輸入
        characters = (0..<charactersNum).map { _ in Character() }
        // 初始化检查结果数组，假设初始时没有错误
        checkResults = Array(repeating: CheckDuplicate(name: false, profession: false), count: charactersNum)
        
        namePublisers = IDCardViewModel.createNamePublishers(characters)
        // 職業的發布（全部加總再一起）
        professionPublishers = IDCardViewModel.createProfessionPublisers(characters)
        
        // 名稱與職業組合發布
        let combinedPublisher = namePublisers.combineLatest(professionPublishers)
            .map { firstArray, secondArray in
                return firstArray.enumerated().map { (index, element1) in
                    (index, element1, secondArray[index])
                }
            }
            .eraseToAnyPublisher() // 转换为 AnyPublisher
        
        combinedPublisher
            .sink { [weak self] info in
                self?.checkForDuplicates(info)
            }
            .store(in: &cancellables)
    
    }

    private func checkForDuplicates(_ combinedInfo: [(Int, String, String)]) {
        // 提取名称和职业列表
        let namesWithIndex = combinedInfo.map { (index, name, _) in return (index, name) } // (Index, Name)
        let professionsWithIndex = combinedInfo.map { (index, _, profession) in return (index, profession) } // (Index, Profession)

        // 检查名称重复
        for (index, name) in namesWithIndex {
            let duplicateNamesCount = namesWithIndex.filter { $1 == name && !$1.isEmpty }.count
            if duplicateNamesCount > 1 {
                checkResults[index].name = true
            } else {
                checkResults[index].name = false
            }
        }

        // 检查职业重复
        for (index, profession) in professionsWithIndex {
            let duplicateProfessionsCount = professionsWithIndex.filter { $1 == profession && !$1.isEmpty }.count
            if duplicateProfessionsCount > 1 {
                checkResults[index].profession = true
            } else {
                checkResults[index].profession = false
            }
        }
        
        // 发送更新的错误状态
        errorsPublisher.send(checkResults)
    }
    /// 名稱發布員創建
    static func createNamePublishers(_ characters: [Character]) -> AnyPublisher<[String], Never> {
        let initialPublisher = Just<[String]>([]).eraseToAnyPublisher()
        let combinedPublisher = characters.map { character in
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
    /// 職業發布員創建
    static func createProfessionPublisers(_ characters: [Character]) -> AnyPublisher<[String], Never> {
        let initialPublisher = Just<[String]>([]).eraseToAnyPublisher()
        let combinedPublisher = characters.map { character in
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
    /// 名稱重複檢查值
    var name: Bool
    /// 職業重複檢查值
    var profession: Bool
}
