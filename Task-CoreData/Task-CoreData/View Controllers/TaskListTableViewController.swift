//
//  TaskListTableViewController.swift
//  Task-CoreData
//
//  Created by Benjamin Tincher on 1/19/21.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    @IBOutlet weak var hideCompletedButton: UIBarButtonItem!
    var hideCompleted: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TaskController.shared.fetchTasks()
        tableView.reloadData()
    }
    
    @IBAction func didChageSegment(_ sender: UISegmentedControl) {
        //hideCompleted.toggle()
        
        if sender.selectedSegmentIndex == 0 {
            hideCompleted = true
        } else {
            hideCompleted = false
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hideCompleted {
           return  TaskController.shared.incompleteTasks.count
        } else {
            return TaskController.shared.completedTasks.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        
        var task: Task
        if hideCompleted {
            task = TaskController.shared.incompleteTasks[indexPath.row]
        } else {
            task = TaskController.shared.completedTasks[indexPath.row]
        }
        cell.delegate = self
        cell.updateViews(task: task)
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var task: Task
            if hideCompleted {
                task = TaskController.shared.incompleteTasks[indexPath.row]
            } else {
                task = TaskController.shared.completedTasks[indexPath.row]
            }
            TaskController.shared.delete(task: task)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? TaskDetailViewController else { return }
            var index: Int
            if hideCompleted { index = 0 } else { index = 1 }
            destination.task = TaskController.shared.segments[index][indexPath.row]
        }
    }
}

extension TaskListTableViewController: TaskIsCompleteStatusUpdate {
    func updateIsCompleteStatus(_ sender: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        var index: Int
        if hideCompleted { index = 0 } else { index = 1 }
        let task = TaskController.shared.segments[index][indexPath.row]
        TaskController.shared.toggleIsCompleteFor(task: task)
        sender.updateViews(task: task)
        self.tableView.reloadData()
    }
}
