//
//  ViewController.swift
//  TodoListApp
//
//  Created by Workwise 1 on 04/08/2025.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate{
    
    var filteredTasks: [ToDoListItem] = []
    var isSearching: Bool = false
//    let viewModel = TaskViewModel()
    var viewModel = TaskViewModel() // not optional!


    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To-Do List"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        viewModel.fetchTasks()
        tableView.reloadData()
        searchBar.delegate = self
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToAddTaskVC" {
//            if let addVC = segue.destination as? AddTaskViewController {
//                addVC.viewModel = self.viewModel
//            }
//        }
//    }

    @IBAction func addBtnTapped(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let addVC = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController {
//                addVC.viewModel = viewModel
//                addVC.onTaskAdded = { [weak self] in
//                    self?.viewModel.fetchTasks()
//                    self?.tableView.reloadData()
//                    self?.navigationController?.pushViewController(addVC, animated: true)
//                }
//            }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyboard.instantiateViewController(identifier: "AddTaskViewController") as! AddTaskViewController
        addVC.viewModel = self.viewModel
        addVC.onTaskAdded = { [weak self] in
            self?.viewModel.fetchTasks()
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(addVC, animated: true)

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            filteredTasks = viewModel.searchTasks(with: searchText)
            tableView.reloadData()
        }
    }


}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return viewModel.tasks.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else {
    //            return UITableViewCell()
    //        }
    //
    //        let task = viewModel.tasks[indexPath.row]
    //        cell.taskLbl.text = task.title
    //        cell.statusLbl.text = task.status
    //        cell.dateLbl.text = DateFormatter.localizedString(from: task.createdAt ?? Date(), dateStyle: .short, timeStyle: .none)
    //
    //        // Reset all stars to hidden or unfilled
    //        cell.priorityImg1.image = UIImage(named: "star")
    //        cell.priorityImg2.image = UIImage(named: "star")
    //        cell.priorityImg3.image = UIImage(named: "star")
    //
    //        // Fill based on priority
    //        let filledStar = UIImage(named: "star.fill")
    //
    //        if task.priority >= 1 { cell.priorityImg1.image = filledStar }
    //        if task.priority >= 2 { cell.priorityImg2.image = filledStar }
    //        if task.priority >= 3 { cell.priorityImg3.image = filledStar }
    //        return cell
    //
    //    }
    //
    //
    //}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredTasks.count : viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = isSearching ? filteredTasks[indexPath.row] : viewModel.tasks[indexPath.row]
        cell.taskLbl.text = task.title
//        cell.dateLbl.text = formatDate(task.dueDate)
        cell.statusLbl.text = task.status == "Done" ? "Done" : "ToDo"
        cell.priorityImg1.isHidden = task.priority < 1
        cell.priorityImg2.isHidden = task.priority < 2
        cell.priorityImg3.isHidden = task.priority < 3

//        let task = isSearching ? filteredTasks[indexPath.row] : viewModel.tasks[indexPath.row]
//        cell.taskLbl.text = task.title
//        cell.statusLbl.text = task.status
//        cell.dateLbl.text = DateFormatter.localizedString(from: task.createdAt ?? Date(), dateStyle: .short, timeStyle: .none)
//        
        // Star logic
        let filled = UIImage(systemName: "star.fill")
        let empty = UIImage(systemName: "star")
        cell.priorityImg1.image = task.priority >= 1 ? filled : empty
        cell.priorityImg2.image = task.priority >= 2 ? filled : empty
        cell.priorityImg3.image = task.priority >= 3 ? filled : empty
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.viewModel.deleteTask(at: indexPath.row)
            tableView.reloadData()
        }

        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            // Navigate to AddTaskVC for editing
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

}

