import Foundation

/// 排序算法类型枚举
/// 定义了支持的十种主要排序算法
public enum SortingAlgorithm: String, CaseIterable, Identifiable {
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
    
    public var id: String { rawValue }
    
    /// 算法显示名称
    public var displayName: String {
        switch self {
        case .bubbleSort:
            return "冒泡排序"
        case .selectionSort:
            return "选择排序"
        case .insertionSort:
            return "插入排序"
        case .shellSort:
            return "希尔排序"
        case .mergeSort:
            return "归并排序"
        case .quickSort:
            return "快速排序"
        case .heapSort:
            return "堆排序"
        case .countingSort:
            return "计数排序"
        case .bucketSort:
            return "桶排序"
        case .radixSort:
            return "基数排序"
        }
    }
    
    /// 算法英文名称
    public var englishName: String {
        switch self {
        case .bubbleSort:
            return "Bubble Sort"
        case .selectionSort:
            return "Selection Sort"
        case .insertionSort:
            return "Insertion Sort"
        case .shellSort:
            return "Shell Sort"
        case .mergeSort:
            return "Merge Sort"
        case .quickSort:
            return "Quick Sort"
        case .heapSort:
            return "Heap Sort"
        case .countingSort:
            return "Counting Sort"
        case .bucketSort:
            return "Bucket Sort"
        case .radixSort:
            return "Radix Sort"
        }
    }
    
    /// 算法复杂度信息
    public var complexity: AlgorithmComplexity {
        switch self {
        case .bubbleSort:
            return AlgorithmComplexity(
                timeBest: "O(n)",
                timeAverage: "O(n²)",
                timeWorst: "O(n²)",
                space: "O(1)",
                stable: true
            )
        case .selectionSort:
            return AlgorithmComplexity(
                timeBest: "O(n²)",
                timeAverage: "O(n²)",
                timeWorst: "O(n²)",
                space: "O(1)",
                stable: false
            )
        case .insertionSort:
            return AlgorithmComplexity(
                timeBest: "O(n)",
                timeAverage: "O(n²)",
                timeWorst: "O(n²)",
                space: "O(1)",
                stable: true
            )
        case .shellSort:
            return AlgorithmComplexity(
                timeBest: "O(n log n)",
                timeAverage: "O(n^1.3)",
                timeWorst: "O(n²)",
                space: "O(1)",
                stable: false
            )
        case .mergeSort:
            return AlgorithmComplexity(
                timeBest: "O(n log n)",
                timeAverage: "O(n log n)",
                timeWorst: "O(n log n)",
                space: "O(n)",
                stable: true
            )
        case .quickSort:
            return AlgorithmComplexity(
                timeBest: "O(n log n)",
                timeAverage: "O(n log n)",
                timeWorst: "O(n²)",
                space: "O(log n)",
                stable: false
            )
        case .heapSort:
            return AlgorithmComplexity(
                timeBest: "O(n log n)",
                timeAverage: "O(n log n)",
                timeWorst: "O(n log n)",
                space: "O(1)",
                stable: false
            )
        case .countingSort:
            return AlgorithmComplexity(
                timeBest: "O(n + k)",
                timeAverage: "O(n + k)",
                timeWorst: "O(n + k)",
                space: "O(k)",
                stable: true
            )
        case .bucketSort:
            return AlgorithmComplexity(
                timeBest: "O(n + k)",
                timeAverage: "O(n + k)",
                timeWorst: "O(n²)",
                space: "O(n + k)",
                stable: true
            )
        case .radixSort:
            return AlgorithmComplexity(
                timeBest: "O(d(n + k))",
                timeAverage: "O(d(n + k))",
                timeWorst: "O(d(n + k))",
                space: "O(n + k)",
                stable: true
            )
        }
    }
    
    /// 算法描述
    public var description: String {
        switch self {
        case .bubbleSort:
            return "重复遍历数组，比较相邻元素并交换位置，将最大元素逐步移动到末尾"
        case .selectionSort:
            return "每次从未排序部分选择最小元素，与未排序部分的第一个元素交换位置"
        case .insertionSort:
            return "将数组分为已排序和未排序两部分，逐个将未排序元素插入到已排序部分的正确位置"
        case .shellSort:
            return "基于插入排序的改进算法，通过递减的间隔序列对数组进行多次插入排序"
        case .mergeSort:
            return "采用分治法，将数组递归地分成两半，分别排序后再合并"
        case .quickSort:
            return "选择一个基准元素，将数组分为小于和大于基准的两部分，递归排序"
        case .heapSort:
            return "利用堆数据结构的性质，将数组构建成最大堆，然后逐个取出最大元素"
        case .countingSort:
            return "统计每个值的出现次数，然后根据统计结果重新排列数组"
        case .bucketSort:
            return "将数组分配到有限数量的桶中，对每个桶进行排序，然后按顺序合并"
        case .radixSort:
            return "按照个位、十位、百位等位数依次进行排序，适用于整数排序"
        }
    }
}

/// 算法复杂度信息结构体
public struct AlgorithmComplexity {
    public let timeBest: String      // 最好时间复杂度
    public let timeAverage: String   // 平均时间复杂度
    public let timeWorst: String     // 最坏时间复杂度
    public let space: String         // 空间复杂度
    public let stable: Bool          // 是否稳定排序
    
    public init(timeBest: String, timeAverage: String, timeWorst: String, space: String, stable: Bool) {
        self.timeBest = timeBest
        self.timeAverage = timeAverage
        self.timeWorst = timeWorst
        self.space = space
        self.stable = stable
    }
}
