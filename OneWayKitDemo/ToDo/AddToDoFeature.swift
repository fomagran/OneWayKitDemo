//
//  AddToDoFeature.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import OneWaykit

struct AddToDoFeature: ViewFeature {
    
    struct State: ViewState {}
    
    enum Action: ViewAction {
        case add(String)
    }
    
    static var updater: Updater = { state, action in
        switch action {
        default: break
        }
        
        return state
    }
    
    static var middlewares: [Middleware]?
}
