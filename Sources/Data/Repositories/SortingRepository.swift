import Foundation

/// 排序算法仓库实现
/// 负责数据访问和持久化
public class SortingRepository: SortingRepositoryProtocol {
    
    /// 用户默认设置
    private let userDefaults = UserDefaults.standard
    
    /// 排序步骤存储键
    private let sortingStepsKey = "SortingAnimationKit.SortingSteps"
    
    public init() {}
    
    // MARK: - 数组生成方法
    
    public func generateRandomArray(size: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                let array = (0..<size).map { _ in Int.random(in: 1...100) }
                continuation.resume(returning: array)
            }
        }
    }
    
    public func generateRandomArray(size: Int, min: Int, max: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        
        guard min <= max else {
            throw SortingError.invalidRange
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                let array = (0..<size).map { _ in Int.random(in: min...max) }
                continuation.resume(returning: array)
            }
        }
    }
    
    public func generateSortedArray(size: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                let array = (1...size).map { $0 }
                continuation.resume(returning: array)
            }
        }
    }
    
    public func generateReversedArray(size: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                let array = (1...size).reversed().map { $0 }
                continuation.resume(returning: array)
            }
        }
    }
    
    public func generatePartiallySortedArray(size: Int) async throws -> [Int] {
        guard size > 0 else {
            throw SortingError.invalidArraySize
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                var array = (1...size).map { $0 }
                
                // 随机交换一些元素
                let swapCount = size / 4
                for _ in 0..<swapCount {
                    let i = Int.random(in: 0..<size)
                    let j = Int.random(in: 0..<size)
                    array.swapAt(i, j)
                }
                
                continuation.resume(returning: array)
            }
        }
    }
    
    // MARK: - 排序步骤持久化
    
    public func saveSortingSteps(_ steps: [SortingStep]) async throws {
        do {
            let data = try JSONEncoder().encode(steps)
            userDefaults.set(data, forKey: sortingStepsKey)
        } catch {
            throw SortingError.repositoryError("保存排序步骤失败: \(error.localizedDescription)")
        }
    }
    
    public func loadSortingSteps() async throws -> [SortingStep] {
        guard let data = userDefaults.data(forKey: sortingStepsKey) else {
            return []
        }
        
        do {
            let steps = try JSONDecoder().decode([SortingStep].self, from: data)
            return steps
        } catch {
            throw SortingError.repositoryError("加载排序步骤失败: \(error.localizedDescription)")
        }
    }
    
    public func clearSortingSteps() async throws {
        userDefaults.removeObject(forKey: sortingStepsKey)
    }
}




