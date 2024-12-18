//
//  GlobalViewController.swift
//  OneWayKitDemo
//
//  Created by 안영훈 on 12/17/24.
//

import UIKit
import OneWaykit
import Combine

final class GlobalViewController: UIViewController {
    
    private let bottomSheet1 = BottomSheetViewController()
    private let bottomSheet2 = BottomSheetViewController()
    private let bottomSheet3 = BottomSheetViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupOneWay()
    }
    
}


// MARK: - Set up

extension GlobalViewController {
    
    private func setupViews() {
        let showBottomSheet1Button = UIButton(type: .system)
        let showBottomSheet2Button = UIButton(type: .system)
        let showBottomSheet3Button = UIButton(type: .system)
        
        let stack = UIStackView(arrangedSubviews: [showBottomSheet1Button, showBottomSheet2Button, showBottomSheet3Button])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        
        showBottomSheet1Button.setTitle("Show Bottom Sheet 1", for: .normal)
        showBottomSheet1Button.addTarget(self, action: #selector(showBottomSheet1), for: .touchUpInside)
        
        showBottomSheet2Button.setTitle("Show Bottom Sheet 2", for: .normal)
        showBottomSheet2Button.addTarget(self, action: #selector(showBottomSheet2), for: .touchUpInside)
        
        showBottomSheet3Button.setTitle("Show Bottom Sheet 3", for: .normal)
        showBottomSheet3Button.addTarget(self, action: #selector(showBottomSheet3), for: .touchUpInside)

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    private func setupOneWay() {
        GlobalOneWay.registerState(feature: GlobalFeature.self, initialState: .init())
    }
    
}

// MARK: - Objc Actions

extension GlobalViewController {
    
    @objc private func showBottomSheet1() {
        bottomSheet1.modalPresentationStyle = .pageSheet
        present(bottomSheet1, animated: true, completion: nil)
    }
    
    @objc private func showBottomSheet2() {
        bottomSheet2.modalPresentationStyle = .pageSheet
        present(bottomSheet2, animated: true, completion: nil)
    }
    
    @objc private func showBottomSheet3() {
        bottomSheet3.modalPresentationStyle = .pageSheet
        present(bottomSheet3, animated: true, completion: nil)
    }
    
}

final class BottomSheetViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupOneWay()
    }
    
}


// MARK: - Set up

extension BottomSheetViewController {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let backgroundColorButton = UIButton(type: .system)
        let fontButton = UIButton(type: .system)
        let textColorButton = UIButton(type: .system)
        
        let stack = UIStackView(arrangedSubviews: [backgroundColorButton, fontButton, textColorButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        
        backgroundColorButton.setTitle("Change Background Color", for: .normal)
        backgroundColorButton.addTarget(self, action: #selector(changeBackgroundColor), for: .touchUpInside)
        
        fontButton.setTitle("Change Font", for: .normal)
        fontButton.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        
        textColorButton.setTitle("Change Text Color", for: .normal)
        textColorButton.addTarget(self, action: #selector(changeTextColor), for: .touchUpInside)

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(titleLabel)
        
        titleLabel.text = "Title"
        titleLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -20)
        ])
    }
    
    private func setupOneWay() {
        GlobalOneWay.state(feature: GlobalFeature.self)?
            .map { $0.backgroundColor }
            .sink { [weak self] in
                self?.titleLabel.backgroundColor = $0
            }
            .store(in: &cancellables)
        
        GlobalOneWay.state(feature: GlobalFeature.self)?
            .map { $0.font }
            .sink { [weak self] in
                self?.titleLabel.font = $0
            }
            .store(in: &cancellables)
        
        GlobalOneWay.state(feature: GlobalFeature.self)?
            .map { $0.textColor }
            .sink { [weak self] in
                self?.titleLabel.textColor = $0
            }
            .store(in: &cancellables)
    }
    
}


// MARK: - Objc Actions

extension BottomSheetViewController {
 
    @objc private func changeBackgroundColor() {
        let colors: [UIColor] = [.blue, .red, .orange, .green, .black]
        GlobalOneWay.send(feature: GlobalFeature.self, .setBackgroundColor(colors.randomElement() ?? .white))
    }
    
    @objc private func changeFont() {
        let fonts: [UIFont] = [.systemFont(ofSize: 18), .systemFont(ofSize: 20, weight: .bold), .systemFont(ofSize: 14, weight: .light), .systemFont(ofSize: 30, weight: .ultraLight), .systemFont(ofSize: 12, weight: .heavy)]
        GlobalOneWay.send(feature: GlobalFeature.self, .setFont(fonts.randomElement() ?? .systemFont(ofSize: 16)))
    }
    
    @objc private func changeTextColor() {
        let colors: [UIColor] = [.cyan, .magenta, .brown, .purple, .yellow]
        GlobalOneWay.send(feature: GlobalFeature.self, .setTextColor(colors.randomElement() ?? .white))
    }
    
}
