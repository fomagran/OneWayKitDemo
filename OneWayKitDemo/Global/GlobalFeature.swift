//
//  GlobalFeature.swift
//  OneWayKitDemo
//
//  Created by 안영훈 on 12/17/24.
//

import UIKit
import OneWaykit

struct GlobalFeature: ViewFeature {
   
    struct State: ViewState {
        var backgroundColor: UIColor = .white
        var font: UIFont = .systemFont(ofSize: 14)
        var textColor: UIColor = .black
    }
    
    enum Action: ViewAction {
        case setBackgroundColor(UIColor)
        case setFont(UIFont)
        case setTextColor(UIColor)
    }
    
    static var updater: Updater = { state, action in
        var newState = state
        switch action {
            
        case .setBackgroundColor(let color):
            newState.backgroundColor = color
            
        case .setFont(let font):
            newState.font = font
            
        case .setTextColor(let color):
            newState.textColor = color
        }
        
        return newState
    }
    
    static var middlewares: [any Middleware]?
    
}
