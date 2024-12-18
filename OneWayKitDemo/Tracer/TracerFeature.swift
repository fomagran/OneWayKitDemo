//
//  LoggerFeature.swift
//  OneWayKitDemo
//
//  Created by 안영훈 on 12/16/24.
//

import OneWaykit
import Foundation

struct TracerFeature: ViewFeature {
    
    struct State: ViewState {
        var shouldLog: Bool = true
        var position: CGPoint
        var size: CGSize
    }
    
    enum Action: ViewAction {
        case left
        case right
        case up
        case down
        case increase
        case decrease
    }
    
    static var updater: Updater = { state, action in
        var newState = state
        switch action {
        case .left:
            newState.position.x -= 10
        case .right:
            newState.position.x += 10
        case .up:
            newState.position.y -= 10
        case .down:
            newState.position.y += 10
        case .increase:
            newState.size.width = min(200,  newState.size.width + 10)
            newState.size.height = min(200,  newState.size.height + 10)
        case .decrease:
            newState.size.width = max(50,  newState.size.width - 10)
            newState.size.height = max(50,  newState.size.height - 10)
        }
        
        return newState
    }
    
    static var middlewares: [Middleware]?
}
