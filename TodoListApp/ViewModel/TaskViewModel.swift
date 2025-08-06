//
//  TaskViewModel.swift
//  TodoListApp
//
//  Created by Workwise 1 on 04/08/2025.
//

import Foundation
import CoreData
import UIKit

class TaskViewModel {

        var tasks: [ToDoListItem] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Fetch Tasks
        func fetchTasks() {
            let request: NSFetchRequest<ToDoListItem> = ToDoListItem.fetchRequest()

            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            do {
                tasks = try context.fetch(request)
            } catch {
                print("Failed to fetch: \(error)")
            }
        }

        // MARK: - Add Task
        func addTask(title: String, dueDate: Date, priority: Int16, status: String) {
            let newTask = ToDoListItem(context: context)
            newTask.title = title
            newTask.priority = priority
            newTask.status = status
            newTask.createdAt = Date()
            saveContext()
            fetchTasks()

        }


        // MARK: - Update Task
        func updateTask(_ task: ToDoListItem, title: String, dueDate: Date, priority: Int16, status: String) {
            task.title = title
            task.priority = priority
            task.status = status
            saveContext()
        }

        // MARK: - Delete Task
        func deleteTask(at index: Int) {
            let task = tasks[index]
            context.delete(task)
            saveContext()
        }
        func searchTasks(with query: String) -> [ToDoListItem] {
            if query.isEmpty {
            return tasks
        }
        return tasks.filter { task in
            task.title?.lowercased().contains(query.lowercased()) == true
        }
    }
        // MARK: - Save
        private func saveContext() {
            do {
                try context.save()
                fetchTasks()
            } catch {
                print("Failed to save: \(error)")
            }
        }
    

}
