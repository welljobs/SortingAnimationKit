import Foundation

/// 排序算法仓库协议
/// 定义了排序算法相关的数据访问接口
public protocol SortingRepositoryProtocol {
    /// 生成随机数组
    /// - Parameter size: 数组大小
    /// - Returns: 随机整数数组
    func generateRandomArray(size: Int) async throws -> [Int]
    
    /// 生成指定范围的随机数组
    /// - Parameters:
    ///   - size: 数组大小
    ///   - min: 最小值
    ///   - max: 最大值
    /// - Returns: 随机整数数组
    func generateRandomArray(size: Int, min: Int, max: Int) async throws -> [Int]
    
    /// 生成已排序数组
    /// - Parameter size: 数组大小
    /// - Returns: 已排序的整数数组
    func generateSortedArray(size: Int) async throws -> [Int]
    
    /// 生成逆序数组
    /// - Parameter size: 数组大小
    /// - Returns: 逆序的整数数组
    func generateReversedArray(size: Int) async throws -> [Int]
    
    /// 生成部分排序数组
    /// - Parameter size: 数组大小
    /// - Returns: 部分排序的整数数组
    func generatePartiallySortedArray(size: Int) async throws -> [Int]
    
    /// 保存排序步骤
    /// - Parameter steps: 排序步骤数组
    func saveSortingSteps(_ steps: [SortingStep]) async throws
    
    /// 加载排序步骤
    /// - Returns: 排序步骤数组
    func loadSortingSteps() async throws -> [SortingStep]
    
    /// 清除所有保存的排序步骤
    func clearSortingSteps() async throws
}

/// 排序算法执行器协议
/// 定义了排序算法的执行接口
public protocol SortingExecutorProtocol {
    /// 执行排序算法
    /// - Parameters:
    ///   - algorithm: 排序算法类型
    ///   - array: 待排序数组
    ///   - animationSpeed: 动画速度（毫秒）
    /// - Returns: 排序步骤数组
    func executeSorting(
        algorithm: SortingAlgorithm,
        array: [Int],
        animationSpeed: Int
    ) async throws -> [SortingStep]
    
    /// 停止当前排序
    func stopSorting() async
    
    /// 暂停排序
    func pauseSorting() async
    
    /// 恢复排序
    func resumeSorting() async
    
    /// 重置排序状态
    func resetSorting() async
}
