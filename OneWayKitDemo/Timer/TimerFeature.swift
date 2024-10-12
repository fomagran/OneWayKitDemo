//
//  TimerFeature.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import OneWaykit
import Foundation

struct TimerFeature: Featurable {
    static var id: String = "TimerFeature"
    
    struct State: FeatureState {
        var messages: [String] = []
        var isCancelled: Bool = true
    }
    
    enum Action: FeatureAction {
        case add(String)
        case addMessagePerSecond(TimeInterval)
        case tapRightButton
        case setCancel(Bool)
    }
    
    static var updater: Updater = { state, action in
        var newState = state
        switch action {
        case .add(let message):
            newState.messages.append(message)
        case .setCancel(let isCancelled):
            newState.isCancelled = isCancelled
        default: break
        }
        
        return newState
    }
    
    static var asyncActions: [AsyncAction]? = [TimerAsyncAction()]
}
