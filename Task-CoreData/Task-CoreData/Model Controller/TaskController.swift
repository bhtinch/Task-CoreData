//
//  TaskController.swift
//  Task-CoreData
//
//  Created by Benjamin Tincher on 1/19/21.
//

import CoreData

class TaskController {
    
    static var shared = TaskController()
    
    var tasks: [Task] = []
    
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
        tasks = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
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
        task.isComplete.toggle()
        CoreDataStack.saveContext()
    }
    
    //  Delete
    func delete(task: Task) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks.remove(at: index)
        CoreDataStack.context.delete(task)
        CoreDataStack.saveContext()
    }
}
