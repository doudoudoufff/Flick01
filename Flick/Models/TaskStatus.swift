import SwiftUI

enum TaskStatus: String, CaseIterable {
    case pending = "未完成"
    case completed = "已完成"
    
    var color: Color {
        switch self {
        case .pending: return .gray
        case .completed: return .green
        }
    }
} 