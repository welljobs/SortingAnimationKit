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

// MARK: - SortingStep Codable 支持

extension SortingStep: Codable {
    enum CodingKeys: String, CodingKey {
        case id, type, indices, description, array, delay
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(StepType.self, forKey: .type)
        
        let indices = try container.decode([Int].self, forKey: .indices)
        let description = try container.decode(String.self, forKey: .description)
        let array = try container.decode([SortingElement].self, forKey: .array)
        let delay = try container.decode(Int.self, forKey: .delay)
        
        self.init(type: type, indices: indices, description: description, array: array, delay: delay)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(indices, forKey: .indices)
        try container.encode(description, forKey: .description)
        try container.encode(array, forKey: .array)
        try container.encode(delay, forKey: .delay)
    }
}


extension SortingElement: Codable {
    enum CodingKeys: String, CodingKey {
        case id, value, position, state, isComparing, isSwapping, isSorted
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let value = try container.decode(Int.self, forKey: .value)
        let position = try container.decode(Int.self, forKey: .position)
        let state = try container.decode(ElementState.self, forKey: .state)
        let isComparing = try container.decode(Bool.self, forKey: .isComparing)
        let isSwapping = try container.decode(Bool.self, forKey: .isSwapping)
        let isSorted = try container.decode(Bool.self, forKey: .isSorted)
        
        self.init(value: value, position: position, state: state)
        self.isComparing = isComparing
        self.isSwapping = isSwapping
        self.isSorted = isSorted
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(value, forKey: .value)
        try container.encode(position, forKey: .position)
        try container.encode(state.rawValue, forKey: .state)
        try container.encode(isComparing, forKey: .isComparing)
        try container.encode(isSwapping, forKey: .isSwapping)
        try container.encode(isSorted, forKey: .isSorted)
    }
}

