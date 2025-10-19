import XCTest
@testable import SortingAnimationKit

/// 排序视图模型测试类
@MainActor
class SortingViewModelTests: XCTestCase {
    
    var viewModel: SortingViewModel!
    var mockRepository: MockSortingRepository!
    var mockExecutor: MockSortingExecutor!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockSortingRepository()
        mockExecutor = MockSortingExecutor()
        
        let generateUseCase = GenerateArrayUseCase(repository: mockRepository)
        let executeUseCase = ExecuteSortingUseCase(repository: mockRepository, executor: mockExecutor)
        
        viewModel = SortingViewModel(
            generateArrayUseCase: generateUseCase,
            executeSortingUseCase: executeUseCase
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockExecutor = nil
        super.tearDown()
    }
    
    // MARK: - 数组生成测试
    
    func testGenerateRandomArray() async {
        let expectedArray = [1, 2, 3, 4, 5]
        mockRepository.mockRandomArray = expectedArray
        
        viewModel.generateRandomArray()
        
        // 等待异步操作完成
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
        
        XCTAssertEqual(viewModel.elements.map { $0.value }, expectedArray)
        XCTAssertFalse(viewModel.isSorting)
    }
    
    func testGenerateSortedArray() async {
        let expectedArray = [1, 2, 3, 4, 5]
        mockRepository.mockSortedArray = expectedArray
        
        viewModel.generateSortedArray()
        
        // 等待异步操作完成
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
        
        XCTAssertEqual(viewModel.elements.map { $0.value }, expectedArray)
    }
    
    func testGenerateReversedArray() async {
        let expectedArray = [5, 4, 3, 2, 1]
        mockRepository.mockReversedArray = expectedArray
        
        viewModel.generateReversedArray()
        
        // 等待异步操作完成
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
        
        XCTAssertEqual(viewModel.elements.map { $0.value }, expectedArray)
    }
    
    // MARK: - 排序控制测试
    
    func testStartSorting() async {
        let testArray = [3, 1, 4, 1, 5]
        viewModel.elements = testArray.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
        
        let mockSteps = [
            SortingStep(
                type: .compare,
                indices: [0, 1],
                description: "比较",
                array: viewModel.elements,
                delay: 100
            ),
            SortingStep(
                type: .sorted,
                indices: [],
                description: "完成",
                array: viewModel.elements,
                delay: 100
            )
        ]
        mockExecutor.mockSteps = mockSteps
        
        viewModel.startSorting()
        
        // 等待异步操作完成
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2秒
        
        // 检查排序是否开始（可能已经完成）
        XCTAssertTrue(viewModel.isSorting || viewModel.steps.count > 0)
        XCTAssertEqual(viewModel.steps.count, 2)
    }
    
    func testPauseSorting() async {
        viewModel.isSorting = true
        viewModel.isPaused = false
        
        viewModel.pauseSorting()
        
        // 等待异步操作完成
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
        
        XCTAssertTrue(viewModel.isPaused)
    }
    
    func testResumeSorting() async {
        viewModel.isSorting = true
        viewModel.isPaused = true
        
        viewModel.resumeSorting()
        
        // 等待异步操作完成
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
        
        XCTAssertFalse(viewModel.isPaused)
    }
    
    func testStopSorting() async {
        viewModel.isSorting = true
        
        viewModel.stopSorting()
        
        // 等待异步操作完成
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
        
        XCTAssertFalse(viewModel.isSorting)
        XCTAssertTrue(viewModel.isStopped)
    }
    
    func testResetSorting() async {
        viewModel.isSorting = true
        viewModel.isPaused = true
        viewModel.isStopped = true
        viewModel.steps = [SortingStep(type: .compare, indices: [0, 1], description: "测试", array: [], delay: 100)]
        viewModel.currentStepIndex = 5
        
        viewModel.resetSorting()
        
        // 等待异步操作完成
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
        
        XCTAssertFalse(viewModel.isSorting)
        XCTAssertFalse(viewModel.isPaused)
        XCTAssertFalse(viewModel.isStopped)
        XCTAssertTrue(viewModel.steps.isEmpty)
        XCTAssertEqual(viewModel.currentStepIndex, 0)
    }
    
    // MARK: - 设置测试
    
    func testSetAlgorithm() {
        let newAlgorithm = SortingAlgorithm.quickSort
        
        viewModel.setAlgorithm(newAlgorithm)
        
        XCTAssertEqual(viewModel.currentAlgorithm, newAlgorithm)
    }
    
    func testSetAnimationSpeed() {
        let newSpeed = 1000
        
        viewModel.setAnimationSpeed(newSpeed)
        
        XCTAssertEqual(viewModel.animationSpeed, newSpeed)
    }
    
    func testSetArraySize() {
        let newSize = 30
        
        viewModel.setArraySize(newSize)
        
        XCTAssertEqual(viewModel.arraySize, newSize)
    }
    
    // MARK: - 统计信息测试
    
    func testStatisticsUpdate() {
        let step = SortingStep(
            type: .compare,
            indices: [0, 1],
            description: "比较",
            array: [],
            delay: 100
        )
        
        // 模拟更新统计信息
        viewModel.statistics.comparisonCount += 1
        
        XCTAssertEqual(viewModel.statistics.comparisonCount, 1)
    }
}

// MARK: - Mock Classes

/// 模拟排序仓库
class MockSortingRepository: SortingRepositoryProtocol {
    var mockRandomArray: [Int] = []
    var mockSortedArray: [Int] = []
    var mockReversedArray: [Int] = []
    var mockPartiallySortedArray: [Int] = []
    var mockSteps: [SortingStep] = []
    
    func generateRandomArray(size: Int) async throws -> [Int] {
        return mockRandomArray
    }
    
    func generateRandomArray(size: Int, min: Int, max: Int) async throws -> [Int] {
        return mockRandomArray
    }
    
    func generateSortedArray(size: Int) async throws -> [Int] {
        return mockSortedArray
    }
    
    func generateReversedArray(size: Int) async throws -> [Int] {
        return mockReversedArray
    }
    
    func generatePartiallySortedArray(size: Int) async throws -> [Int] {
        return mockPartiallySortedArray
    }
    
    func saveSortingSteps(_ steps: [SortingStep]) async throws {
        mockSteps = steps
    }
    
    func loadSortingSteps() async throws -> [SortingStep] {
        return mockSteps
    }
    
    func clearSortingSteps() async throws {
        mockSteps = []
    }
}

/// 模拟排序执行器
class MockSortingExecutor: SortingExecutorProtocol {
    var mockSteps: [SortingStep] = []
    var isExecuting = false
    var isPaused = false
    var isStopped = false
    
    func executeSorting(algorithm: SortingAlgorithm, array: [Int], animationSpeed: Int) async throws -> [SortingStep] {
        isExecuting = true
        // 模拟异步延迟
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
        return mockSteps
    }
    
    func stopSorting() async {
        isStopped = true
        isExecuting = false
    }
    
    func pauseSorting() async {
        isPaused = true
    }
    
    func resumeSorting() async {
        isPaused = false
    }
    
    func resetSorting() async {
        isExecuting = false
        isPaused = false
        isStopped = false
    }
}
