import SwiftUI

struct ProjectView: View {
    @StateObject private var projectManager = ProjectManager.shared
    @State private var searchText = ""
    @State private var selectedProject: Project?
    @State private var showNewProject = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 标题和添加按钮
            HStack {
                Text("项目")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button {
                    showNewProject = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // 搜索栏
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("搜索项目或任务", text: $searchText)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding()
            
            if projectManager.projects.isEmpty {
                // 空状态视图
                VStack(spacing: 16) {
                    Image(systemName: "folder.badge.plus")
                        .font(.system(size: 64))
                        .foregroundColor(.gray)
                    Text("还没有项目")
                        .font(.headline)
                    Text("点击右上角的加号创建新项目")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            } else {
                // 项目列表
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(projectManager.projects) { project in
                            ProjectCard(project: project, dateFormatter: dateFormatter)
                                .onTapGesture {
                                    selectedProject = project
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showNewProject) {
            NewProjectView()
        }
        .navigationDestination(item: $selectedProject) { project in
            ProjectDetailView(
                project: Binding(
                    get: { project },
                    set: { newValue in
                        projectManager.updateProject(newValue)
                        selectedProject = newValue
                    }
                )
            )
        }
    }
}

struct ProjectCard: View {
    let project: Project
    let dateFormatter: DateFormatter
    
    private var progressPercentage: Int {
        guard project.totalTasks > 0 else { return 0 }
        return Int((Double(project.completedTasks) / Double(project.totalTasks)) * 100)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 项目标题和进度
            HStack {
                Circle()
                    .fill(project.color)
                    .frame(width: 12, height: 12)
                Text(project.name)
                    .font(.headline)
                Spacer()
                Text("\(progressPercentage)%")
                    .font(.subheadline)
                    .foregroundColor(project.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(project.color.opacity(0.1))
                    .cornerRadius(4)
            }
            
            // 日期和任务进度
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text(dateFormatter.string(from: project.startDate))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: "checklist")
                    .foregroundColor(.gray)
                Text("\(project.completedTasks)/\(project.totalTasks)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Divider()
            
            // 团队成员
            HStack(spacing: 16) {
                HStack {
                    Image(systemName: "video.fill")
                        .foregroundColor(.gray)
                    Text(project.director)
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.gray)
                    Text(project.creator)
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.gray)
                    Text(project.producer)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(project.color.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        ProjectView()
    }
}
