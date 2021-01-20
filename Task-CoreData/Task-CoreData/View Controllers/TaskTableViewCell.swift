//
//  TaskTableViewCell.swift
//  Task-CoreData
//
//  Created by Benjamin Tincher on 1/19/21.
//

import UIKit

protocol TaskIsCompleteStatusUpdate: AnyObject {
    func updateIsCompleteStatus(_ sender: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    
    //  Outlets
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDueDateLabel: UILabel!
    @IBOutlet weak var taskIsCompleteButton: UIButton!
    
    weak var delegate: TaskIsCompleteStatusUpdate?
    
    //  Actions
    @IBAction func taskIsCompleteButtonTapped(_ sender: Any) {
        delegate?.updateIsCompleteStatus(self)
    }
    
    func updateViews(task: Task) {
        taskNameLabel.text = task.name
        
        let image = task.isComplete ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        taskIsCompleteButton.setImage(image, for: .normal)
        taskIsCompleteButton.tintColor = .black
        
        if let dueDate = task.dueDate {
            let dateString = dueDate.dateToString(format: Date.DateFormatType.monthDayTimestamp)
            taskDueDateLabel.text = "Due: \(dateString)"
            taskDueDateLabel.textColor = .systemRed
        } else {
            taskDueDateLabel.text = "Due: none"
            taskDueDateLabel.textColor = .systemBlue
        }
    }
}
