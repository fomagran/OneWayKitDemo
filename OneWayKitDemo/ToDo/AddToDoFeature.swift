//
//  AddToDoFeature.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import OneWaykit

struct AddToDoFeature: Featurable {
    static var id: String = "AddToDoFeature"
    
    struct State: FeatureState {}
    
    enum Action: FeatureAction {
        case add(String)
    }
    
    static var updater: Updater = { state, action in
        switch action {
        default: break
        }
        
        return state
    }
    
    static var asyncActions: [AsyncAction]?
}