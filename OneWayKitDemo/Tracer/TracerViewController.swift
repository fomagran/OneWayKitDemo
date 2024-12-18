//
//  LoggerViewController.swift
//  OneWayKitDemo
//
//  Created by 안영훈 on 12/16/24.
//

import UIKit
import OneWaykit
import Combine

final class TracerViewController: UIViewController {
    
    private lazy var oneway = OneWay<TracerFeature>(
        initialState:
            .init(
                position: .init(x: view.center.x, y: view.center.y),
                size: .init(width: 100, height: 100)
            ),
        context: TracerViewController.self
    )
    private var cancellables = Set<AnyCancellable>()
    
    private let square = UIView()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let upButton = UIButton()
    private let downButton = UIButton()
    private let increaseButton = UIButton()
    private let decreaseButton = UIButton()
    
    private let traceLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupOneway()
        setupActions()
    }
    
}


// MARK: - Set up

extension TracerViewController {
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        square.backgroundColor = .systemRed
        view.addSubview(square)
        
        let buttonStack = UIStackView(arrangedSubviews: [leftButton, rightButton, upButton, downButton, increaseButton, decreaseButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .fill
        
        view.addSubview(buttonStack)
        
        leftButton.setImage(UIImage(systemName: "arrowshape.left"), for: .normal)
        rightButton.setImage(UIImage(systemName: "arrowshape.right"), for: .normal)
        upButton.setImage(UIImage(systemName: "arrowshape.up"), for: .normal)
        downButton.setImage(UIImage(systemName: "arrowshape.down"), for: .normal)
        increaseButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        decreaseButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            buttonStack.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(traceLabel)
        traceLabel.numberOfLines = 0
        traceLabel.textAlignment = .center
        traceLabel.font = .systemFont(ofSize: 14, weight: .medium)
        traceLabel.textColor = .black
        
        traceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            traceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            traceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            traceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
    }
    
    private func setupOneway() {
        oneway.statePublisher
            .map {$0.position }
            .removeDuplicates()
            .sink { [weak self] position in
                self?.square.center = position
            }
            .store(in: &cancellables)
        
        oneway.statePublisher
            .map {$0.size }
            .removeDuplicates()
            .sink { [weak self] size in
                guard let self else { return }
                
                let currentCenter = CGPoint(
                    x: self.square.frame.midX,
                    y: self.square.frame.midY
                )
                
                let newFrame = CGRect(
                    x: currentCenter.x - size.width / 2,
                    y: currentCenter.y - size.height / 2,
                    width: size.width,
                    height: size.height
                )
                
                self.square.frame = newFrame
            }
            .store(in: &cancellables)
        
        oneway.tracer.$event
            .removeDuplicates()
            .sink { [weak self] in
                self?.traceLabel.text = $0
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
        upButton.addTarget(self, action: #selector(tapUpButton), for: .touchUpInside)
        downButton.addTarget(self, action: #selector(tapDownButton), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(tapIncreaseButton), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(tapDecreaseButton), for: .touchUpInside)
    }
    
}


// MARK: - Actions

extension TracerViewController {
    
    @objc private func tapLeftButton() {
        oneway.send(.left, shouldTrace: true)
    }
    
    @objc private func tapRightButton() {
        oneway.send(.right, shouldTrace: true)
    }
    
    @objc private func tapUpButton() {
        oneway.send(.up, shouldTrace: true)
    }
    
    @objc private func tapDownButton() {
        oneway.send(.down, shouldTrace: true)
    }
    
    @objc private func tapIncreaseButton() {
        oneway.send(.increase, shouldTrace: true)
    }
    
    @objc private func tapDecreaseButton() {
        oneway.send(.decrease, shouldTrace: true)
    }
    
}
