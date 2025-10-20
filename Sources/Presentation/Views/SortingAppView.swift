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
        TabView(selection: $coordinator.currentView) {
            // 主页
            SortingAnimationView(viewModel: viewModel, coordinator: coordinator)
                .tabItem {
                    Label("主页", systemImage: "house.fill")
                }
                .tag(SortingViewType.main)
            
            // 算法列表
            AlgorithmListView(coordinator: coordinator)
                .tabItem {
                    Label("算法", systemImage: "list.bullet")
                }
                .tag(SortingViewType.algorithmList)
            
            // 统计页面
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Label("统计", systemImage: "chart.bar.fill")
                }
                .tag(SortingViewType.statistics)
            
            // 设置页面
            SettingsView(viewModel: viewModel, coordinator: coordinator)
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
                .tag(SortingViewType.settings)
        }
        .sheet(isPresented: $coordinator.showAlgorithmDetail) {
            AlgorithmDetailView(algorithm: coordinator.selectedAlgorithm)
        }
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
        #if os(iOS)
        NavigationStack {
            Form {
                Section("排序设置") {
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
                
                Section("算法设置") {
                    Picker("默认算法", selection: $tempAlgorithm) {
                        ForEach(SortingAlgorithm.allCases) { algorithm in
                            Text(algorithm.displayName).tag(algorithm)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("关于") {
                    AboutRow(title: "版本", value: "1.0.0")
                    AboutRow(title: "开发者", value: "SortingAnimationKit")
                    AboutRow(title: "平台", value: "iOS")
                }
            }
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                        .foregroundColor(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { saveSettings(); dismiss() }
                        .fontWeight(.medium)
                }
            }
        }
        #else
        VStack(spacing: 0) {
            // 设置内容（macOS）
            ScrollView {
                VStack(spacing: 16) {
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
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 8)
        }
        .background(Color.platformBackground)
        #endif
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
        .padding(16)
        .background(Color.platformBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.platformSeparator, lineWidth: 1)
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
        .background(Color.platformBackground)
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
