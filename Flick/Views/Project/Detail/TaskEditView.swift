import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var editedTask: Task
    let isNew: Bool
    let onSave: (Task) -> Void
    
    init(task: Task, isNew: Bool, onSave: @escaping (Task) -> Void) {
        _editedTask = State(initialValue: task)
        self.isNew = isNew
        self.onSave = onSave
    }
    
    var body: some View {
        Form {
            Section("任务信息") {
                TextField("任务名称", text: $editedTask.title)
                DatePicker("截止日期", selection: $editedTask.date, displayedComponents: .date)
                TextField("负责人", text: $editedTask.assignee)
            }
            
            if !isNew {
                Section("状态") {
                    Picker("任务状态", selection: $editedTask.status) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
        .navigationTitle(isNew ? "新建任务" : "编辑任务")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("取消") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isNew ? "创建" : "保存") {
                    onSave(editedTask)
                    dismiss()
                }
                .disabled(editedTask.title.isEmpty)
            }
        }
    }
}

#Preview {
    TaskEditView(task: Task(
        title: "前期筹备",
        date: Date(),
        assignee: "张三",
        status: .pending,
        projectId: UUID()
    ), isNew: true) { task in
        // This closure is called when the task is saved
    }
} 