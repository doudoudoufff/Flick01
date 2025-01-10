import Foundation

struct Task: Identifiable, Equatable {
    let id: UUID
    var title: String
    var date: Date
    var assignee: String
    var status: TaskStatus
    var projectId: UUID
    
    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        assignee: String,
        status: TaskStatus,
        projectId: UUID
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.assignee = assignee
        self.status = status
        self.projectId = projectId
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id
    }
} 