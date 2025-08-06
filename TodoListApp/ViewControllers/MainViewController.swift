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
    var viewModel = TaskViewModel()
    


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo List"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        viewModel.fetchTasks()
        tableView.reloadData()
        searchBar.delegate = self
        
    }

    @IBAction func addBtnTapped(_ sender: UIButton) {

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredTasks.count : viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = isSearching ? filteredTasks[indexPath.row] : viewModel.tasks[indexPath.row]
        cell.taskLbl.text = task.title
        //        cell.statusLbl.text = task.status == "Done" ? "In Progress" : "Todo"
        cell.statusLbl.text = task.status
        
        
        cell.priorityImg1.isHidden = task.priority < 1
        cell.priorityImg2.isHidden = task.priority < 2
        cell.priorityImg3.isHidden = task.priority < 3
        
        
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
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
