//
//  TaskDetailViewController.swift
//  Task-CoreData
//
//  Created by Benjamin Tincher on 1/19/21.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    //  Outlets
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var TaskNotesTextView: UITextView!
    @IBOutlet weak var TaskDueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = task {
            taskNameTextField.text = task.name
            if let notes = task.notes { TaskNotesTextView.text = notes }
            if let date = task.dueDate {
                TaskDueDatePicker.date = date
                dueDate = date
            }
        }
    }
    
    var task: Task?
    var dueDate: Date?
    
    //  Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = taskNameTextField.text, !name.isEmpty else { return }
        
        if let task = task {
            TaskController.shared.update(task: task, name: name, notes: TaskNotesTextView.text, dueDate: dueDate)
        } else {
            TaskController.shared.createTaskWith(name: name, notes: TaskNotesTextView.text, dueDate: dueDate)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dueDatePickerChanged(_ sender: Any) {
        dueDate = TaskDueDatePicker.date
    }
}
