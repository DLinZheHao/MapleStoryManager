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
