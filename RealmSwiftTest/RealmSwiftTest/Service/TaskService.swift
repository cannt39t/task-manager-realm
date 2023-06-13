//
//  TaskService.swift
//  RealmSwiftTest
//
//  Created by Илья Казначеев on 12.06.2023.
//

import Foundation
import RealmSwift

protocol TaskServiceProtocol {
    func getAllTasks() -> Results<Task>
    func createTask(title: String)
    func updateTask(task: Task, title: String, isCompleted: Bool)
    func deleteTask(task: Task)
}

class TaskService: TaskServiceProtocol {
    
    private var realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func getAllTasks() -> Results<Task> {
        return realm.objects(Task.self).sorted(byKeyPath: "createdAt", ascending: true)
    }
    
    func createTask(title: String) {
        let task = Task()
        task.title = title
        
        try? realm.write({
            realm.add(task)
        })
    }
    
    func updateTask(task: Task, title: String, isCompleted: Bool) {
        try? realm.write({
            task.title = title
            task.isCompleted = isCompleted
        })
    }
    
    func deleteTask(task: Task) {
        try? realm.write({
            realm.delete(task)
        })
    }
}
