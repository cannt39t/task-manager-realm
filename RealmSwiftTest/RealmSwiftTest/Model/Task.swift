//
//  Task.swift
//  RealmSwiftTest
//
//  Created by Илья Казначеев on 12.06.2023.
//

import Foundation
import RealmSwift

class Task: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var isCompleted: Bool = false
    @Persisted var createdAt: Date = Date()
}
