import Foundation

/// 排序元素实体
/// 表示排序过程中的单个数据元素，包含值和状态信息
public struct SortingElement: Identifiable, Equatable {
    /// 唯一标识符
    public let id = UUID()
    
    /// 元素的值
    public let value: Int
    
    /// 元素在数组中的位置
    public var position: Int
    
    /// 元素当前状态（用于动画效果）
    public var state: ElementState
    
    /// 是否正在被比较
    public var isComparing: Bool = false
    
    /// 是否正在被交换
    public var isSwapping: Bool = false
    
    /// 是否已排序完成
    public var isSorted: Bool = false
    
    public init(value: Int, position: Int, state: ElementState = .normal) {
        self.value = value
        self.position = position
        self.state = state
    }
}

/// 元素状态枚举
public enum ElementState: String, CaseIterable, Codable {
    case normal       // 正常状态
    case comparing    // 正在比较
    case swapping     // 正在交换
    case sorted       // 已排序
    case pivot        // 基准元素（快速排序）
    case min          // 最小值（选择排序）
    case max          // 最大值（选择排序）
    
    /// 获取状态对应的颜色
    public var color: String {
        switch self {
        case .normal:
            return "blue"
        case .comparing:
            return "yellow"
        case .swapping:
            return "red"
        case .sorted:
            return "green"
        case .pivot:
            return "purple"
        case .min:
            return "orange"
        case .max:
            return "pink"
        }
    }
}

/// 排序步骤实体
/// 表示排序过程中的一个步骤，用于动画回放
public struct SortingStep: Identifiable {
    public let id = UUID()
    
    /// 步骤类型
    public let type: StepType
    
    /// 涉及的索引
    public let indices: [Int]
    
    /// 步骤描述
    public let description: String
    
    /// 当前数组状态
    public let array: [SortingElement]
    
    /// 延迟时间（毫秒）
    public let delay: Int
    
    public init(type: StepType, indices: [Int], description: String, array: [SortingElement], delay: Int = 500) {
        self.type = type
        self.indices = indices
        self.description = description
        self.array = array
        self.delay = delay
    }
}

/// 步骤类型枚举
public enum StepType: String, CaseIterable, Codable {
    case compare      // 比较操作
    case swap         // 交换操作
    case move         // 移动操作
    case highlight    // 高亮操作
    case sorted       // 排序完成
    case partition    // 分区操作（快速排序）
    case merge        // 合并操作（归并排序）
    case heapify      // 堆化操作（堆排序）
}
