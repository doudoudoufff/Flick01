import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var assignee: String
    var status: TaskStatus
}

enum TaskStatus: String {
    case inProgress = "进行中"
    case completed = "已完成"
    case pending = "待处理"
}

struct ProjectDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var project: Project
    @State private var isEditing = false
    @State private var isAddingTask = false
    @State private var editingTask: Task?
    @State private var newTask = Task(
        title: "",
        date: Date(),
        assignee: "",
        status: .pending
    )
    @State private var tasks: [Task] = [
        Task(
            title: "前期筹备",
            date: Date(),
            assignee: "张三",
            status: .inProgress
        ),
        Task(
            title: "拍摄",
            date: Date().addingTimeInterval(24*60*60),
            assignee: "李四",
            status: .inProgress
        )
    ]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    private var completedTasks: Int {
        tasks.filter { $0.status == .completed }.count
    }
    
    var body: some View {
        ProjectDetailContent(
            project: $project,
            tasks: $tasks,
            completedTasks: completedTasks,
            dateFormatter: dateFormatter,
            isEditing: $isEditing,
            isAddingTask: $isAddingTask,
            editingTask: $editingTask,
            newTask: $newTask
        )
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("项目")
                            .foregroundColor(.blue)
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                Text(project.name)
                    .font(.headline)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isEditing = true }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            ProjectEditView(project: $project)
        }
        .sheet(isPresented: $isAddingTask) {
            TaskEditView(task: $newTask, isNewTask: true)
                .onDisappear {
                    if !newTask.title.isEmpty {
                        tasks.append(newTask)
                    }
                }
        }
        .sheet(item: $editingTask) { task in
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                TaskEditView(task: $tasks[index])
            }
        }
    }
}

struct ProjectDetailContent: View {
    @Binding var project: Project
    @Binding var tasks: [Task]
    let completedTasks: Int
    let dateFormatter: DateFormatter
    @Binding var isEditing: Bool
    @Binding var isAddingTask: Bool
    @Binding var editingTask: Task?
    @Binding var newTask: Task
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ProjectInfoCard(
                    startDate: project.startDate,
                    director: project.director,
                    creator: project.creator,
                    producer: project.producer,
                    dateFormatter: dateFormatter
                )
                
                ProjectProgressSection(
                    completedTasks: completedTasks,
                    totalTasks: tasks.count,
                    projectColor: project.color
                )
                
                TaskListSection(
                    tasks: $tasks,
                    editingTask: $editingTask,
                    isAddingTask: $isAddingTask,
                    newTask: $newTask
                )
            }
            .padding(.vertical)
        }
    }
}

struct ProjectInfoCard: View {
    let startDate: Date
    let director: String
    let creator: String
    let producer: String
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(spacing: 16) {
            InfoRow(icon: "calendar", title: "开始时间", value: dateFormatter.string(from: startDate))
            InfoRow(icon: "video.fill", title: "导演", value: director)
            InfoRow(icon: "person.2.fill", title: "制片", value: creator)
            InfoRow(icon: "person.3.fill", title: "监制", value: producer)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ProjectProgressSection: View {
    let completedTasks: Int
    let totalTasks: Int
    let projectColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("项目进度")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(Int((Float(completedTasks) / Float(totalTasks)) * 100))%")
                    Spacer()
                    Text("\(completedTasks)/\(totalTasks) 任务")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                ProgressView(value: Float(completedTasks) / Float(totalTasks))
                    .tint(projectColor)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

struct TaskListSection: View {
    @Binding var tasks: [Task]
    @Binding var editingTask: Task?
    @Binding var isAddingTask: Bool
    @Binding var newTask: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("任务列表")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach($tasks) { $task in
                TaskRow(task: $task)
                    .onTapGesture {
                        editingTask = task
                    }
            }
            
            Button(action: {
                newTask = Task(
                    title: "",
                    date: Date(),
                    assignee: "",
                    status: .pending
                )
                isAddingTask = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                    Text("添加任务")
                        .foregroundColor(.blue)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
}

struct TaskRow: View {
    @Binding var task: Task
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // 任务状态切换
                Button(action: toggleTaskStatus) {
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 1.5)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Group {
                                if task.status == .completed {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        )
                }
                
                Text(task.title)
                    .font(.headline)
                
                Spacer()
                
                Text(task.status.rawValue)
                    .font(.caption)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(4)
            }
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text(task.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "person")
                    .foregroundColor(.gray)
                Text(task.assignee)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var statusColor: Color {
        switch task.status {
        case .pending:
            return .gray
        case .inProgress:
            return .orange
        case .completed:
            return .green
        }
    }
    
    private func toggleTaskStatus() {
        withAnimation {
            switch task.status {
            case .pending:
                task.status = .inProgress
            case .inProgress:
                task.status = .completed
            case .completed:
                task.status = .pending
            }
        }
    }
}

#Preview {
    NavigationView {
        ProjectDetailView(project: .constant(Project(
            name: "蒙牛 TV",
            startDate: Date(),
            director: "王五",
            creator: "赵六",
            producer: "钱七",
            color: .blue,
            completedTasks: 0,
            totalTasks: 2
        )))
    }
}
