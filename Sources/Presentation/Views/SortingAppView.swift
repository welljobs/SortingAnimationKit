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
        VStack(spacing: 0) {
            // 应用标题栏
            appTitleBar
            
            // 主内容区域
            mainContentView
            
            // 底部导航栏
            bottomNavigationBar
        }
        .background(Color(.systemGray6))
        .sheet(isPresented: $coordinator.showAlgorithmDetail) {
            AlgorithmDetailView(algorithm: coordinator.selectedAlgorithm)
        }
        .sheet(isPresented: $coordinator.showSettings) {
            SettingsView(viewModel: viewModel, coordinator: coordinator)
        }
    }
    
    // MARK: - App Title Bar
    
    private var appTitleBar: some View {
        HStack {
            Text("排序动画演示")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("SortingAnimationKit")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.separator)),
            alignment: .bottom
        )
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
        .background(Color(.systemGray6))
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
    @State private var tempArraySize: Int
    @State private var tempAnimationSpeed: Int
    @State private var tempAlgorithm: SortingAlgorithm
    
    init(viewModel: SortingViewModel, coordinator: SortingCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self._tempArraySize = State(initialValue: viewModel.arraySize)
        self._tempAnimationSpeed = State(initialValue: viewModel.animationSpeed)
        self._tempAlgorithm = State(initialValue: viewModel.currentAlgorithm)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            HStack {
                Button("取消") {
                    dismiss()
                }
                .foregroundColor(.red)
                
                Spacer()
                
                Text("设置")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button("保存") {
                    saveSettings()
                    dismiss()
                }
                .foregroundColor(.blue)
                .fontWeight(.medium)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(.separator)),
                alignment: .bottom
            )
            
            // 设置内容
            ScrollView {
                VStack(spacing: 24) {
                    // 排序设置卡片
                    SettingsCard(title: "排序设置", icon: "slider.horizontal.3") {
                        VStack(spacing: 16) {
                            SettingRow(
                                title: "数组大小",
                                subtitle: "控制排序元素的数量",
                                value: "\(tempArraySize)",
                                range: 5...50,
                                binding: $tempArraySize
                            )
                            
                            SettingRow(
                                title: "动画速度",
                                subtitle: "控制排序动画的播放速度",
                                value: "\(tempAnimationSpeed)ms",
                                range: 100...2000,
                                step: 100,
                                binding: $tempAnimationSpeed
                            )
                        }
                    }
                    
                    // 算法设置卡片
                    SettingsCard(title: "算法设置", icon: "brain.head.profile") {
                        VStack(spacing: 12) {
                            HStack {
                                Text("默认算法")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            Picker("算法", selection: $tempAlgorithm) {
                                ForEach(SortingAlgorithm.allCases) { algorithm in
                                    Text(algorithm.displayName).tag(algorithm)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    
                    // 关于卡片
                    SettingsCard(title: "关于", icon: "info.circle") {
                        VStack(spacing: 12) {
                            AboutRow(title: "版本", value: "1.0.0")
                            AboutRow(title: "开发者", value: "SortingAnimationKit")
                            AboutRow(title: "平台", value: "macOS")
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .background(Color(.systemGray6))
        .frame(width: 400, height: 500)
    }
    
    private func saveSettings() {
        viewModel.arraySize = tempArraySize
        viewModel.animationSpeed = tempAnimationSpeed
        viewModel.currentAlgorithm = tempAlgorithm
    }
}

/// 设置卡片
struct SettingsCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title3)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

/// 设置行
struct SettingRow: View {
    let title: String
    let subtitle: String
    let value: String
    let range: ClosedRange<Int>
    let step: Int
    @Binding var binding: Int
    
    init(title: String, subtitle: String, value: String, range: ClosedRange<Int>, step: Int = 1, binding: Binding<Int>) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.range = range
        self.step = step
        self._binding = binding
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
            }
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text("\(range.lowerBound)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Slider(value: Binding(
                    get: { Double(binding) },
                    set: { binding = Int($0) }
                ), in: Double(range.lowerBound)...Double(range.upperBound), step: Double(step))
                
                Text("\(range.upperBound)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

/// 关于行
struct AboutRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
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
        .background(Color(.systemGray6))
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
