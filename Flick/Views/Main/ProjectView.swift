import SwiftUI

struct Project: Identifiable {
    let id = UUID()
    var name: String
    var startDate: Date
    var director: String
    var creator: String
    var producer: String
    var color: Color
    var completedTasks: Int
    var totalTasks: Int
}

struct ProjectView: View {
    @State private var searchText = ""
    @State private var selectedProject: Project?
    @State private var projects: [Project] = [
        Project(
            name: "蒙牛 TV",
            startDate: Date(),
            director: "王五",
            creator: "赵六",
            producer: "钱七",
            color: .blue,
            completedTasks: 0,
            totalTasks: 2
        ),
        Project(
            name: "流浪地球",
            startDate: Date(),
            director: "郭帆",
            creator: "王红卫",
            producer: "刘慈欣",
            color: .red,
            completedTasks: 0,
            totalTasks: 2
        )
    ]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
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
            
            // 项目列表
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach($projects) { $project in
                        ProjectCard(project: project, dateFormatter: dateFormatter)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedProject = project
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("项目")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                }
            }
        }
        .background(
            NavigationLink(
                destination: ProjectDetailView(
                    project: selectedProject.map { project in
                        Binding(
                            get: { project },
                            set: { newValue in
                                if let index = projects.firstIndex(where: { $0.id == project.id }) {
                                    projects[index] = newValue
                                }
                            }
                        )
                    } ?? .constant(projects[0])
                ),
                isActive: Binding(
                    get: { selectedProject != nil },
                    set: { if !$0 { selectedProject = nil } }
                )
            ) {
                EmptyView()
            }
        )
    }
}

struct ProjectCard: View {
    let project: Project
    let dateFormatter: DateFormatter
    
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
                Text("\(Int((Float(project.completedTasks) / Float(project.totalTasks)) * 100))%")
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
