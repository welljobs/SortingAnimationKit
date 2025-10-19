import Foundation
import SwiftUI

/// 排序元素实体
/// 表示排序过程中的单个数据元素，包含值和状态信息
public struct SortingElement: Identifiable, Equatable, Codable {
    /// 唯一标识符
    public var id = UUID()
    
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
    
    /// 元素的随机颜色（用于区分不同元素）
    public let randomColor: ElementColor
    
    public init(value: Int, position: Int, state: ElementState = .normal, randomColor: ElementColor? = nil) {
        self.value = value
        self.position = position
        self.state = state
        self.randomColor = randomColor ?? ElementColor.random()
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

/// 元素颜色枚举
public enum ElementColor: String, CaseIterable, Codable {
    case red
    case blue
    case green
    case orange
    case purple
    case pink
    case yellow
    case cyan
    case magenta
    case brown
    case indigo
    case teal
    
    /// 生成随机颜色
    public static func random() -> ElementColor {
        let allColors = ElementColor.allCases
        return allColors.randomElement() ?? .blue
    }
    
    /// 转换为SwiftUI Color
    public var swiftUIColor: Color {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .orange:
            return .orange
        case .purple:
            return .purple
        case .pink:
            return .pink
        case .yellow:
            return .yellow
        case .cyan:
            return .cyan
        case .magenta:
            return .pink
        case .brown:
            return .brown
        case .indigo:
            return .indigo
        case .teal:
            return .teal
        }
    }
}

/// 排序步骤实体
/// 表示排序过程中的一个步骤，用于动画回放
public struct SortingStep: Identifiable, Codable {
    public var id = UUID()
    
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
