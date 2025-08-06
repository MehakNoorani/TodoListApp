//
//  AddTaskViewController.swift
//  TodoListApp
//
//  Created by Workwise 1 on 05/08/2025.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    
    var selectedPriority: Int = 0
    var viewModel: TaskViewModel!
    var onTaskAdded: (() -> Void)?
    var selectedStatus: String = "Todo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add new task"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        configurePriorityMenu()
        configureStatusMenu()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        
        guard let taskTitle = taskTextField.text, !taskTitle.isEmpty else { return }
        
        let newTask = ToDoListItem(context: viewModel.context)
        newTask.title = taskTitle
        newTask.createdAt = Date()
        
        newTask.priority = Int16(selectedPriority)
        newTask.status = selectedStatus   // <-- Save selected status
        
        viewModel.saveContext()
        onTaskAdded?() // Callback to reload table
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
        
    }
    
    func configurePriorityMenu() {
        let priority1 = UIAction(title: "⭐️", handler: { _ in
            self.selectedPriority = 1
            self.starImageView1.isHidden = false
            self.starImageView2.isHidden = true
            self.starImageView3.isHidden = true
        })
        
        let priority2 = UIAction(title: "⭐️⭐️", handler: { _ in
            self.selectedPriority = 2
            self.starImageView1.isHidden = false
            self.starImageView2.isHidden = false
            self.starImageView3.isHidden = true
        })
        
        let priority3 = UIAction(title: "⭐️⭐️⭐️", handler: { _ in
            self.selectedPriority = 3
            self.starImageView1.isHidden = false
            self.starImageView2.isHidden = false
            self.starImageView3.isHidden = false
        })
        
        let menu = UIMenu(title: "Select Priority", children: [priority1, priority2, priority3])
        priorityButton.menu = menu
        priorityButton.showsMenuAsPrimaryAction = true
    }
    
    func configureStatusMenu() {
        let todo = UIAction(title: "Todo", handler: { _ in
            self.statusLabel.text = "Todo"
            self.updateStatusLabel(to: "Todo")
        })
        
        let done = UIAction(title: "Done", handler: { _ in
            self.statusLabel.text = "Done"
            self.updateStatusLabel(to: "Done")
        })
        
        let menu = UIMenu(title: "Select Status", children: [todo, done])
        statusButton.menu = menu
        statusButton.showsMenuAsPrimaryAction = true
    }
    
    func updateStatusLabel(to status: String) {
        statusLabel.text = status
        print("Status updated to: \(status)")
        
    }
    
}
