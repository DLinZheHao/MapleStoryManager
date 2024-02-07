//
//  ViewController.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/1/26.
//

// 這裡嘗試模擬新增資料進入資料庫中，再從資料庫中取出資料
// 1.取出資料後，更新畫面
// 2.新增新的資料進入資料庫，畫面的資料也需要更新
// 3.gameService 的 publisher 再通知 tableView 資料已經更新

import UIKit
import Combine

class BattleFieldViewController: UIViewController {

    @IBOutlet weak var infoTableView: UITableView! {
        didSet {
            infoTableView.dataSource = self
            infoTableView.delegate = self
        }
    }
    /// 戰地資料
    private var battlefieldInfos = [BattlefieldInfo]()
    /// 用於儲存所有訂閱的對象
    private var cancellables: Set<AnyCancellable> = []
    /// 讀取 coreData 的元件
    private var gameService = GameInfoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTableView.tableHeaderView = createHeaderView()
        setupUpdateSubscription()
        fetchBattlefieldInfo()
    }
    
    @objc static func fromSB() -> BattleFieldViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "BattleFieldViewController")
        let vc = controller as! BattleFieldViewController
        return vc
    }
    
    private func fetchBattlefieldInfo() {
        gameService.fetchBattlefieldInfo()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // 處理錯誤或成功
            }, receiveValue: { [weak self] infos in
                guard let self = self else { return }
                self.battlefieldInfos = infos
                self.infoTableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    private func setupUpdateSubscription() {
        gameService.updates
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchBattlefieldInfo()
            }
            .store(in: &cancellables)
    }
    
    private func generateFakeData() {
        gameService.saveBattlefieldInfo(profession: "劍豪", function: "爆擊傷害", level: "257")
    }
     
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: infoTableView.frame.width, height: 50))
        headerView.backgroundColor = .white
        
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        headerView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            addButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])
        
        
        return headerView
    }
    @objc private func addBtnTapped(sender: UIButton) {
        generateFakeData()
    }
}

extension BattleFieldViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return battlefieldInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BattlefieldInfoTableViewCell.identifier, for: indexPath)
        guard let infoCell = cell as? BattlefieldInfoTableViewCell else { return cell }
        infoCell.setupInfo(profession: battlefieldInfos[indexPath.row].profession ?? "",
                           function: battlefieldInfos[indexPath.row].function ?? "",
                           level: battlefieldInfos[indexPath.row].level ?? "")
        return infoCell
    }
    
    
}

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }

}

extension Publisher where Output == String, Failure == Never {
    /// 純回傳 field, value
    func inputPublisher<Field>(for field: Field, errorHandler: @escaping (String, Field) -> AnyPublisher<String, Never>) -> InputPublisher<Self, Field> {
        return InputPublisher(self, field: field, errorHandler: errorHandler)
    }
    
    /// 讓外部可以給 self, 回傳 self, field, value
    func inputPublisher<Context: AnyObject, Field>(with context: Context, for field: Field, errorHandler: @escaping (Context, String, Field) -> AnyPublisher<String, Never>) -> InputPublisher<Self, Field> {
        return InputPublisher(self, field: field, errorHandler: { [weak context] value, field in
            guard let context = context else { return Empty().eraseToAnyPublisher() }
            return errorHandler(context, value, field)
        })
    }
}

struct InputPublisher<Upstream: Publisher, Field>: Publisher where Upstream.Output == String, Upstream.Failure == Never {
    typealias Output = String
    typealias Failure = Never

    private let upstream: Upstream
    private let field: Field
    private let errorHandler: (String, Field) -> AnyPublisher<String, Never>

    init(_ upstream: Upstream, field: Field, errorHandler: @escaping (String, Field) -> AnyPublisher<String, Never>) {
        self.upstream = upstream
        self.field = field
        self.errorHandler = errorHandler
    }

    func receive<S: Subscriber>(subscriber: S) where S.Input == String, S.Failure == Never {
        upstream
            .flatMap { [field, errorHandler] value in
                errorHandler(value, field)
            }
            .subscribe(subscriber)
    }
}




//extension Publisher where Output == String, Failure == Never {
//    func customPublisher<Field>(field: Field) -> CustomPublisher<Self, Field>{
//        let publisher = CustomPublisher(self, field: field)
//        return publisher
//    }
//}

//struct CustomPublisher<Upstream: Publisher, Field>: Publisher where Upstream.Output == String, Upstream.Failure == Never  {
//    typealias Output = String
//    typealias Failure = Never
//
//    private let upstream: Upstream
//    private let field: Field
//
//    init(_ upstream: Upstream, field: Field) {
//        self.upstream = upstream
//        self.field = field
//    }
//    func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
//        upstream
//            .flatMap { [field] value in
//                if
//            }
//            .subscribe(subscriber)
//    }
//
//    // 設定哪種使用者可以接收內容
////    func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
////        let subscription = CountdownSubscription(subscriber: subscriber, field: Field.self)
////        subscriber.receive(subscription: subscription)
////    }
//
////    private final class CountdownSubscription<S: Subscriber, Field>: Subscription where S.Input == Output, S.Failure == Failure {
////        private var subscriber: S?
////        private var field: Field?
////
////        init(subscriber: S, field: Field) {
////            self.subscriber = subscriber
////            self.field = field
////        }
////
////        func request(_ demand: Subscribers.Demand) {
////            // 沒有特別處理
////        }
////
////        func cancel() {
////            subscriber = nil
////            field = nil
////        }
////
////        private func doSomething() {
////            _ = subscriber?.receive("123")
////        }
////    }
//}

//@Published var text: String? = "qwe"
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    /// 單純將值給呈現
//    inputTextField.textPublisher
//        .map { $0 }
//        .receive(on: RunLoop.main) // 確保處理發生在主線程
//        .assign(to: \.text, on: outputLabel)
//        .store(in: &cancellables)
//
//    /// 處理過的值呈現
//    inputTextField.textPublisher
//        .filter { $0.contains("100")}
//        .debounce(for: .seconds(1), scheduler: RunLoop.main)
//        .map { $0.uppercased() }
//        .assign(to: \.text, on: processOutputLabel)
//        .store(in: &cancellables)
//
//    Publishers
//        .CombineLatest(inputTextField.textPublisher,
//                       input2TextField.textPublisher)
//        .map { input1, input2 in
//            return input1.count > 5 && input1.contains("ors") &&
//                   input2.count > 5 && input2.contains("ors")
//        }
//        .map { $0 ? "成功":"失敗" }
//        .assign(to: \.text, on: checkResultLabel)
//        .store(in: &cancellables)
//
//}
//
//@IBAction func didInputChar(_ sender: UITextField) {
//    text = sender.text
//}
