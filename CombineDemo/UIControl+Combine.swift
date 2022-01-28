//
//  UIControl+Combine.swift
//  CombineDemo
//
//  Created by XIABIN on 2019/7/19.
//  Copyright © 2019 Koubei. All rights reserved.
//

import UIKit
import Combine

extension UIControl {
    
    /// Publisher for UIControlEvents
    public struct EventPublisher: Publisher {
        
        public typealias Output = UIControl
        public typealias Failure = Never
        
        let control: UIControl
        let events: UIControl.Event
        
        init(control: UIControl, events: UIControl.Event) {
            self.control = control
            self.events = events
        }

        public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIControl.EventPublisher.Failure, S.Input == UIControl.EventPublisher.Output {
            subscriber.receive(subscription: EventSubscription(subscriber: subscriber, control: control, events: events))
        }
    }
    
    class EventSubscription<SubscriberType: Subscriber> : Subscription where SubscriberType.Input == UIControl {
        
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
}

extension UIControl {
    public func publisher(for events: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, events: events)
    }
}

extension UIControl {
    public var touchUpInside: UIControl.EventPublisher {
        return self.publisher(for: .touchUpInside)
    }
}
