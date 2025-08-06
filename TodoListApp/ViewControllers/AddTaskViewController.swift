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
    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!

    
    var selectedPriority: Int = 0
    var viewModel: TaskViewModel!
    var onTaskAdded: (() -> Void)?
    var selectedStatus: String = "Todo"

    
        override func viewDidLoad() {
            super.viewDidLoad()
        title = "Add new task"
            print("✅ AddTaskVC loaded. viewModel is nil? \(viewModel == nil)")
        navigationController?.navigationBar.prefersLargeTitles = false
    
        }

    func updatePriorityImage() {
        
        let starConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        
        // Create star images
        let starImage = UIImage(systemName: "star.fill", withConfiguration: starConfig)!
        
        // Final image size
        let totalWidth = CGFloat(selectedPriority) * 24
        let size = CGSize(width: totalWidth, height: 24)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            for i in 0..<selectedPriority {
                starImage.draw(at: CGPoint(x: CGFloat(i) * 24, y: 0))
            }
        }
        
        priorityImageView.image = image
    }
    
    
    
    @IBAction func priorityButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Priority", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "⭐️", style: .default, handler: { _ in
            self.selectedPriority = 1
            self.updatePriorityImage()
        }))
        alert.addAction(UIAlertAction(title: "⭐️⭐️", style: .default, handler: { _ in
            self.selectedPriority = 2
            self.updatePriorityImage()
        }))
        alert.addAction(UIAlertAction(title: "⭐️⭐️⭐️", style: .default, handler: { _ in
            self.selectedPriority = 3
            self.updatePriorityImage()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Important for iPhone: anchor the popover
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    @IBAction func statusButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Status", message: nil, preferredStyle: .actionSheet)
        
        let todo = UIAlertAction(title: "Todo", style: .default) { _ in
            self.statusLabel.text = "Todo"
            // Optionally update color or internal variable
        }

        let done = UIAlertAction(title: "Done", style: .default) { _ in
            self.statusLabel.text = "Done"
        }

        let inProgress = UIAlertAction(title: "In Progress", style: .default) { _ in
            self.statusLabel.text = "In Progress"
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(todo)
        alert.addAction(done)
        alert.addAction(inProgress)
        alert.addAction(cancel)

        // For iPad support
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }

        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        guard let title = taskTextField.text, !title.isEmpty else {
                return
            }

            let dueDate = dueDatePicker.date
            let priority = selectedPriority
            let status = selectedStatus
        
        print("viewModel is nil? \(viewModel == nil)")

        viewModel?.addTask(title: title, dueDate: dueDate, priority: Int16(priority), status: status)

//        viewModel.addTask(title: title, dueDate: dueDate, priority: Int16(priority), status: status)
            onTaskAdded?()
            navigationController?.popViewController(animated: true)
        
        }


//  hello
}
