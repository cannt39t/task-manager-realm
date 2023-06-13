//
//  TaskManagerInteractor.swift
//  Super easy dev
//
//  Created by Илья Казначеев on 12.06.2023
//

import RealmSwift


protocol TaskManagerInteractorProtocol: AnyObject {
    func getTasks()
    func addTask()
    func deleteTask(task: Task)
    func toggleTaskStatus(task: Task)
}

class TaskManagerInteractor: TaskManagerInteractorProtocol {

    weak var presenter: TaskManagerPresenterProtocol?
    var taskService: TaskServiceProtocol = TaskService()
    
    func getTasks() {
        let tasks = taskService.getAllTasks()
        presenter?.tasksFetched(tasks)
    }
    
    func addTask() {
        taskService.createTask(title: "Title")
    }
    
    func deleteTask(task: Task) {
        taskService.deleteTask(task: task)
    }
    
    func toggleTaskStatus(task: Task) {
        taskService.updateTask(task: task, title: task.title, isCompleted: !task.isCompleted)
    }
}
