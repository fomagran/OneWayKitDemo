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
    
    private let timeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOneWay()
        setupViews()
        setupNavigationBar()
    }
    
}


// MARK: - Set up

extension TimerViewController {
    
    private func setupOneWay() {
        oneway.statePublisher
            .map { String(format: "%.1f", $0.currentTime) }
            .assign(to: \.text, on: timeLabel)
            .store(in: &cancellables)
        
        oneway.statePublisher
            .map { $0.isStarted }
            .removeDuplicates()
            .sink { [weak self] isStarted in
                self?.navigationItem.rightBarButtonItem?.title = isStarted ? "Stop" : "Start"
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.textColor = .black
        timeLabel.font = .systemFont(ofSize: 20, weight: .medium)
        timeLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(tappedRightItems))
    }
    
}


// MARK: - Objc Actions

extension TimerViewController {
    
    @objc private func tappedRightItems() {
        oneway.send(.tapRightButton)
    }
    
}
