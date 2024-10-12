//
//  ExampleTableViewController.swift
//  OneWayKitDemo
//
//  Created by Fomagran on 10/12/24.
//

import UIKit

class ExampleTableViewController: UITableViewController {
    
    enum Example: String, CaseIterable {
        case todo
        case timer
    }
    
    private var examples: [Example] = Example.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExampleCell")
    }
    
    // MARK: - Table view data source and delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleCell", for: indexPath)
        cell.textLabel?.text = examples[indexPath.row].rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = examples[indexPath.row]
        
        switch example {
        case .todo:
            self.navigationController?.pushViewController(ToDoViewController(), animated: true)
        case .timer:
            self.navigationController?.pushViewController(TimerViewController(), animated: true)
        }
    }
    
}
