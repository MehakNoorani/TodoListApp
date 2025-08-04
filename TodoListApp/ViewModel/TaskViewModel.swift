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

        var tasks: [Task] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // MARK: - Fetch Tasks
        func fetchTasks() {
            let request: NSFetchRequest<ToDoListItem> = Task.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            do {
                tasks = try context.fetch(request)
            } catch {
                print("Failed to fetch: \(error)")
            }
        }

        // MARK: - Add Task
        func addTask(title: String, dueDate: Date, priority: Int16, status: String) {
            let task = Task(context: context)
            task.title = title
            task.dueDate = dueDate
            task.priority = priority
            task.status = status
            task.createdAt = Date()
            saveContext()
        }

        // MARK: - Update Task
        func updateTask(_ task: Task, title: String, dueDate: Date, priority: Int16, status: String) {
            task.title = title
            task.dueDate = dueDate
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
