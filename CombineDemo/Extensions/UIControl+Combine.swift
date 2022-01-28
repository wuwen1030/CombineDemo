//
//  UIControl+Combine.swift
//  CombineDemo
//
//  Created by XIABIN on 2019/7/19.
//  Copyright © 2019 Koubei. All rights reserved.
//

import UIKit
import Combine

/// Publisher for UIControlEvents
public struct UIControlEventPublisher: Publisher {
    
    public typealias Output = UIControl
    public typealias Failure = Never
    
    let control: UIControl
    let events: UIControl.Event
    
    init(control: UIControl, events: UIControl.Event) {
        self.control = control
        self.events = events
    }

    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIControlEventPublisher.Failure, S.Input == UIControlEventPublisher.Output {
        subscriber.receive(subscription: UIControlEventSubscription(subscriber: subscriber, control: control, events: events))
    }
}

class UIControlEventSubscription<SubscriberType: Subscriber> : Subscription where SubscriberType.Input == UIControl {
    
    private var subscriber: SubscriberType?
    let control: UIControl
    
    init(subscriber: SubscriberType, control: UIControl, events: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: events)
    }
    
    func request(_ demand: Subscribers.Demand) {
        // do nothing
    }
    
    func cancel() {
        self.subscriber = nil
    }
    
    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
    
}


extension UIControl: UIKitCombineExtended {}

extension UIKitCombineExtension where ExtendedType == UIControl {
    public func publisher(for events: ExtendedType.Event) -> UIControlEventPublisher {
        return UIControlEventPublisher(control: self.type, events: events)
    }
    
    public var touchupInside: UIControlEventPublisher {
        return self.publisher(for: .touchUpInside)
    }
}
