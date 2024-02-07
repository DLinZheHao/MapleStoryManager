//
//  GameService.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/1/30.
//

import Foundation
import CoreData
import Combine

class GameInfoService {
    
    var updates = PassthroughSubject<Void, Never>()
    
    private let container: NSPersistentContainer
    private let containerName = "GameInfo"
    private let entityName: String = "BattleFieldInfo"
    
    init() {
        // 用來找 coredate 檔案放在哪裡用的
        // print(NSPersistentContainer.defaultDirectoryURL())
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if error != nil {
                fatalError("在讀取資料庫資料時發生了問題")
            }
        }
    }
    
    func fetchBattlefieldInfo() -> AnyPublisher<[BattlefieldInfo], Error> {
        let fectchRuest: NSFetchRequest<BattlefieldInfo> = BattlefieldInfo.fetchRequest()
        
        return Future<[BattlefieldInfo], Error> { promise in
            self.container.viewContext.perform {
                do {
                    let battlefieldInfos = try self.container.viewContext.fetch(fectchRuest)
                    promise(.success(battlefieldInfos))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveBattlefieldInfo(profession: String, function: String, level: String) {
        let context = container.viewContext
        let battlefieldInfo = BattlefieldInfo(context: context)
        
        battlefieldInfo.profession = profession
        battlefieldInfo.function = function
        battlefieldInfo.level = level
        
        do {
            try context.save()
            updates.send()
        } catch {
            print("儲存失敗")
            context.rollback()
        }
        
    }
}
