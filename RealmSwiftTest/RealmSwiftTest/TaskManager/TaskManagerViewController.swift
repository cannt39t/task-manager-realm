//
//  TaskManagerViewController.swift
//  Super easy dev
//
//  Created by Илья Казначеев on 12.06.2023
//

import UIKit
import RealmSwift

protocol TaskManagerViewProtocol: AnyObject {
    func showTasks(tasks: Results<Task>)
    func observeTasks()
    func invalidateObservation()
}

class TaskManagerViewController: UITableViewController {
    // MARK: - Public
    var presenter: TaskManagerPresenterProtocol?
    var tasks: Results<Task>?
    var notificationToken: NotificationToken?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter!.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeTasks()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        invalidateObservation()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = tasks else {
            return 0
        }
        return section == 0 ? tasks.filter{ !$0.isCompleted }.count : tasks.filter{ $0.isCompleted }.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks?[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Must be done" : "Done"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] action, view, completion in
            presenter?.deleteTask(task: tasks![indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .left)
            completion(true)
        }
        
        delete.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .normal, title: "Done") { [unowned self] action, view, completion in
            presenter?.updateTask(task: tasks![indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .right)
            completion(true)
        }
        
        done.image = UIImage(systemName: "checkmark")
        done.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [done])
    }
}

// MARK: - Private functions
private extension TaskManagerViewController {
    func initialize() {
        title = "Task Manager"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        tableViewSetup()
    }
    
    private func tableViewSetup() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc private func addTask() {
        presenter!.addTask()
    }
}

// MARK: - TaskManagerViewProtocol
extension TaskManagerViewController: TaskManagerViewProtocol {
    
    func showTasks(tasks: Results<Task>) {
        self.tasks = tasks
        tableView.reloadData()
    }
    
    func observeTasks() {
        guard let tasks = tasks else { return }
        
        notificationToken = tasks.observe{ [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
                case .initial:
                    self.tableView.reloadData()
                case .update(_, _, let insertions, let modifications):
                    self.tableView.beginUpdates()
                
                    let notDoneInsertions = insertions.filter { $0 < tasks.filter({ !$0.isCompleted }).count }
                    let notDoneModifications = modifications.filter { $0 < tasks.filter({ !$0.isCompleted }).count }
                    
                    let doneInsertions = insertions.filter { $0 >= tasks.filter({ !$0.isCompleted }).count }
                        .map { $0 - tasks.filter({ !$0.isCompleted }).count }
                    let doneModifications = modifications.filter { $0 >= tasks.filter({ !$0.isCompleted }).count }
                        .map { $0 - tasks.filter({ !$0.isCompleted }).count }
                    
                    self.tableView.insertRows(at: notDoneInsertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self.tableView.reloadRows(at: notDoneModifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    
                    self.tableView.insertRows(at: doneInsertions.map { IndexPath(row: $0, section: 1) }, with: .automatic)
                    self.tableView.reloadRows(at: doneModifications.map { IndexPath(row: $0, section: 1) }, with: .automatic)
                    
                    self.tableView.endUpdates()
                case .error(let error):
                    print("Error observing tasks: \(error)")
            }
        }
    }
    
    func invalidateObservation() {
        notificationToken?.invalidate()
        notificationToken = nil
    }
}
