import SwiftUI

struct NewProjectView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var projectManager = ProjectManager.shared
    
    @State private var projectName = ""
    @State private var startDate = Date()
    @State private var director = ""
    @State private var producer = ""
    @State private var selectedColor = Color.blue
    
    private let colors: [Color] = [.blue, .red, .green, .yellow, .purple, .orange]
    
    var body: some View {
        NavigationView {
            Form {
                Section("项目信息") {
                    TextField("项目名称", text: $projectName)
                        .textInputAutocapitalization(.never)
                }
                
                Section("可选信息") {
                    DatePicker("开始日期", selection: $startDate, displayedComponents: .date)
                    TextField("导演", text: $director)
                    TextField("制片人", text: $producer)
                }
                
                Section("项目颜色") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColor == color ? 2 : 0)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
            }
            .navigationTitle("新建项目")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("创建") {
                        createProject()
                        dismiss()
                    }
                    .disabled(projectName.isEmpty)
                }
            }
        }
    }
    
    private func createProject() {
        let project = Project(
            name: projectName,
            startDate: startDate,
            director: director,
            producer: producer,
            color: selectedColor
        )
        projectManager.addProject(project)
    }
} 