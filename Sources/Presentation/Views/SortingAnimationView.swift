import SwiftUI

/// 排序动画视图
/// 显示排序过程的动画效果
public struct SortingAnimationView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: SortingViewModel
    @StateObject private var coordinator: SortingCoordinator
    
    // MARK: - Initialization
    
    public init(
        viewModel: SortingViewModel,
        coordinator: SortingCoordinator
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._coordinator = StateObject(wrappedValue: coordinator)
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 20) {
            // 标题和控制按钮
            headerView
            
            // 排序元素显示区域
            sortingElementsView
            
            // 控制面板
            controlPanelView
            
            // 统计信息
            statisticsView
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .onAppear {
            viewModel.generateRandomArray()
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Text("排序动画演示")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("当前算法: \(viewModel.currentAlgorithm.displayName)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // 控制按钮
            HStack(spacing: 15) {
                Button(action: {
                    if viewModel.isSorting {
                        if viewModel.isPaused {
                            viewModel.resumeSorting()
                        } else {
                            viewModel.pauseSorting()
                        }
                    } else {
                        viewModel.startSorting()
                    }
                }) {
                    HStack {
                        Image(systemName: viewModel.isSorting ? (viewModel.isPaused ? "play.fill" : "pause.fill") : "play.fill")
                        Text(viewModel.isSorting ? (viewModel.isPaused ? "继续" : "暂停") : "开始")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(viewModel.isSorting ? (viewModel.isPaused ? Color.green : Color.orange) : Color.blue)
                    .cornerRadius(8)
                }
                .disabled(viewModel.elements.isEmpty)
                
                Button("停止") {
                    viewModel.stopSorting()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.red)
                .cornerRadius(8)
                .disabled(!viewModel.isSorting)
                
                Button("重置") {
                    viewModel.resetSorting()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.gray)
                .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Sorting Elements View
    
    private var sortingElementsView: some View {
        VStack(spacing: 10) {
            Text("排序过程")
                .font(.headline)
            
            // 元素显示区域
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(viewModel.elements) { element in
                    VStack(spacing: 4) {
                        // 元素值
                        Text("\(element.value)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        // 元素条
                        Rectangle()
                            .fill(elementColor(for: element))
                            .frame(width: 20, height: CGFloat(element.value) * 3)
                            .cornerRadius(2)
                            .animation(.easeInOut(duration: 0.3), value: element.state)
                    }
                }
            }
            .frame(height: 200)
            .padding()
            .background(Color(NSColor.controlColor))
            .cornerRadius(10)
        }
    }
    
    // MARK: - Control Panel View
    
    private var controlPanelView: some View {
        VStack(spacing: 15) {
            Text("控制面板")
                .font(.headline)
            
            // 算法选择
            HStack {
                Text("算法:")
                    .font(.subheadline)
                    .frame(width: 60, alignment: .leading)
                
                Picker("算法", selection: $viewModel.currentAlgorithm) {
                    ForEach(SortingAlgorithm.allCases) { algorithm in
                        Text(algorithm.displayName).tag(algorithm)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewModel.currentAlgorithm) { _ in
                    viewModel.setAlgorithm(viewModel.currentAlgorithm)
                }
            }
            
            // 数组大小
            HStack {
                Text("大小:")
                    .font(.subheadline)
                    .frame(width: 60, alignment: .leading)
                
                Slider(value: Binding(
                    get: { Double(viewModel.arraySize) },
                    set: { viewModel.setArraySize(Int($0)) }
                ), in: 5...50, step: 1)
                
                Text("\(viewModel.arraySize)")
                    .font(.subheadline)
                    .frame(width: 30)
            }
            
            // 动画速度
            HStack {
                Text("速度:")
                    .font(.subheadline)
                    .frame(width: 60, alignment: .leading)
                
                Slider(value: Binding(
                    get: { Double(viewModel.animationSpeed) },
                    set: { viewModel.setAnimationSpeed(Int($0)) }
                ), in: 100...2000, step: 100)
                
                Text("\(viewModel.animationSpeed)ms")
                    .font(.subheadline)
                    .frame(width: 60)
            }
            
            // 数组生成按钮
            HStack(spacing: 10) {
                Button("随机") {
                    viewModel.generateRandomArray()
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("已排序") {
                    viewModel.generateSortedArray()
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("逆序") {
                    viewModel.generateReversedArray()
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("部分排序") {
                    viewModel.generatePartiallySortedArray()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
        .padding()
        .background(Color(NSColor.controlColor))
        .cornerRadius(10)
    }
    
    // MARK: - Statistics View
    
    private var statisticsView: some View {
        VStack(spacing: 10) {
            Text("统计信息")
                .font(.headline)
            
            HStack(spacing: 20) {
                StatisticItem(
                    title: "比较次数",
                    value: "\(viewModel.statistics.comparisonCount)",
                    color: .blue
                )
                
                StatisticItem(
                    title: "交换次数",
                    value: "\(viewModel.statistics.swapCount)",
                    color: .red
                )
                
                StatisticItem(
                    title: "移动次数",
                    value: "\(viewModel.statistics.moveCount)",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(NSColor.controlColor))
        .cornerRadius(10)
    }
    
    // MARK: - Helper Methods
    
    private func elementColor(for element: SortingElement) -> Color {
        switch element.state {
        case .normal:
            return .blue
        case .comparing:
            return .yellow
        case .swapping:
            return .red
        case .sorted:
            return .green
        case .pivot:
            return .purple
        case .min:
            return .orange
        case .max:
            return .pink
        }
    }
}

// MARK: - Supporting Views

/// 统计信息项
struct StatisticItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

/// 次要按钮样式
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue)
            .cornerRadius(6)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview

#if DEBUG
struct SortingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = SortingRepository()
        let executor = SortingExecutor()
        let generateUseCase = GenerateArrayUseCase(repository: repository)
        let executeUseCase = ExecuteSortingUseCase(repository: repository, executor: executor)
        let viewModel = SortingViewModel(generateArrayUseCase: generateUseCase, executeSortingUseCase: executeUseCase)
        let coordinator = SortingCoordinator()
        
        SortingAnimationView(viewModel: viewModel, coordinator: coordinator)
    }
}
#endif
