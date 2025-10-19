import Foundation

/// 生成数组用例
/// 负责生成各种类型的数组用于排序演示
public class GenerateArrayUseCase {
    private let repository: SortingRepositoryProtocol
    
    public init(repository: SortingRepositoryProtocol) {
        self.repository = repository
    }
    
    /// 生成随机数组
    /// - Parameter size: 数组大小
    /// - Returns: 随机整数数组
    public func generateRandomArray(size: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        return try await repository.generateRandomArray(size: size)
    }
    
    /// 生成指定范围的随机数组
    /// - Parameters:
    ///   - size: 数组大小
    ///   - min: 最小值
    ///   - max: 最大值
    /// - Returns: 随机整数数组
    public func generateRandomArray(size: Int, min: Int, max: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        guard min <= max else {
            throw SortingError.invalidRange
        }
        return try await repository.generateRandomArray(size: size, min: min, max: max)
    }
    
    /// 生成已排序数组
    /// - Parameter size: 数组大小
    /// - Returns: 已排序的整数数组
    public func generateSortedArray(size: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        return try await repository.generateSortedArray(size: size)
    }
    
    /// 生成逆序数组
    /// - Parameter size: 数组大小
    /// - Returns: 逆序的整数数组
    public func generateReversedArray(size: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        return try await repository.generateReversedArray(size: size)
    }
    
    /// 生成部分排序数组
    /// - Parameter size: 数组大小
    /// - Returns: 部分排序的整数数组
    public func generatePartiallySortedArray(size: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        return try await repository.generatePartiallySortedArray(size: size)
    }
}

/// 排序执行用例
/// 负责执行排序算法并生成动画步骤
public class ExecuteSortingUseCase {
    private let repository: SortingRepositoryProtocol
    private let executor: SortingExecutorProtocol
    
    public init(repository: SortingRepositoryProtocol, executor: SortingExecutorProtocol) {
        self.repository = repository
        self.executor = executor
    }
    
    /// 执行排序算法
    /// - Parameters:
    ///   - algorithm: 排序算法类型
    ///   - array: 待排序数组
    ///   - animationSpeed: 动画速度（毫秒）
    /// - Returns: 排序步骤数组
    public func executeSorting(
        algorithm: SortingAlgorithm,
        array: [Int],
        animationSpeed: Int = 500
    ) async throws -> [SortingStep] {
        let steps = try await executor.executeSorting(
            algorithm: algorithm,
            array: array,
            animationSpeed: animationSpeed
        )
        
        // 保存排序步骤
        try await repository.saveSortingSteps(steps)
        
        return steps
    }
    
    /// 停止当前排序
    public func stopSorting() async {
        await executor.stopSorting()
    }
    
    /// 暂停排序
    public func pauseSorting() async {
        await executor.pauseSorting()
    }
    
    /// 恢复排序
    public func resumeSorting() async {
        await executor.resumeSorting()
    }
    
    /// 重置排序状态
    public func resetSorting() async {
        await executor.resetSorting()
    }
}

/// 排序错误枚举
public enum SortingError: Error, LocalizedError {
    case invalidArraySize
    case invalidRange
    case algorithmNotSupported
    case sortingInProgress
    case sortingStopped
    case repositoryError(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidArraySize:
            return "数组大小必须大于0"
        case .invalidRange:
            return "最小值不能大于最大值"
        case .algorithmNotSupported:
            return "不支持的排序算法"
        case .sortingInProgress:
            return "排序正在进行中"
        case .sortingStopped:
            return "排序已停止"
        case .repositoryError(let message):
            return "仓库错误: \(message)"
        }
    }
}
