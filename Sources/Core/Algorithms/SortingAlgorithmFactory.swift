import Foundation

/// 排序算法工厂
/// 负责创建和管理各种排序算法实例
public class SortingAlgorithmFactory {
    
    /// 单例实例
    public static let shared = SortingAlgorithmFactory()
    
    /// 算法实例缓存
    private var algorithmCache: [SortingAlgorithm: SortingAlgorithmBase] = [:]
    
    private init() {}
    
    /// 获取排序算法实例
    /// - Parameter type: 算法类型
    /// - Returns: 排序算法实例
    public func getAlgorithm(for type: SortingAlgorithm) -> SortingAlgorithmBase {
        if let cached = algorithmCache[type] {
            return cached
        }
        
        let algorithm: SortingAlgorithmBase
        
        switch type {
        case .bubbleSort:
            algorithm = BubbleSort()
        case .selectionSort:
            algorithm = SelectionSort()
        case .insertionSort:
            algorithm = InsertionSort()
        case .shellSort:
            algorithm = ShellSort()
        case .mergeSort:
            algorithm = MergeSort()
        case .quickSort:
            algorithm = QuickSort()
        case .heapSort:
            algorithm = HeapSort()
        case .countingSort:
            algorithm = CountingSort()
        case .bucketSort:
            algorithm = BucketSort()
        case .radixSort:
            algorithm = RadixSort()
        }
        
        algorithmCache[type] = algorithm
        return algorithm
    }
    
    /// 获取所有支持的算法
    /// - Returns: 所有算法类型数组
    public func getAllAlgorithms() -> [SortingAlgorithm] {
        return SortingAlgorithm.allCases
    }
    
    /// 获取比较排序算法
    /// - Returns: 比较排序算法类型数组
    public func getComparisonAlgorithms() -> [SortingAlgorithm] {
        return [
            .bubbleSort,
            .selectionSort,
            .insertionSort,
            .shellSort,
            .mergeSort,
            .quickSort,
            .heapSort
        ]
    }
    
    /// 获取非比较排序算法
    /// - Returns: 非比较排序算法类型数组
    public func getNonComparisonAlgorithms() -> [SortingAlgorithm] {
        return [
            .countingSort,
            .bucketSort,
            .radixSort
        ]
    }
    
    /// 清除算法缓存
    public func clearCache() {
        algorithmCache.removeAll()
    }
    
    /// 重置所有算法状态
    public func resetAllAlgorithms() {
        for algorithm in algorithmCache.values {
            if let baseAlgorithm = algorithm as? BaseSortingAlgorithm {
                baseAlgorithm.resetSorting()
            }
        }
    }
}
