import Foundation

/// 排序算法执行器实现
/// 负责执行排序算法并生成动画步骤
public class SortingExecutor: SortingExecutorProtocol {
    
    /// 算法工厂
    private let algorithmFactory: SortingAlgorithmFactory
    
    /// 当前执行的算法
    private var currentAlgorithm: SortingAlgorithmBase?
    
    /// 是否正在执行
    private var isExecuting = false
    
    /// 是否已暂停
    private var isPaused = false
    
    /// 是否已停止
    private var isStopped = false
    
    public init(algorithmFactory: SortingAlgorithmFactory = .shared) {
        self.algorithmFactory = algorithmFactory
    }
    
    public func executeSorting(
        algorithm: SortingAlgorithm,
        array: [Int],
        animationSpeed: Int
    ) async throws -> [SortingStep] {
        print("🔧 SortingExecutor: 开始执行排序，算法: \(algorithm), 数组大小: \(array.count)")
        
        guard !isExecuting else {
            print("❌ SortingExecutor: 排序正在进行中，拒绝重复请求")
            throw SortingError.sortingInProgress
        }
        
        print("🔧 SortingExecutor: 设置执行状态")
        isExecuting = true
        isPaused = false
        isStopped = false
        
        defer {
            print("🔧 SortingExecutor: 重置执行状态")
            isExecuting = false
        }
        
        // 获取算法实例
        let algorithmInstance = algorithmFactory.getAlgorithm(for: algorithm)
        currentAlgorithm = algorithmInstance
        print("🔧 SortingExecutor: 获取算法实例: \(algorithmInstance.name)")
        
        // 执行排序
        print("🔧 SortingExecutor: 开始执行算法")
        let steps = try await algorithmInstance.sort(array, animationSpeed: animationSpeed)
        print("🔧 SortingExecutor: 算法执行完成，生成 \(steps.count) 个步骤")
        
        if isStopped {
            print("❌ SortingExecutor: 排序被停止")
            throw SortingError.sortingStopped
        }
        
        print("✅ SortingExecutor: 排序执行成功")
        return steps
    }
    
    public func stopSorting() async {
        isStopped = true
        isPaused = false
        
        if let algorithm = currentAlgorithm as? BaseSortingAlgorithm {
            algorithm.stopSorting()
        }
    }
    
    public func pauseSorting() async {
        isPaused = true
        
        if let algorithm = currentAlgorithm as? BaseSortingAlgorithm {
            algorithm.pauseSorting()
        }
    }
    
    public func resumeSorting() async {
        isPaused = false
        
        if let algorithm = currentAlgorithm as? BaseSortingAlgorithm {
            algorithm.resumeSorting()
        }
    }
    
    public func resetSorting() async {
        isExecuting = false
        isPaused = false
        isStopped = false
        currentAlgorithm = nil
        
        algorithmFactory.resetAllAlgorithms()
    }
}
