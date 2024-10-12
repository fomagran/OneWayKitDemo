//
//  TimerAsyncAction.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import OneWaykit
import Combine
import Foundation

final class TimerAsyncAction: AsyncAction {
    
    func send(_ action: FeatureAction, currentState: FeatureState) -> AnyPublisher<FeatureAction, Never> {
        
        switch action as? TimerFeature.Action {
        case .addMessagePerSecond(let seconds):
            return Timer.publish(every: seconds, on: .main, in: RunLoop.Mode.common)
                 .autoconnect()
                 .map { _ in
                     TimerFeature.Action.add("New Message \(Date())")
                 }
                 .eraseToAnyPublisher()
        case .tapRightButton:
            guard let currentState = currentState as? TimerFeature.State else {
                return Empty().eraseToAnyPublisher()
            }
            
            if currentState.isCancelled {
                return Publishers.Merge(
                    Just(TimerFeature.Action.addMessagePerSecond(2)),
                    Just(TimerFeature.Action.setCancel(false))
                )
                .eraseToAnyPublisher()
            } else {
                return Publishers.Merge(
                    Just(TimerFeature.Action.cancel(for: TimerFeature.Action.addMessagePerSecond(2))),
                    Just(TimerFeature.Action.setCancel(true))
                )
                .eraseToAnyPublisher()
            }
            
        default:
            return Empty().eraseToAnyPublisher()
        }
    }
    
}
