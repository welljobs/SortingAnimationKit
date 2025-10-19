#!/usr/bin/env swift

import Foundation

// 导入SortingAnimationKit
// 注意：在命令行环境中，我们需要通过相对路径导入
// 这里我们直接使用库的核心功能进行测试

print("🎯 SortingAnimationKit 命令行测试工具")
print(String(repeating: "=", count: 50))

// 模拟库信息
struct LibraryInfo {
    static let name = "SortingAnimationKit"
    static let version = "1.0.0"
    static let description = "A SwiftUI-based sorting algorithm animation library with Clean Architecture"
    static let minimumIOSVersion = "15.0"
    static let minimumMacOSVersion = "12.0"
}

// 模拟排序算法枚举
enum SortingAlgorithm: String, CaseIterable {
    case bubbleSort = "bubble_sort"
    case selectionSort = "selection_sort"
    case insertionSort = "insertion_sort"
    case shellSort = "shell_sort"
    case mergeSort = "merge_sort"
    case quickSort = "quick_sort"
    case heapSort = "heap_sort"
    case countingSort = "counting_sort"
    case bucketSort = "bucket_sort"
    case radixSort = "radix_sort"
    
    var displayName: String {
        switch self {
        case .bubbleSort: return "冒泡排序"
        case .selectionSort: return "选择排序"
        case .insertionSort: return "插入排序"
        case .shellSort: return "希尔排序"
        case .mergeSort: return "归并排序"
        case .quickSort: return "快速排序"
        case .heapSort: return "堆排序"
        case .countingSort: return "计数排序"
        case .bucketSort: return "桶排序"
        case .radixSort: return "基数排序"
        }
    }
    
    var timeComplexity: String {
        switch self {
        case .bubbleSort: return "O(n²)"
        case .selectionSort: return "O(n²)"
        case .insertionSort: return "O(n²)"
        case .shellSort: return "O(n^1.3)"
        case .mergeSort: return "O(n log n)"
        case .quickSort: return "O(n log n)"
        case .heapSort: return "O(n log n)"
        case .countingSort: return "O(n + k)"
        case .bucketSort: return "O(n + k)"
        case .radixSort: return "O(d(n + k))"
        }
    }
    
    var category: String {
        switch self {
        case .bubbleSort, .selectionSort, .insertionSort, .shellSort, .mergeSort, .quickSort, .heapSort:
            return "比较排序"
        case .countingSort, .bucketSort, .radixSort:
            return "非比较排序"
        }
    }
}

// 模拟排序元素
struct SortingElement {
    let value: Int
    let position: Int
    var state: ElementState = .normal
    
    enum ElementState: String {
        case normal = "normal"
        case comparing = "comparing"
        case swapping = "swapping"
        case sorted = "sorted"
    }
}

// 模拟排序步骤
struct SortingStep {
    let type: StepType
    let indices: [Int]
    let description: String
    let array: [SortingElement]
    let delay: Int
    
    enum StepType: String {
        case compare = "compare"
        case swap = "swap"
        case move = "move"
        case highlight = "highlight"
        case sorted = "sorted"
    }
}

// 模拟排序算法基类
class SortingAlgorithmBase {
    func sort(_ array: [Int]) -> [SortingStep] {
        return []
    }
}

// 冒泡排序实现
class BubbleSort: SortingAlgorithmBase {
    override func sort(_ array: [Int]) -> [SortingStep] {
        var steps: [SortingStep] = []
        var arr = array
        let n = arr.count
        
        for i in 0..<n {
            for j in 0..<n-i-1 {
                // 比较步骤
                steps.append(SortingStep(
                    type: .compare,
                    indices: [j, j+1],
                    description: "比较 \(arr[j]) 和 \(arr[j+1])",
                    array: arr.enumerated().map { SortingElement(value: $0.element, position: $0.offset) },
                    delay: 100
                ))
                
                if arr[j] > arr[j+1] {
                    // 交换步骤
                    arr.swapAt(j, j+1)
                    steps.append(SortingStep(
                        type: .swap,
                        indices: [j, j+1],
                        description: "交换 \(arr[j+1]) 和 \(arr[j])",
                        array: arr.enumerated().map { SortingElement(value: $0.element, position: $0.offset) },
                        delay: 200
                    ))
                }
            }
        }
        
        return steps
    }
}

