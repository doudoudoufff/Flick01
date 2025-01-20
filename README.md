# Flick

Flick 是一个专门为影视项目管理设计的 iOS 应用，使用 SwiftUI 开发，帮助制片团队更好地管理项目进度和任务分配。

## 功能特点

### 总览
- 日历视图：直观展示项目时间线
- 待办事项：快速查看和管理任务
- 项目进度：实时跟踪项目完成情况

### 项目管理
- 项目创建：快速创建新项目
- 任务分配：为团队成员分配具体任务
- 进度追踪：实时监控项目和任务状态
- 团队协作：支持多角色协同工作

### 设置
- 个人资料管理
- 应用偏好设置
- 项目默认配置

## 技术栈

- SwiftUI
- MVVM 架构
- Combine 框架
- iOS 16.0+

## 项目结构 
Flick/
├── Models/
│ ├── Core/
│ │ ├── Project.swift
│ │ └── Task.swift
│ └── Enums/
│ └── TaskStatus.swift
├── ViewModels/
│ └── Managers/
│ ├── ProjectManager.swift
│ └── TaskManager.swift
├── Views/
│ ├── Main/
│ │ ├── ContentView.swift
│ │ ├── OverviewView.swift
│ │ ├── ProjectView.swift
│ │ └── SettingsView.swift
│ └── Project/
│ ├── Detail/
│ │ ├── ProjectDetailView.swift
│ │ └── TaskEditView.swift
│ ├── Edit/
│ │ └── ProjectEditView.swift
│ └── New/
│ └── NewProjectView.swift
└── FlickApp.swift

