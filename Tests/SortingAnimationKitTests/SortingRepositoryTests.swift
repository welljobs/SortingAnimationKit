import XCTest
@testable import SortingAnimationKit

/// 排序仓库测试类
class SortingRepositoryTests: XCTestCase {
    
    var repository: SortingRepository!
    
    override func setUp() {
        super.setUp()
        repository = SortingRepository()
    }
    
    override func tearDown() {
        repository = nil
        super.tearDown()
    }
    
    // MARK: - 数组生成测试
    
    func testGenerateRandomArray() async throws {
        let size = 10
        let array = try await repository.generateRandomArray(size: size)
        
        XCTAssertEqual(array.count, size)
        XCTAssertTrue(array.allSatisfy { $0 >= 1 && $0 <= 100 })
    }
    
    func testGenerateRandomArrayWithRange() async throws {
        let size = 10
        let min = 10
        let max = 50
        let array = try await repository.generateRandomArray(size: size, min: min, max: max)
        
        XCTAssertEqual(array.count, size)
        XCTAssertTrue(array.allSatisfy { $0 >= min && $0 <= max })
    }
    
    func testGenerateSortedArray() async throws {
        let size = 10
        let array = try await repository.generateSortedArray(size: size)
        
        XCTAssertEqual(array.count, size)
        XCTAssertEqual(array, Array(1...size))
    }
    
    func testGenerateReversedArray() async throws {
        let size = 10
        let array = try await repository.generateReversedArray(size: size)
        
        XCTAssertEqual(array.count, size)
        XCTAssertEqual(array, Array(1...size).reversed())
    }
    
    func testGeneratePartiallySortedArray() async throws {
        let size = 10
        let array = try await repository.generatePartiallySortedArray(size: size)
        
        XCTAssertEqual(array.count, size)
        // 部分排序数组应该包含1到size的所有数字
        XCTAssertEqual(Set(array), Set(1...size))
    }
    
    // MARK: - 错误处理测试
    
    func testGenerateArrayWithInvalidSize() async {
        do {
            _ = try await repository.generateRandomArray(size: 0)
            XCTFail("应该抛出错误")
        } catch {
            XCTAssertTrue(error is SortingError)
        }
    }
    
    func testGenerateArrayWithInvalidRange() async {
        do {
            _ = try await repository.generateRandomArray(size: 10, min: 50, max: 10)
            XCTFail("应该抛出错误")
        } catch {
            XCTAssertTrue(error is SortingError)
        }
    }
    
    // MARK: - 排序步骤持久化测试
    
    func testSaveAndLoadSortingSteps() async throws {
        let steps = [
            SortingStep(
                type: .compare,
                indices: [0, 1],
                description: "比较元素",
                array: [
                    SortingElement(value: 5, position: 0),
                    SortingElement(value: 3, position: 1)
                ],
                delay: 500
            ),
            SortingStep(
                type: .swap,
                indices: [0, 1],
                description: "交换元素",
                array: [
                    SortingElement(value: 3, position: 0),
                    SortingElement(value: 5, position: 1)
                ],
                delay: 500
            )
        ]
        
        // 保存步骤
        try await repository.saveSortingSteps(steps)
        
        // 加载步骤
        let loadedSteps = try await repository.loadSortingSteps()
        
        XCTAssertEqual(loadedSteps.count, steps.count)
        XCTAssertEqual(loadedSteps[0].type, steps[0].type)
        XCTAssertEqual(loadedSteps[0].description, steps[0].description)
        XCTAssertEqual(loadedSteps[1].type, steps[1].type)
        XCTAssertEqual(loadedSteps[1].description, steps[1].description)
    }
    
    func testClearSortingSteps() async throws {
        let steps = [
            SortingStep(
                type: .compare,
                indices: [0, 1],
                description: "测试步骤",
                array: [SortingElement(value: 1, position: 0)],
                delay: 500
            )
        ]
        
        // 保存步骤
        try await repository.saveSortingSteps(steps)
        
        // 验证步骤已保存
        let loadedSteps = try await repository.loadSortingSteps()
        XCTAssertEqual(loadedSteps.count, 1)
        
        // 清除步骤
        try await repository.clearSortingSteps()
        
        // 验证步骤已清除
        let clearedSteps = try await repository.loadSortingSteps()
        XCTAssertEqual(clearedSteps.count, 0)
    }
    
    // MARK: - 性能测试
    
    func testPerformanceGenerateLargeArray() {
        let size = 1000
        
        measure {
            let expectation = XCTestExpectation(description: "Generate large array")
            
            Task {
                _ = try await repository.generateRandomArray(size: size)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    }
    
    func testPerformanceSaveLargeSteps() {
        let steps = (0..<1000).map { i in
            SortingStep(
                type: .compare,
                indices: [i, i + 1],
                description: "步骤 \(i)",
                array: [
                    SortingElement(value: i, position: i),
                    SortingElement(value: i + 1, position: i + 1)
                ],
                delay: 500
            )
        }
        
        measure {
            let expectation = XCTestExpectation(description: "Save large steps")
            
            Task {
                try await repository.saveSortingSteps(steps)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    }
}
