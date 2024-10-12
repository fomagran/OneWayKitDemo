//
//  ToDoFeature.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import OneWaykit
import Foundation

struct ToDoFeature: Featurable {
    static var id: String = "TodoFeature"
    
    struct State: FeatureState {
        var todos: [String]
    }
    
    enum Action: FeatureAction {
        case add(String)
        case delete(Int)
        case addToDo(AddToDoFeature.Action)
        case reserveToDo(Int)
        case addToDoPerSecond(TimeInterval)
    }
    
    static var updater: Updater = { state, action in
        var newState = state
        switch action {
        case .add(let newToDo):
            var todos = state.todos
            todos.append(newToDo)
            newState.todos = todos
            
        case .delete(let index):
            var todos = state.todos
            todos.remove(at: index)
            newState.todos = todos
            
        case .addToDo(let action):
            switch action {
            case .add(let newToDo):
                var todos = state.todos
                todos.append(newToDo)
                newState.todos = todos
            }
            
        default: break
        }
        
        return newState
    }
    
    static var asyncActions: [AsyncAction]?
}
