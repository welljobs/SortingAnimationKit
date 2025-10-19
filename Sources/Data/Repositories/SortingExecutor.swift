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
        guard !isExecuting else {
            throw SortingError.sortingInProgress
        }
        
        isExecuting = true
        isPaused = false
        isStopped = false
        
        defer {
            isExecuting = false
        }
        
        // 获取算法实例
        let algorithmInstance = algorithmFactory.getAlgorithm(for: algorithm)
        currentAlgorithm = algorithmInstance
        
        // 执行排序
        let steps = try await algorithmInstance.sort(array, animationSpeed: animationSpeed)
        
        if isStopped {
            throw SortingError.sortingStopped
        }
        
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
