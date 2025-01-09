import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var task: Task
    let isNewTask: Bool
    
    @State private var editedTitle: String
    @State private var editedDate: Date
    @State private var editedAssignee: String
    @State private var editedStatus: TaskStatus
    
    init(task: Binding<Task>, isNewTask: Bool = false) {
        self._task = task
        self.isNewTask = isNewTask
        _editedTitle = State(initialValue: task.wrappedValue.title)
        _editedDate = State(initialValue: task.wrappedValue.date)
        _editedAssignee = State(initialValue: task.wrappedValue.assignee)
        _editedStatus = State(initialValue: task.wrappedValue.status)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("任务信息")) {
                    TextField("任务名称", text: $editedTitle)
                    DatePicker("截止日期", selection: $editedDate, displayedComponents: .date)
                }
                
                Section(header: Text("负责人")) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        TextField("负责人", text: $editedAssignee)
                    }
                }
                
                Section(header: Text("状态")) {
                    Picker("任务状态", selection: $editedStatus) {
                        Text("待处理").tag(TaskStatus.pending)
                        Text("进行中").tag(TaskStatus.inProgress)
                        Text("已完成").tag(TaskStatus.completed)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle(isNewTask ? "新建任务" : "编辑任务")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isNewTask ? "创建" : "保存") {
                        saveChanges()
                        dismiss()
                    }
                    .disabled(editedTitle.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        task.title = editedTitle
        task.date = editedDate
        task.assignee = editedAssignee
        task.status = editedStatus
    }
}

#Preview {
    TaskEditView(task: .constant(Task(
        title: "前期筹备",
        date: Date(),
        assignee: "张三",
        status: .inProgress
    )))
} 