import SwiftUI

/// 排序动画应用主视图
/// 整合所有功能的主界面
public struct SortingAppView: View {
    
    // MARK: - Properties
    
    @StateObject private var coordinator: SortingCoordinator
    @StateObject private var viewModel: SortingViewModel
    
    // MARK: - Initialization
    
    public init() {
        // 创建依赖
        let repository = SortingRepository()
        let executor = SortingExecutor()
        let generateUseCase = GenerateArrayUseCase(repository: repository)
        let executeUseCase = ExecuteSortingUseCase(repository: repository, executor: executor)
        
        // 创建视图模型和协调器
        self._viewModel = StateObject(wrappedValue: SortingViewModel(
            generateArrayUseCase: generateUseCase,
            executeSortingUseCase: executeUseCase
        ))
        self._coordinator = StateObject(wrappedValue: SortingCoordinator())
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 主内容区域
                mainContentView
                
                // 底部导航栏
                bottomNavigationBar
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
        .sheet(isPresented: $coordinator.showAlgorithmDetail) {
            AlgorithmDetailView(algorithm: coordinator.selectedAlgorithm)
        }
        .sheet(isPresented: $coordinator.showSettings) {
            SettingsView(viewModel: viewModel, coordinator: coordinator)
        }
    }
    
    // MARK: - Main Content View
    
    private var mainContentView: some View {
        Group {
            switch coordinator.currentView {
            case .main:
                SortingAnimationView(viewModel: viewModel, coordinator: coordinator)
            case .algorithmList:
                AlgorithmListView(coordinator: coordinator)
            case .statistics:
                StatisticsView(viewModel: viewModel)
            default:
                SortingAnimationView(viewModel: viewModel, coordinator: coordinator)
            }
        }
    }
    
    // MARK: - Bottom Navigation Bar
    
    private var bottomNavigationBar: some View {
        HStack(spacing: 0) {
            NavigationButton(
                icon: "house.fill",
                title: "主页",
                isSelected: coordinator.currentView == .main
            ) {
                coordinator.goToMain()
            }
            
            NavigationButton(
                icon: "list.bullet",
                title: "算法",
                isSelected: coordinator.currentView == .algorithmList
            ) {
                coordinator.navigate(to: .algorithmList)
            }
            
            NavigationButton(
                icon: "chart.bar.fill",
                title: "统计",
                isSelected: coordinator.currentView == .statistics
            ) {
                coordinator.navigate(to: .statistics)
            }
            
            NavigationButton(
                icon: "gear",
                title: "设置",
                isSelected: coordinator.showSettings
            ) {
                coordinator.presentSettings()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(NSColor.controlBackgroundColor))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
    }
}

/// 导航按钮
struct NavigationButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// 设置视图
struct SettingsView: View {
    @ObservedObject var viewModel: SortingViewModel
    @ObservedObject var coordinator: SortingCoordinator
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("排序设置") {
                    HStack {
                        Text("数组大小")
                        Spacer()
                        Stepper(value: $viewModel.arraySize, in: 5...50) {
                            Text("\(viewModel.arraySize)")
                        }
                    }
                    
                    HStack {
                        Text("动画速度")
                        Spacer()
                        Stepper(value: $viewModel.animationSpeed, in: 100...2000, step: 100) {
                            Text("\(viewModel.animationSpeed)ms")
                        }
                    }
                }
                
                Section("算法设置") {
                    Picker("默认算法", selection: $viewModel.currentAlgorithm) {
                        ForEach(SortingAlgorithm.allCases) { algorithm in
                            Text(algorithm.displayName).tag(algorithm)
                        }
                    }
                }
                
                Section("关于") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("开发者")
                        Spacer()
                        Text("SortingAnimationKit")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("设置")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// 统计视图
struct StatisticsView: View {
    @ObservedObject var viewModel: SortingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("排序统计")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                StatisticCard(
                    title: "比较次数",
                    value: "\(viewModel.statistics.comparisonCount)",
                    icon: "arrow.left.arrow.right",
                    color: .blue
                )
                
                StatisticCard(
                    title: "交换次数",
                    value: "\(viewModel.statistics.swapCount)",
                    icon: "arrow.up.arrow.down",
                    color: .red
                )
                
                StatisticCard(
                    title: "移动次数",
                    value: "\(viewModel.statistics.moveCount)",
                    icon: "arrow.right",
                    color: .green
                )
                
                StatisticCard(
                    title: "完成状态",
                    value: viewModel.statistics.isCompleted ? "已完成" : "未完成",
                    icon: viewModel.statistics.isCompleted ? "checkmark.circle.fill" : "circle",
                    color: viewModel.statistics.isCompleted ? .green : .gray
                )
            }
            
            Spacer()
        }
        .padding()
    }
}

/// 统计卡片
struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(NSColor.controlColor))
        .cornerRadius(10)
    }
}

// MARK: - Preview

#if DEBUG
struct SortingAppView_Previews: PreviewProvider {
    static var previews: some View {
        SortingAppView()
    }
}
#endif
