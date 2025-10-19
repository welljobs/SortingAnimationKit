import Foundation

/// 排序算法基类
/// 定义了所有排序算法的通用接口和行为
public protocol SortingAlgorithmBase {
    /// 算法名称
    var name: String { get }
    
    /// 算法类型
    var type: SortingAlgorithm { get }
    
    /// 执行排序算法
    /// - Parameters:
    ///   - array: 待排序数组
    ///   - animationSpeed: 动画速度（毫秒）
    /// - Returns: 排序步骤数组
    func sort(_ array: [Int], animationSpeed: Int) async throws -> [SortingStep]
}

/// 排序算法基类实现
open class BaseSortingAlgorithm: SortingAlgorithmBase {
    public let name: String
    public let type: SortingAlgorithm
    
    /// 是否正在排序
    private var isSorting = false
    
    /// 是否已暂停
    private var isPaused = false
    
    /// 是否已停止
    private var isStopped = false
    
    /// 并发控制actor
    private let sortingActor = SortingStateActor()
    
    public init(name: String, type: SortingAlgorithm) {
        self.name = name
        self.type = type
    }
    
    open func sort(_ array: [Int], animationSpeed: Int) async throws -> [SortingStep] {
        print("🔧 BaseSortingAlgorithm: 开始排序，算法: \(name), 数组大小: \(array.count)")
        
        let canStart = await sortingActor.canStartSorting()
        print("🔧 BaseSortingAlgorithm: 检查是否可以开始排序: \(canStart)")
        
        guard canStart else {
            print("❌ BaseSortingAlgorithm: 排序正在进行中，无法开始")
            throw SortingError.sortingInProgress
        }
        
        print("🔧 BaseSortingAlgorithm: 设置排序状态")
        await sortingActor.startSorting()
        
        defer {
            print("🔧 BaseSortingAlgorithm: 清理排序状态")
            Task {
                await sortingActor.stopSorting()
            }
        }
        
        // 将Int数组转换为SortingElement数组，保持随机颜色
        let elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
        print("🔧 BaseSortingAlgorithm: 转换为SortingElement数组，开始执行具体排序")
        
        let steps = try await performSort(elements, animationSpeed: animationSpeed)
        print("🔧 BaseSortingAlgorithm: 具体排序完成，生成 \(steps.count) 个步骤")
        
        let isStopped = await sortingActor.isStoppedState
        if isStopped {
            print("❌ BaseSortingAlgorithm: 排序被停止")
            throw SortingError.sortingStopped
        }
        
        print("✅ BaseSortingAlgorithm: 排序成功完成")
        return steps
    }
    
    /// 子类需要实现的具体排序逻辑
    open func performSort(_ elements: [SortingElement], animationSpeed: Int) async throws -> [SortingStep] {
        fatalError("子类必须实现 performSort 方法")
    }
    
    /// 停止排序
    public func stopSorting() {
        Task {
            await sortingActor.setStopped(true)
        }
    }
    
    /// 暂停排序
    public func pauseSorting() {
        Task {
            await sortingActor.setPaused(true)
        }
    }
    
    /// 恢复排序
    public func resumeSorting() {
        Task {
            await sortingActor.setPaused(false)
        }
    }
    
    /// 重置排序状态
    public func resetSorting() {
        Task {
            await sortingActor.reset()
        }
    }
    
    /// 等待动画延迟
    /// - Parameter delay: 延迟时间（毫秒）
    func waitForAnimation(delay: Int) async {
        try? await Task.sleep(nanoseconds: UInt64(delay) * 1_000_000)
    }
    
    /// 检查是否应该继续排序
    func shouldContinue() async -> Bool {
        let isStopped = await sortingActor.isStoppedState
        return !isStopped
    }
    
    /// 等待暂停状态结束
    func waitForResume() async {
        while true {
            let isPaused = await sortingActor.isPausedState
            let isStopped = await sortingActor.isStoppedState
            if !isPaused || isStopped {
                break
            }
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }
    }
    
    /// 创建比较步骤
    func createCompareStep(
        array: [SortingElement],
        indices: [Int],
        description: String,
        delay: Int = 500
    ) -> SortingStep {
        return SortingStep(
            type: .compare,
            indices: indices,
            description: description,
            array: array,
            delay: delay
        )
    }
    
    /// 创建交换步骤
    func createSwapStep(
        array: [SortingElement],
        indices: [Int],
        description: String,
        delay: Int = 500
    ) -> SortingStep {
        return SortingStep(
            type: .swap,
            indices: indices,
            description: description,
            array: array,
            delay: delay
        )
    }
    
    /// 创建移动步骤
    func createMoveStep(
        array: [SortingElement],
        indices: [Int],
        description: String,
        delay: Int = 500
    ) -> SortingStep {
        return SortingStep(
            type: .move,
            indices: indices,
            description: description,
            array: array,
            delay: delay
        )
    }
    
    /// 创建高亮步骤
    func createHighlightStep(
        array: [SortingElement],
        indices: [Int],
        description: String,
        delay: Int = 500
    ) -> SortingStep {
        return SortingStep(
            type: .highlight,
            indices: indices,
            description: description,
            array: array,
            delay: delay
        )
    }
    
    /// 创建排序完成步骤
    func createSortedStep(
        array: [SortingElement],
        description: String,
        delay: Int = 1000
    ) -> SortingStep {
        return SortingStep(
            type: .sorted,
            indices: [],
            description: description,
            array: array,
            delay: delay
        )
    }
}

/// 排序状态管理Actor
/// 用于线程安全地管理排序状态
private actor SortingStateActor {
    private var isSorting = false
    private var isPaused = false
    private var isStopped = false
    
    func canStartSorting() -> Bool {
        return !isSorting
    }
    
    func startSorting() {
        isSorting = true
        isPaused = false
        isStopped = false
    }
    
    func stopSorting() {
        isSorting = false
    }
    
    func setPaused(_ paused: Bool) {
        isPaused = paused
    }
    
    func setStopped(_ stopped: Bool) {
        isStopped = stopped
    }
    
    func reset() {
        isSorting = false
        isPaused = false
        isStopped = false
    }
    
    var isSortingState: Bool { isSorting }
    var isPausedState: Bool { isPaused }
    var isStoppedState: Bool { isStopped }
}
