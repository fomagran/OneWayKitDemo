//
//  TimerFeature.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import OneWaykit
import Foundation

struct TimerFeature: ViewFeature {
    
    struct State: ViewState {
        var currentTime: Float = 0
        var isStarted: Bool = false
        var interval: TimeInterval = 0.1
    }
    
    enum Action: ViewAction {
        case start
        case add
        case tapRightButton
        case toggleStart
    }
    
    static var updater: Updater = { state, action in
        var newState = state
        switch action {
            
        case .add:
            newState.currentTime += Float(state.interval)
            
        case .toggleStart:
            newState.isStarted.toggle()
            
        default: break
        }
        
        return newState
    }
    
    static var middlewares: [Middleware]? = [TimerMiddleware()]
    
}
