//
//  ToDoListItem+CoreDataProperties.swift
//  TodoListApp
//
//  Created by Workwise 1 on 04/08/2025.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var priority: Int16
    @NSManaged public var status: String?

}

extension ToDoListItem : Identifiable {

}
