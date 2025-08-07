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
    
    var selectedPriority: Int = 1
    var viewModel: TaskViewModel!
    var onTaskAdded: (() -> Void)?
    var selectedStatus: String = "Todo"
    var isEditingTask: Bool = false
    var taskToEdit: ToDoListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = isEditingTask ? "Edit Task" : "Add Task"
               navigationController?.navigationBar.prefersLargeTitles = false
               
               configurePriorityMenu()
               configureStatusMenu()
               
               if isEditingTask, let task = taskToEdit {
                   taskTextField.text = task.title
                   dueDatePicker.date = task.createdAt ?? Date()
                   selectedPriority = Int(task.priority)
                   selectedStatus = task.status ?? "Todo"
                   updateStarImages(for: selectedPriority)
                   statusLabel.text = selectedStatus
               }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        let title = taskTextField.text ?? ""
                let date = dueDatePicker.date
                
                if isEditingTask, let task = taskToEdit {
                    task.title = title
                    task.createdAt = dueDatePicker.date
                    task.priority = Int16(selectedPriority)
                    task.status = selectedStatus
                } else {
                    viewModel.addTask(title: title, createdAt: date, priority: Int16(selectedPriority), status: selectedStatus)
                }
                
                viewModel.saveContext()
                onTaskAdded?()
                navigationController?.popViewController(animated: true)
            }

    // MARK: - Priority Menu
    func configurePriorityMenu() {
        let priority1 = UIAction(title: "⭐️", handler: { _ in
            self.selectedPriority = 1
            self.updateStarImages(for: 1)
        })
            
        let priority2 = UIAction(title: "⭐️⭐️", handler: { _ in
            self.selectedPriority = 2
            self.updateStarImages(for: 2)
        })
            
        let priority3 = UIAction(title: "⭐️⭐️⭐️", handler: { _ in
            self.selectedPriority = 3
            self.updateStarImages(for: 3)
        })
            
        let menu = UIMenu(
            title: "Select Priority",
            children: [priority1, priority2, priority3]
        )
        priorityButton.menu = menu
        priorityButton.showsMenuAsPrimaryAction = true
    }

    func updateStarImages(for priority: Int) {
        starImageView1.isHidden = priority < 1
        starImageView2.isHidden = priority < 2
        starImageView3.isHidden = priority < 3
    }

    // MARK: - Status Menu
    func configureStatusMenu() {
        let todo = UIAction(title: "Todo", handler: { _ in
            self.updateStatusLabel(to: "Todo")
        })
            
        let done = UIAction(title: "Done", handler: { _ in
            self.updateStatusLabel(to: "Done")
        })
            
        let menu = UIMenu(title: "Select Status", children: [todo, done])
        statusButton.menu = menu
        statusButton.showsMenuAsPrimaryAction = true
    }

    func updateStatusLabel(to status: String) {
        statusLabel.text = status
        selectedStatus = status
        print("Status updated to: \(status)")
    }
}
   





