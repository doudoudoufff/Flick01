import SwiftUI

class ProjectManager: ObservableObject {
    static let shared = ProjectManager()
    
    @Published private(set) var projects: [Project] = []
    
    private init() {
        // 添加示例项目数据
        addProject(Project(
            name: "蒙牛 TVC",
            startDate: Date(),
            director: "王五",
            creator: "赵六",
            producer: "钱七",
            color: .blue
        ))
        
        addProject(Project(
            name: "流浪地球",
            startDate: Date(),
            director: "郭帆",
            creator: "王红卫",
            producer: "刘慈欣",
            color: .red
        ))
    }
    
    func addProject(_ project: Project) {
        projects.append(project)
        objectWillChange.send()
    }
    
    func updateProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
            objectWillChange.send()
        }
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        objectWillChange.send()
    }
} 