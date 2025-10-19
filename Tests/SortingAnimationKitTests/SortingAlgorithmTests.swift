import XCTest
@testable import SortingAnimationKit

/// 排序算法测试类
class SortingAlgorithmTests: XCTestCase {
    
    var algorithmFactory: SortingAlgorithmFactory!
    
    override func setUp() {
        super.setUp()
        algorithmFactory = SortingAlgorithmFactory.shared
    }
    
    override func tearDown() {
        algorithmFactory = nil
        super.tearDown()
    }
    
    // MARK: - 冒泡排序测试
    
    func testBubbleSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .bubbleSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
        
        // 验证步骤类型
        XCTAssertTrue(steps.contains { $0.type == .compare })
        XCTAssertTrue(steps.contains { $0.type == .swap })
        XCTAssertTrue(steps.contains { $0.type == .sorted })
    }
    
    // MARK: - 选择排序测试
    
    func testSelectionSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .selectionSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
    }
    
    // MARK: - 插入排序测试
    
    func testInsertionSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .insertionSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
    }
    
    // MARK: - 快速排序测试
    
    func testQuickSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .quickSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
    }
    
    // MARK: - 归并排序测试
    
    func testMergeSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .mergeSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
    }
    
    // MARK: - 堆排序测试
    
    func testHeapSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .heapSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
    }
    
    // MARK: - 希尔排序测试
    
    func testShellSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .shellSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
    }
    
    // MARK: - 计数排序测试
    
    func testCountingSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .countingSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
    }
    
    // MARK: - 桶排序测试
    
    func testBucketSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .bucketSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
    }
    
    // MARK: - 基数排序测试
    
    func testRadixSort() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .radixSort)
        let testArray = [64, 34, 25, 12, 22, 11, 90]
        let expectedArray = [11, 12, 22, 25, 34, 64, 90]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 验证排序结果
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
        
        // 验证步骤数量
        XCTAssertGreaterThan(steps.count, 0)
    }
    
    // MARK: - 边界情况测试
    
    func testEmptyArray() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .bubbleSort)
        let testArray: [Int] = []
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 空数组应该返回空步骤
        XCTAssertEqual(steps.count, 0)
    }
    
    func testSingleElement() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .bubbleSort)
        let testArray = [42]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 单元素数组应该只有一个步骤
        XCTAssertEqual(steps.count, 1)
        XCTAssertEqual(steps.first?.array.first?.value, 42)
    }
    
    func testAlreadySorted() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .bubbleSort)
        let testArray = [1, 2, 3, 4, 5]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 已排序数组应该保持顺序
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, testArray)
    }
    
    func testReverseSorted() async throws {
        let algorithm = algorithmFactory.getAlgorithm(for: .bubbleSort)
        let testArray = [5, 4, 3, 2, 1]
        let expectedArray = [1, 2, 3, 4, 5]
        
        let steps = try await algorithm.sort(testArray, animationSpeed: 100)
        
        // 逆序数组应该被正确排序
        let finalArray = steps.last?.array.map { $0.value } ?? []
        XCTAssertEqual(finalArray, expectedArray)
    }
    
    // MARK: - 性能测试
    
    func testPerformanceBubbleSort() {
        let algorithm = algorithmFactory.getAlgorithm(for: .bubbleSort)
        let testArray = Array(1...100).shuffled()
        
        measure {
            let expectation = XCTestExpectation(description: "Bubble sort performance")
            
            Task {
                do {
                    _ = try await algorithm.sort(testArray, animationSpeed: 1)
                    expectation.fulfill()
                } catch {
                    XCTFail("Bubble sort failed: \(error)")
                }
            }
            
            wait(for: [expectation], timeout: 30.0)
        }
    }
    
    func testPerformanceQuickSort() {
        let algorithm = algorithmFactory.getAlgorithm(for: .quickSort)
        let testArray = Array(1...100).shuffled()
        
        measure {
            let expectation = XCTestExpectation(description: "Quick sort performance")
            
            Task {
                do {
                    _ = try await algorithm.sort(testArray, animationSpeed: 1)
                    expectation.fulfill()
                } catch {
                    XCTFail("Quick sort failed: \(error)")
                }
            }
            
            wait(for: [expectation], timeout: 30.0)
        }
    }
}
