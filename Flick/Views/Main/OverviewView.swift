import SwiftUI

struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var deadline: Date
    var assignee: String
    var status: String
}

struct OverviewView: View {
    @State private var selectedDate = Date()
    @State private var todos: [TodoItem] = [
        TodoItem(
            title: "期筹备",
            deadline: Date(),
            assignee: "张三",
            status: "进行中"
        )
    ]
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 当前日期显示
                Text(dateFormatter.string(from: selectedDate))
                    .font(.system(size: 32, weight: .bold))
                    .padding(.horizontal)
                
                Text("Jan 2025")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                // 日历网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    // 星期标题
                    ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) { weekday in
                        Text(weekday)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // 日期格子
                    ForEach(1...31, id: \.self) { day in
                        if day <= calendar.range(of: .day, in: .month, for: selectedDate)?.count ?? 0 {
                            DateCell(
                                day: day,
                                isSelected: calendar.component(.day, from: selectedDate) == day,
                                hasEvent: [8, 9, 11].contains(day)
                            )
                        } else {
                            Color.clear
                                .frame(height: 40)
                        }
                    }
                }
                .padding(.horizontal)
                
                // 待办事项
                VStack(alignment: .leading, spacing: 12) {
                    Text("待办事项")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    ForEach(todos) { todo in
                        TodoItemView(todo: todo)
                    }
                }
            }
        }
        .navigationTitle("总览")
    }
}

struct DateCell: View {
    let day: Int
    let isSelected: Bool
    let hasEvent: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.blue : Color(.systemGray6))
            
            VStack(spacing: 4) {
                Text("\(day)")
                    .foregroundColor(isSelected ? .white : .primary)
                
                if hasEvent {
                    Circle()
                        .fill(isSelected ? .white : .blue)
                        .frame(width: 4, height: 4)
                }
            }
        }
        .frame(height: 40)
    }
}

struct TodoItemView: View {
    let todo: TodoItem
    
    var body: some View {
        HStack {
            Circle()
                .stroke(Color.gray, lineWidth: 1.5)
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("截止日期：\(todo.deadline, style: .date)")
                        .font(.caption)
                    
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    Text(todo.assignee)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Text(todo.status)
                .font(.caption)
                .foregroundColor(.orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        OverviewView()
    }
}
