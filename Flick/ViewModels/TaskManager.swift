import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @Published private var tasks: [Task] = []
    
    func tasksForProject(_ projectId: UUID) -> [Task] {
        tasks.filter { $0.projectId == projectId }
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        objectWillChange.send()
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            objectWillChange.send()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        objectWillChange.send()
    }
} 