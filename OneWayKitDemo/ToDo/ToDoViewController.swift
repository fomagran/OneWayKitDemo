//
//  ToDoViewController.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import UIKit
import OneWaykit
import Combine

final class ToDoViewController: UIViewController {
    
    private let oneway = OneWay<ToDoFeature>(initialState: .init(todos: []))
    private let addToDoOneWay = OneWay<AddToDoFeature>(initialState: .init())
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOneWay()
        setupTableView()
        setupNavigationBar()
    }
    
}


// MARK: - Set up

extension ToDoViewController {
    
    private func setupOneWay() {
        oneway.statePublisher
            .sink { [weak self] state in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        addToDoOneWay.action
            .compactMap { $0 }
            .sink { [weak self] in
                self?.oneway.send(.addToDo($0))
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
}


// MARK: - Objc Actions

extension ToDoViewController {
    
    @objc private func addButtonTapped() {
        let addToDoVC = AddToDoViewController(oneway: addToDoOneWay)
        present(addToDoVC, animated: true, completion: nil)
    }
    
}


// MARK: - UITableViewDataSource

extension ToDoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = oneway.state.todos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        oneway.state.todos.count
    }
    
}


// MARK: - UITableViewDelegate

extension ToDoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            oneway.send(.delete(indexPath.row))
        }
    }
    
}
