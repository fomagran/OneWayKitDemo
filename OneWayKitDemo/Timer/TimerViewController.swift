//
//  TimerViewController.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import UIKit
import OneWaykit
import Combine

final class TimerViewController: UIViewController {
    
    private let oneway = OneWay<TimerFeature>(initialState: .init())
    private var cancellables = Set<AnyCancellable>()
    private var isCancelled: Bool = false
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOneWay()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupOneWay() {
        // Binding State
        oneway.statePublisher
            .map { $0.messages }
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        oneway.statePublisher
            .map { $0.isCancelled }
            .removeDuplicates()
            .sink { [weak self] isCancelled in
                self?.navigationItem.rightBarButtonItem?.title = isCancelled ? "Resume" : "Cancel"
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimerCell")
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Resume", style: .plain, target: self, action: #selector(tappedRightItems))
    }
    
    @objc private func tappedRightItems() {
        oneway.send(.tapRightButton)
    }
}


// MARK: - UITableViewDataSource

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath)
        cell.textLabel?.text = oneway.state.messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        oneway.state.messages.count
    }
}
