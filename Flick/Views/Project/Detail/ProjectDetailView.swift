import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var taskManager = TaskManager()
    @StateObject private var projectManager = ProjectManager.shared
    @Binding var project: Project
    @State private var isEditing = false
    @State private var isAddingTask = false
    @State private var editingTask: Task?
    
    private var projectProgress: (completed: Int, total: Int) {
        let tasks = taskManager.tasksForProject(project.id)
        let completed = tasks.filter { $0.status == .completed }.count
        return (completed, tasks.count)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 项目信息卡片
                VStack(spacing: 16) {
                    Text("项目信息")
                        .font(.headline)
                    
                    InfoRow(icon: "calendar", title: "开始时间", value: project.startDate.formatted(date: .long, time: .omitted))
                    InfoRow(icon: "video.fill", title: "导演", value: project.director)
                    InfoRow(icon: "person.2.fill", title: "制片", value: project.creator)
                    InfoRow(icon: "person.3.fill", title: "监制", value: project.producer)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                
                // 进度卡片
                VStack(spacing: 12) {
                    HStack {
                        Text("项目进度")
                            .font(.headline)
                        Spacer()
                        Text("\(Int((Double(projectProgress.completed) / Double(max(projectProgress.total, 1))) * 100))%")
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                    
                    ProgressView(value: Double(projectProgress.completed), total: Double(max(projectProgress.total, 1)))
                        .tint(project.color)
                    
                    HStack {
                        Text("已完成 \(projectProgress.completed) 个任务")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("共 \(projectProgress.total) 个任务")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                
                // 任务列表卡片
                TaskListCard(
                    tasks: taskManager.tasksForProject(project.id),
                    onStatusToggle: { task in
                        taskManager.updateTask(task)
                    },
                    onAddTask: { isAddingTask = true },
                    onEditTask: { task in
                        editingTask = task
                    },
                    onDeleteTask: { task in
                        taskManager.deleteTask(task)
                    }
                )
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
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
        .onAppear {
            if taskManager.tasksForProject(project.id).isEmpty {
                addTestTasks()
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationView {
                ProjectEditView(project: $project)
                    .onDisappear {
                        if let updatedProject = projectManager.projects.first(where: { $0.id == project.id }) {
                            project = updatedProject
                        }
                    }
            }
        }
        .sheet(isPresented: $isAddingTask) {
            NavigationView {
                TaskEditView(
                    task: Task(
                        title: "",
                        date: Date(),
                        assignee: "",
                        status: .pending,
                        projectId: project.id
                    ),
                    isNew: true
                ) { task in
                    taskManager.addTask(task)
                }
            }
        }
        .sheet(item: $editingTask) { task in
            NavigationView {
                TaskEditView(
                    task: task,
                    isNew: false
                ) { updatedTask in
                    taskManager.updateTask(updatedTask)
                }
            }
        }
    }
    
    private func addTestTasks() {
        let testTasks = [
            Task(
                title: "前期筹备",
                date: Date(),
                assignee: "张三",
                status: .completed,
                projectId: project.id
            ),
            Task(
                title: "场地勘察",
                date: Date().addingTimeInterval(86400),
                assignee: "李四",
                status: .pending,
                projectId: project.id
            ),
            Task(
                title: "拍摄计划制定",
                date: Date().addingTimeInterval(86400 * 2),
                assignee: "王五",
                status: .pending,
                projectId: project.id
            )
        ]
        
        testTasks.forEach { taskManager.addTask($0) }
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
    let task: Task
    let onStatusToggle: (Task) -> Void
    @State private var isCompleted: Bool
    
    init(task: Task, onStatusToggle: @escaping (Task) -> Void) {
        self.task = task
        self.onStatusToggle = onStatusToggle
        _isCompleted = State(initialValue: task.status == .completed)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // 左侧开关
                Toggle("", isOn: Binding(
                    get: { isCompleted },
                    set: { newValue in
                        withAnimation {
                            isCompleted = newValue
                            var updatedTask = task
                            updatedTask.status = newValue ? .completed : .pending
                            onStatusToggle(updatedTask)
                        }
                    }
                ))
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .scaleEffect(0.8)
                .labelsHidden()
                
                // 中间任务信息
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(isCompleted ? .secondary : .primary)
                    
                    HStack(spacing: 16) {
                        // 日期
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 13))
                            Text(task.date.formatted(.dateTime.year().month().day()))
                                .font(.system(size: 13))
                        }
                        
                        // 负责人
                        HStack(spacing: 4) {
                            Image(systemName: "person")
                                .font(.system(size: 13))
                            Text(task.assignee)
                                .font(.system(size: 13))
                        }
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 右侧状态标签
                Text(isCompleted ? "已完成" : "未完成")
                    .font(.system(size: 13))
                    .foregroundColor(isCompleted ? .green : .orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isCompleted ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                    )
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
        }
    }
}

struct SwipeableTaskRow: View {
    let task: Task
    let onStatusToggle: (Task) -> Void
    let onEdit: (Task) -> Void
    let onDelete: (Task) -> Void
    
    var body: some View {
        TaskRow(task: task, onStatusToggle: onStatusToggle)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        if value.translation.width < -50 {
                            // 显示操作按钮
                        }
                    }
            )
            .contextMenu {
                Button(role: .destructive) {
                    withAnimation {
                        onDelete(task)
                    }
                } label: {
                    Label("删除", systemImage: "trash")
                }
                
                Button {
                    onEdit(task)
                } label: {
                    Label("编辑", systemImage: "pencil")
                }
            }
    }
}

struct TaskListCard: View {
    let tasks: [Task]
    let onStatusToggle: (Task) -> Void
    let onAddTask: () -> Void
    let onEditTask: (Task) -> Void
    let onDeleteTask: (Task) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 标题和添加按钮
            HStack {
                Text("任务列表")
                    .font(.system(size: 17, weight: .medium))
                Spacer()
                Button(action: onAddTask) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            if tasks.isEmpty {
                // 空状态
                VStack(spacing: 12) {
                    Image(systemName: "checklist")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("暂无任务")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                // 任务列表
                VStack(spacing: 0) {
                    ForEach(tasks) { task in
                        SwipeableTaskRow(task: task, onStatusToggle: onStatusToggle, onEdit: onEditTask, onDelete: onDeleteTask)
                        
                        if task.id != tasks.last?.id {
                            Divider()
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
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
