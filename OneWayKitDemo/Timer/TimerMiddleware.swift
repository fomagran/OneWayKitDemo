//
//  TimerAsyncAction.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import OneWaykit
import Combine
import Foundation

final class TimerMiddleware: Middleware {
    
    func send(_ action: ViewAction, currentState: any ViewState) -> AnyPublisher<ViewAction, Never> {
        guard let currentState = currentState as? TimerFeature.State else {
            return Empty().eraseToAnyPublisher()
        }
        
        switch action as? TimerFeature.Action {
            
        case .start:
            return Timer.publish(every: currentState.interval, on: .main, in: RunLoop.Mode.common)
                 .autoconnect()
                 .map { _ in
                     TimerFeature.Action.add
                 }
                 .eraseToAnyPublisher()
            
        case .tapRightButton:
            if currentState.isStarted {
                return Publishers.Merge(
                    Just(TimerFeature.Action.cancel(for: TimerFeature.Action.start)),
                    Just(TimerFeature.Action.toggleStart)
                )
                .eraseToAnyPublisher()
            } else {
                return Publishers.Merge(
                    Just(TimerFeature.Action.start),
                    Just(TimerFeature.Action.toggleStart)
                )
                .eraseToAnyPublisher()
            }
            
        default:
            return Empty().eraseToAnyPublisher()
        }
    }
    
}
