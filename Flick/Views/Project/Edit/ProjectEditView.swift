import SwiftUI

struct ProjectEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var project: Project
    
    @State private var editedName: String
    @State private var editedStartDate: Date
    @State private var editedDirector: String
    @State private var editedCreator: String
    @State private var editedProducer: String
    @State private var editedColor: Color
    
    init(project: Binding<Project>) {
        self._project = project
        _editedName = State(initialValue: project.wrappedValue.name)
        _editedStartDate = State(initialValue: project.wrappedValue.startDate)
        _editedDirector = State(initialValue: project.wrappedValue.director)
        _editedCreator = State(initialValue: project.wrappedValue.creator)
        _editedProducer = State(initialValue: project.wrappedValue.producer)
        _editedColor = State(initialValue: project.wrappedValue.color)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("项目名称", text: $editedName)
                    DatePicker("开始时间", selection: $editedStartDate, displayedComponents: .date)
                }
                
                Section(header: Text("团队成员")) {
                    HStack {
                        Image(systemName: "video.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        TextField("导演", text: $editedDirector)
                    }
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        TextField("制片", text: $editedCreator)
                    }
                    
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        TextField("监制", text: $editedProducer)
                    }
                }
                
                Section(header: Text("外观")) {
                    ColorPicker("项目颜色", selection: $editedColor)
                }
            }
            .navigationTitle("编辑项目")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        project.name = editedName
        project.startDate = editedStartDate
        project.director = editedDirector
        project.creator = editedCreator
        project.producer = editedProducer
        project.color = editedColor
    }
}

#Preview {
    ProjectEditView(project: .constant(Project(
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
