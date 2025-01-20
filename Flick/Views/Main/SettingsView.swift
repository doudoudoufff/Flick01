import SwiftUI

struct UserProfile {
    var name: String
    var role: String
    var department: String
}

struct SettingsView: View {
    @State private var userProfile = UserProfile(
        name: "豆",
        role: "制片主管",
        department: "制作部"
    )
    
    @State private var showCompletedTasks = true
    @State private var projectColor = Color.blue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 标题
            Text("设置")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            List {
                // 用户信息部分
                NavigationLink {
                    Text("用户资料编辑页面")
                } label: {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userProfile.name)
                                .font(.headline)
                            Text("\(userProfile.role) · \(userProfile.department)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                
                // 应用偏好
                Section {
                    NavigationLink {
                        Text("外观设置")
                    } label: {
                        SettingRow(icon: "paintbrush.fill", iconColor: .purple, title: "外观")
                    }
                    
                    NavigationLink {
                        Text("通知设置")
                    } label: {
                        SettingRow(icon: "bell.fill", iconColor: .red, title: "通知")
                    }
                    
                    NavigationLink {
                        Text("数据管理")
                    } label: {
                        SettingRow(icon: "externaldrive.fill", iconColor: .green, title: "数据管理")
                    }
                } header: {
                    Text("应用偏好")
                }
                
                // 项目默认设置
                Section {
                    Toggle("显示已完成任务", isOn: $showCompletedTasks)
                    
                    HStack {
                        Text("默认项目颜色")
                        Spacer()
                        ColorPicker("", selection: $projectColor)
                    }
                } header: {
                    Text("项目默认设置")
                }
                
                // 关于
                Section {
                    NavigationLink {
                        Text("致谢页面")
                    } label: {
                        SettingRow(icon: "star.fill", iconColor: .blue, title: "致谢")
                    }
                    
                    NavigationLink {
                        Text("许可证页面")
                    } label: {
                        SettingRow(icon: "doc.fill", iconColor: .blue, title: "许可证")
                    }
                    
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.1")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("关于")
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SettingRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24)
            Text(title)
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
