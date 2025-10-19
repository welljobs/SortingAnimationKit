import Foundation
import Combine

/// 排序动画视图模型
/// 负责管理排序动画的状态和逻辑
@MainActor
public class SortingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 当前排序元素数组
    @Published public var elements: [SortingElement] = []
    
    /// 当前排序步骤
    @Published public var currentStep: SortingStep?
    
    /// 排序步骤列表
    @Published public var steps: [SortingStep] = []
    
    /// 当前步骤索引
    @Published public var currentStepIndex: Int = 0
    
    /// 是否正在排序
    @Published public var isSorting: Bool = false
    
    /// 是否已暂停
    @Published public var isPaused: Bool = false
    
    /// 是否已停止
    @Published public var isStopped: Bool = false
    
    /// 当前排序算法
    @Published public var currentAlgorithm: SortingAlgorithm = .bubbleSort
    
    /// 动画速度（毫秒）
    @Published public var animationSpeed: Int = 500
    
    /// 数组大小
    @Published public var arraySize: Int = 20
    
    /// 错误信息
    @Published public var errorMessage: String?
    
    /// 排序统计信息
    @Published public var statistics: SortingStatistics = SortingStatistics()
    
    // MARK: - Private Properties
    
    private let generateArrayUseCase: GenerateArrayUseCase
    private let executeSortingUseCase: ExecuteSortingUseCase
    private var cancellables = Set<AnyCancellable>()
    private var animationTask: Task<Void, Never>?
    
    // MARK: - Initialization
    
    public init(
        generateArrayUseCase: GenerateArrayUseCase,
        executeSortingUseCase: ExecuteSortingUseCase
    ) {
        self.generateArrayUseCase = generateArrayUseCase
        self.executeSortingUseCase = executeSortingUseCase
        
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    /// 生成随机数组
    public func generateRandomArray() {
        Task {
            do {
                let array = try await generateArrayUseCase.generateRandomArray(size: arraySize)
                elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
                resetSortingState()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    /// 生成指定范围的随机数组
    public func generateRandomArray(min: Int, max: Int) {
        Task {
            do {
                let array = try await generateArrayUseCase.generateRandomArray(size: arraySize, min: min, max: max)
                elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
                resetSortingState()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    /// 生成已排序数组
    public func generateSortedArray() {
        Task {
            do {
                let array = try await generateArrayUseCase.generateSortedArray(size: arraySize)
                elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
                resetSortingState()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    /// 生成逆序数组
    public func generateReversedArray() {
        Task {
            do {
                let array = try await generateArrayUseCase.generateReversedArray(size: arraySize)
                elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
                resetSortingState()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    /// 生成部分排序数组
    public func generatePartiallySortedArray() {
        Task {
            do {
                let array = try await generateArrayUseCase.generatePartiallySortedArray(size: arraySize)
                elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
                resetSortingState()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    /// 开始排序
    public func startSorting() {
        guard !isSorting else { return }
        
        Task {
            do {
                isSorting = true
                isPaused = false
                isStopped = false
                errorMessage = nil
                
                let array = elements.map { $0.value }
                let sortingSteps = try await executeSortingUseCase.executeSorting(
                    algorithm: currentAlgorithm,
                    array: array,
                    animationSpeed: animationSpeed
                )
                
                steps = sortingSteps
                currentStepIndex = 0
                
                // 开始播放动画
                await playAnimation()
                
            } catch {
                errorMessage = error.localizedDescription
                isSorting = false
            }
        }
    }
    
    /// 暂停排序
    public func pauseSorting() {
        guard isSorting && !isPaused else { return }
        
        Task {
            await executeSortingUseCase.pauseSorting()
            isPaused = true
            animationTask?.cancel()
        }
    }
    
    /// 恢复排序
    public func resumeSorting() {
        guard isSorting && isPaused else { return }
        
        Task {
            await executeSortingUseCase.resumeSorting()
            isPaused = false
            
            // 继续播放动画
            await playAnimation()
        }
    }
    
    /// 停止排序
    public func stopSorting() {
        guard isSorting else { return }
        
        Task {
            await executeSortingUseCase.stopSorting()
            isSorting = false
            isPaused = false
            isStopped = true
            animationTask?.cancel()
        }
    }
    
    /// 重置排序
    public func resetSorting() {
        Task {
            await executeSortingUseCase.resetSorting()
            resetSortingState()
        }
    }
    
    /// 设置排序算法
    public func setAlgorithm(_ algorithm: SortingAlgorithm) {
        currentAlgorithm = algorithm
        resetSortingState()
    }
    
    /// 设置动画速度
    public func setAnimationSpeed(_ speed: Int) {
        animationSpeed = max(100, min(2000, speed))
    }
    
    /// 设置数组大小
    public func setArraySize(_ size: Int) {
        arraySize = max(5, min(100, size))
        generateRandomArray()
    }
    
    /// 播放动画
    private func playAnimation() async {
        animationTask = Task {
            for (index, step) in steps.enumerated() {
                guard !Task.isCancelled else { break }
                
                currentStep = step
                currentStepIndex = index
                elements = step.array
                
                // 更新统计信息
                updateStatistics(for: step)
                
                // 等待动画延迟
                try? await Task.sleep(nanoseconds: UInt64(step.delay) * 1_000_000)
            }
            
            // 排序完成
            if !Task.isCancelled {
                isSorting = false
                isPaused = false
                isStopped = false
                currentStep = nil
            }
        }
    }
    
    /// 重置排序状态
    private func resetSortingState() {
        isSorting = false
        isPaused = false
        isStopped = false
        currentStep = nil
        steps = []
        currentStepIndex = 0
        statistics = SortingStatistics()
        errorMessage = nil
        animationTask?.cancel()
    }
    
    /// 更新统计信息
    private func updateStatistics(for step: SortingStep) {
        switch step.type {
        case .compare:
            statistics.comparisonCount += 1
        case .swap:
            statistics.swapCount += 1
        case .move:
            statistics.moveCount += 1
        case .sorted:
            statistics.isCompleted = true
        default:
            break
        }
    }
    
    /// 设置绑定
    private func setupBindings() {
        // 监听数组大小变化
        $arraySize
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.generateRandomArray()
            }
            .store(in: &cancellables)
    }
}

/// 排序统计信息
public struct SortingStatistics {
    public var comparisonCount: Int = 0
    public var swapCount: Int = 0
    public var moveCount: Int = 0
    public var isCompleted: Bool = false
    
    public init() {}
}
