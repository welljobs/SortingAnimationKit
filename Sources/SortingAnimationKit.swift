import Foundation

/// SortingAnimationKit 主入口文件
/// 提供库的主要公共接口

// MARK: - 公共类型重导出
// 注意：由于这是主模块文件，不需要重新导入自己的类型
// 所有类型都会自动可用

/// SortingAnimationKit 版本信息
public struct SortingAnimationKitInfo {
    /// 库版本
    public static let version = "1.0.0"
    
    /// 库名称
    public static let name = "SortingAnimationKit"
    
    /// 库描述
    public static let description = "A SwiftUI-based sorting algorithm animation library with Clean Architecture"
    
    /// 支持的iOS版本
    public static let minimumIOSVersion = "15.0"
    
    /// 支持的macOS版本
    public static let minimumMacOSVersion = "13.0"
}

/// 快速创建排序动画应用的便捷方法
public struct SortingAnimationKit {
    
    /// 创建默认的排序动画应用
    /// - Returns: 配置好的SortingAppView实例
    public static func createApp() -> SortingAppView {
        return SortingAppView()
    }
    
    /// 创建自定义的排序动画视图
    /// - Parameters:
    ///   - algorithm: 默认排序算法
    ///   - arraySize: 默认数组大小
    ///   - animationSpeed: 默认动画速度
    /// - Returns: 配置好的SortingAnimationView实例
    @MainActor
    public static func createAnimationView(
        algorithm: SortingAlgorithm = .bubbleSort,
        arraySize: Int = 20,
        animationSpeed: Int = 500
    ) -> SortingAnimationView {
        // 创建依赖
        let repository = SortingRepository()
        let executor = SortingExecutor()
        let generateUseCase = GenerateArrayUseCase(repository: repository)
        let executeUseCase = ExecuteSortingUseCase(repository: repository, executor: executor)
        
        // 创建视图模型和协调器
        let viewModel = SortingViewModel(
            generateArrayUseCase: generateUseCase,
            executeSortingUseCase: executeUseCase
        )
        let coordinator = SortingCoordinator()
        
        // 设置默认值
        viewModel.setAlgorithm(algorithm)
        viewModel.setArraySize(arraySize)
        viewModel.setAnimationSpeed(animationSpeed)
        
        return SortingAnimationView(viewModel: viewModel, coordinator: coordinator)
    }
    
    /// 获取所有支持的排序算法
    /// - Returns: 所有排序算法数组
    public static func getAllAlgorithms() -> [SortingAlgorithm] {
        return SortingAlgorithmFactory.shared.getAllAlgorithms()
    }
    
    /// 获取比较排序算法
    /// - Returns: 比较排序算法数组
    public static func getComparisonAlgorithms() -> [SortingAlgorithm] {
        return SortingAlgorithmFactory.shared.getComparisonAlgorithms()
    }
    
    /// 获取非比较排序算法
    /// - Returns: 非比较排序算法数组
    public static func getNonComparisonAlgorithms() -> [SortingAlgorithm] {
        return SortingAlgorithmFactory.shared.getNonComparisonAlgorithms()
    }
}
