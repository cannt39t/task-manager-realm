//
//  TaskManagerPresenter.swift
//  Super easy dev
//
//  Created by Илья Казначеев on 12.06.2023
//
import RealmSwift


protocol TaskManagerPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func tasksFetched(_ tasks: Results<Task>)
    func addTask()
    func deleteTask(task: Task)
}

class TaskManagerPresenter {
    weak var view: TaskManagerViewProtocol?
    var router: TaskManagerRouterProtocol
    var interactor: TaskManagerInteractorProtocol

    init(interactor: TaskManagerInteractorProtocol, router: TaskManagerRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension TaskManagerPresenter: TaskManagerPresenterProtocol {

    
    func viewDidLoad() {
        interactor.getTasks() 
    }
    
    func tasksFetched(_ tasks: Results<Task>) {
        view!.showTasks(tasks: tasks)
    }
    
    func addTask() {
        interactor.addTask()
    }
    
    func deleteTask(task: Task) {
        interactor.deleteTask(task: task)
    }
}
