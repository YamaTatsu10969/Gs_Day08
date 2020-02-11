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

    //外部からの初期化を禁止
    private init(){
        taskUseCase = TaskUseCase()
        load()
    }

    // 通信を行うクラス
    let taskUseCase: TaskUseCase

    // private →　このクラスのみで扱う
    private var tasks: [Task] = []

    //弱参照して循環参照を防ぐ
    // 他のクラスが、delegate としてここに潜り込んで、このクラスで saveが行われたり、load が行われたりしたことを、delegate.saved などで、潜り込んだクラスが知ることができる。
    // 例： TaskListViewController
    weak var delegate: TaskCollectionDelegate? = nil
    
    func createTask() -> Task {
        let id = taskUseCase.createTaskId()
        return Task(id: id)
    }

    func getTask (at: Int) -> Task{
        return tasks[at]
    }
    
    func taskCount () -> Int{
        return tasks.count
    }
    
    func addTask(_ task: Task) {
        taskUseCase.addTask(task)
        tasks.append(task)
        save()
    }
    
    func editTask(task: Task, index: Int) {
        taskUseCase.editTask(task)
        tasks[index] = task
        save()
    }
    
    func removeTask(index: Int) {
        taskUseCase.removeTask(taskId: tasks[index].id)
        tasks.remove(at: index)
        save()
    }


    //MARK: private このクラスでしか使用しない
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
