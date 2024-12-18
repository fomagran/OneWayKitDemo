//
//  AddToDoViewController.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import UIKit
import OneWaykit

class AddToDoViewController: UIViewController {
    
    private let oneway: OneWay<AddToDoFeature>
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter the title of to do"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(oneway: OneWay<AddToDoFeature>) {
        self.oneway = oneway
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}


// MARK: - Set up

extension AddToDoViewController {
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.widthAnchor.constraint(equalToConstant: 300),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20)
        ])
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
}


// MARK: - Objc Actions

extension AddToDoViewController {
    
    @objc private func saveButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        oneway.send(.add(text))
        self.dismiss(animated: true)
    }
    
}
