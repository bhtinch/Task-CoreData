//
//  TaskController.swift
//  Task-CoreData
//
//  Created by Benjamin Tincher on 1/19/21.
//

import CoreData

class TaskController {
    
    static var shared = TaskController()
    
    var segments: [[Task]] { [incompleteTasks, completedTasks] }
    
    var completedTasks: [Task] = []
    var incompleteTasks: [Task] = []
    
    private lazy var fetchRequest: NSFetchRequest<Task> = {
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    //  Create
    func createTaskWith(name: String, notes: String?, dueDate: Date?) {
        Task(name: name, notes: notes, dueDate: dueDate)
        CoreDataStack.saveContext()
    }
    
    //  Read
    func fetchTasks() {
        let tasks = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        incompleteTasks = tasks.filter { !$0.isComplete }
        completedTasks = tasks.filter { $0.isComplete }
    }
    
    //  Update
    func update(task: Task, name: String, notes: String?, dueDate: Date?) {
        task.name = name
        if let notes = notes, !notes.isEmpty { task.notes = notes }
        if let dueDate = dueDate { task.dueDate = dueDate }
        CoreDataStack.saveContext()
    }
    
    //  Toggle isComplete
    func toggleIsCompleteFor(task: Task) {
        if let index = incompleteTasks.firstIndex(of: task) {
            incompleteTasks.remove(at: index)
            completedTasks.append(task)
        } else if let index = completedTasks.firstIndex(of: task) {
            completedTasks.remove(at: index)
            incompleteTasks.append(task)
        }
        
        task.isComplete.toggle()
        CoreDataStack.saveContext()
    }
    
    //  Delete
    func delete(task: Task) {
        if let index = incompleteTasks.firstIndex(of: task) {
            incompleteTasks.remove(at: index)
        } else if let index = completedTasks.firstIndex(of: task) {
            completedTasks.remove(at: index)
        }
        CoreDataStack.context.delete(task)
        CoreDataStack.saveContext()
    }
}
