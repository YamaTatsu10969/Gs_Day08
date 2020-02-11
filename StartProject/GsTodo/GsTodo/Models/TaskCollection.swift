//
//  TaskCollection.swift
//  GsTodo
//
//  Created by yamamototatsuya on 2020/01/15.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import Foundation

protocol TaskCollectionDelegate: class {
    func saved()
    func loaded()
}

class TaskCollection {
    //初回アクセスのタイミングでインスタンスを生成
    static var shared = TaskCollection()
    
    let taskUseCase: TaskUseCase
    
    //外部からの初期化を禁止
    private init(){
        taskUseCase = TaskUseCase()
        load()
    }
    
    func createTask() -> Task {
        let id = taskUseCase.createTaskId()
        return Task(id: id)
    }
    
    //外部からは参照のみ許可 // ここに全ての情報が持っている！！！
    private var tasks: [Task] = []
    
    //弱参照して循環参照を防ぐ
    weak var delegate: TaskCollectionDelegate? = nil
    
    func getTask (at: Int) -> Task{
        return tasks[at]
    }
    
    func taskCount () -> Int{
        return tasks.count
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        taskUseCase.addTask(task)
        save()
    }
    
    func editTask(task: Task, index: Int) {
        tasks[index] = task
        taskUseCase.editTask(task)
        save()
    }
    
    func removeTask(index: Int) {
        tasks.remove(at: index)
        taskUseCase.removeTask(taskId: tasks[index].id)
        save()
    }
    
    private func save() {
        tasks = sortTaskByUpdatedAt(tasks: tasks)
        delegate?.saved()
    }
    
    private func load() {
        taskUseCase.fetchTaskDocuments { (fetchTasks) in
            guard let fetchTasks = fetchTasks else {
                self.save()
                return
            }
            self.tasks = self.sortTaskByUpdatedAt(tasks: fetchTasks)
            self.delegate?.loaded()
        }
    }

    private func sortTaskByUpdatedAt(tasks: [Task]) -> [Task] {
        return tasks.sorted(by: {$0.updatedAt.dateValue() > $1.updatedAt.dateValue()})
    }
}
