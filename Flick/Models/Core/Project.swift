import SwiftUI

struct Project: Identifiable, Hashable {
    let id: UUID
    var name: String
    var startDate: Date
    var director: String
    var creator: String
    var producer: String
    var color: Color
    var completedTasks: Int
    var totalTasks: Int
    
    init(
        id: UUID = UUID(),
        name: String,
        startDate: Date,
        director: String,
        creator: String = "",
        producer: String,
        color: Color,
        completedTasks: Int = 0,
        totalTasks: Int = 0
    ) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.director = director
        self.creator = creator
        self.producer = producer
        self.color = color
        self.completedTasks = completedTasks
        self.totalTasks = totalTasks
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
} 