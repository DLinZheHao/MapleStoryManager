//
//  CustomPublishers.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/2/17.
//

/// 客製化 publisher 去解決各種不同的情況

import UIKit
import Combine

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

/// A custom `Publisher` for `UIControl` to work with our custom `UIControlSubscription`.
struct UIControlPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }

    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

/// A custom subscription to capture UIControl target events.
final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control
    private let controlEvents: UIControl.Event

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.controlEvents = event
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

// Extend UIControl to provide a Combine compatible publisher.
protocol CombineCompatible { }

extension UIButton {
    // 擴展 UIButton 以支持 UIControl.Event 的 Combine 發布者
    func buttonPublisher(for events: UIControl.Event) -> UIControlPublisher<UIButton> {
        return UIControlPublisher(control: self, events: events)
    }
}


extension UITextField {
    // 擴展 UITextField 以支持 UIControl.Event 的 Combine 發布者
    func textFieldPublisher(for events: UIControl.Event) -> UIControlPublisher<UITextField> {
        return UIControlPublisher(control: self, events: events)
    }
    
    // 擴展 UITextField 以添加對 textFieldShouldClear 的支持
    // Publisher for textFieldShouldClear event
    func textFieldShouldClearPublisher() -> AnyPublisher<UITextField, Never> {
        let publisher = PassthroughSubject<UITextField, Never>()
                
        // Implement the textFieldShouldClear delegate method
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            publisher.send(textField)
            return true // or false, depending on your logic
        }
        return publisher.eraseToAnyPublisher()
    }
}

extension UISegmentedControl {
    func segmentedPublisher(for events: UIControl.Event) -> UIControlPublisher<UISegmentedControl> {
        return UIControlPublisher(control: self, events: events)
    }
}

// 讓 assign 是 weak self，避免咬住
extension Publisher where Failure == Never {
    
    /// 與 .assign(to: on:) 同功能（只差在一個是弱引用，一個是強引用）
    func weakAssign<T: AnyObject>(
            to keyPath: ReferenceWritableKeyPath<T, Output>,
            on object: T?
        ) -> AnyCancellable {
            sink { [weak object] value in
                // 只有當 object 不為 nil 時才賦予值
                object?[keyPath: keyPath] = value
            }
        }
}

extension Publisher where Failure: Error {
    
    /// = .sink(receiveValue: )
    func weakSink<T: AnyObject>(with context: T, onNext: @escaping (T, Output) -> Void) -> AnyCancellable {
        return self
            .catch { _ in Empty<Output, Never>() }
            .sink { [weak context] output in
                guard let context = context else { return }
                onNext(context, output)
            }
    }
    
    /// 過濾訊號 = drop(while:)
    func dropWeakSink<T: AnyObject>(with context: T, shouldDrop: @escaping (T, Output) -> Bool) -> AnyPublisher<Output, Failure> {
        return self
            .drop(while: { [weak context] output in
                guard let context = context else { return false }
                return shouldDrop(context, output)
            })
            .flatMap { Just($0).setFailureType(to: Failure.self) }
            .eraseToAnyPublisher()
    }
}

// MARK: - Combine String 擴充
extension Publisher where Output == String {
    /// 過濾非數字
    func decimalDigits() -> Publishers.Map<Self, String> {
        return self.map { $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
    }
    
    /// 過濾空白
    func trimWhitespaces() -> Publishers.Map<Self, String> {
        return self.map { $0.components(separatedBy: .whitespaces).joined() }
    }
    
    /// 限制字數長度
    /// - Parameter word: 字數
    func prefix(_ word: Int) -> Publishers.Map<Self, String> {
        return self.map { String($0.prefix(word)) }
    }
    
}