// 快速排序实现
class QuickSort: SortingAlgorithmBase {
    override func sort(_ array: [Int]) -> [SortingStep] {
        var steps: [SortingStep] = []
        var arr = array
        
        func quickSort(_ array: inout [Int], _ low: Int, _ high: Int) {
            if low < high {
                let pivotIndex = partition(&array, low, high)
                quickSort(&array, low, pivotIndex - 1)
                quickSort(&array, pivotIndex + 1, high)
            }
        }
        
        func partition(_ array: inout [Int], _ low: Int, _ high: Int) -> Int {
            let pivot = array[high]
            var i = low - 1
            
            for j in low..<high {
                steps.append(SortingStep(
                    type: .compare,
                    indices: [j, high],
                    description: "比较 \(array[j]) 和基准 \(pivot)",
                    array: array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) },
                    delay: 100
                ))
                
                if array[j] <= pivot {
                    i += 1
                    if i != j {
                        array.swapAt(i, j)
                        steps.append(SortingStep(
                            type: .swap,
                            indices: [i, j],
                            description: "交换 \(array[j]) 和 \(array[i])",
                            array: array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) },
                            delay: 200
                        ))
                    }
                }
            }
            
            array.swapAt(i + 1, high)
            return i + 1
        }
        
        quickSort(&arr, 0, arr.count - 1)
        return steps
    }
}

// 测试函数
func testSortingAlgorithm(_ algorithm: SortingAlgorithm, _ array: [Int]) {
    print("\n🔍 测试 \(algorithm.displayName)")
    print("   类别: \(algorithm.category)")
    print("   时间复杂度: \(algorithm.timeComplexity)")
    print("   输入数组: \(array)")
    
    let startTime = CFAbsoluteTimeGetCurrent()
    
    var steps: [SortingStep] = []
    switch algorithm {
    case .bubbleSort:
        let bubbleSort = BubbleSort()
        steps = bubbleSort.sort(array)
    case .quickSort:
        let quickSort = QuickSort()
        steps = quickSort.sort(array)
    default:
        print("   ⚠️  该算法在此演示中未实现")
        return
    }
    
    let endTime = CFAbsoluteTimeGetCurrent()
    let executionTime = endTime - startTime
    
    print("   执行步骤数: \(steps.count)")
    print("   执行时间: \(String(format: "%.4f", executionTime)) 秒")
    
    // 显示前5个步骤
    print("   前5个步骤:")
    for (index, step) in steps.prefix(5).enumerated() {
        print("     \(index + 1). \(step.description)")
    }
    
    if steps.count > 5 {
        print("     ... 还有 \(steps.count - 5) 个步骤")
    }
}

// 主程序
func main() {
    print("\n📚 库信息")
    print("   名称: \(LibraryInfo.name)")
    print("   版本: \(LibraryInfo.version)")
    print("   描述: \(LibraryInfo.description)")
    print("   最低iOS版本: \(LibraryInfo.minimumIOSVersion)")
    print("   最低macOS版本: \(LibraryInfo.minimumMacOSVersion)")
    
    print("\n🎯 支持的排序算法")
    let allAlgorithms = SortingAlgorithm.allCases
    let comparisonAlgorithms = allAlgorithms.filter { $0.category == "比较排序" }
    let nonComparisonAlgorithms = allAlgorithms.filter { $0.category == "非比较排序" }
    
    print("   比较排序算法 (\(comparisonAlgorithms.count) 种):")
    for algorithm in comparisonAlgorithms {
        print("     • \(algorithm.displayName) - \(algorithm.timeComplexity)")
    }
    
    print("   非比较排序算法 (\(nonComparisonAlgorithms.count) 种):")
    for algorithm in nonComparisonAlgorithms {
        print("     • \(algorithm.displayName) - \(algorithm.timeComplexity)")
    }
    
    print("\n🧪 算法测试")
    
    // 测试用例
    let testCases = [
        ("小数组", [64, 34, 25, 12, 22, 11, 90]),
        ("已排序数组", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
        ("逆序数组", [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]),
        ("重复元素", [5, 2, 8, 2, 9, 1, 5, 3, 2, 7]),
        ("单元素", [42]),
        ("空数组", [])
    ]
    
    for (testName, testArray) in testCases {
        print("\n📊 测试用例: \(testName)")
        if testArray.isEmpty {
            print("   空数组，跳过测试")
            continue
        }
        
        // 测试冒泡排序
        testSortingAlgorithm(.bubbleSort, testArray)
        
        // 测试快速排序
        testSortingAlgorithm(.quickSort, testArray)
    }
    
    print("\n✅ 测试完成!")
    print("\n💡 提示:")
    print("   • 要查看完整的UI界面，请在Xcode中打开 Examples/SortingAnimationDemo.xcodeproj")
    print("   • 支持iOS 16.0+ 和 macOS 13.0+")
    print("   • 库采用Clean Architecture + MVVM + Repository模式")
}

// 运行主程序
main()
