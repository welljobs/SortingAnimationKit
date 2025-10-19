import Foundation

/// 快速排序算法实现
/// 时间复杂度：O(n log n) 平均，O(n²) 最坏
/// 空间复杂度：O(log n)
/// 稳定性：不稳定
public class QuickSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "快速排序", type: .quickSort)
    }
    
    public override func performSort(_ elements: [SortingElement], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = elements
        
        // 处理空数组
        if elements.isEmpty {
            return steps
        }
        
        // 处理单元素数组
        if elements.count == 1 {
            elements[0].state = .sorted
            elements[0].isSorted = true
            steps.append(createSortedStep(
                array: elements,
                description: "单元素数组已排序",
                delay: animationSpeed
            ))
            return steps
        }
        
        print("🔧 QuickSort: 开始快速排序，数组大小: \(elements.count)")
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始快速排序",
            delay: animationSpeed
        ))
        
        // 执行快速排序
        let quickSortSteps = try await quickSort(&elements, low: 0, high: elements.count - 1, animationSpeed: animationSpeed)
        steps.append(contentsOf: quickSortSteps)
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "快速排序完成！",
            delay: animationSpeed
        ))
        
        print("✅ QuickSort: 快速排序完成，生成 \(steps.count) 个步骤")
        return steps
    }
    
    /// 快速排序递归实现
    private func quickSort(_ elements: inout [SortingElement], low: Int, high: Int, animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        
        guard await shouldContinue() else { return steps }
        
        if low < high {
            // 选择基准元素（使用最后一个元素）
            let pivotIndex = high
            elements[pivotIndex].state = .pivot
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [pivotIndex],
                description: "选择基准元素 \(elements[pivotIndex].value)",
                delay: animationSpeed
            ))
            
            
            // 分区操作
            let (partitionSteps, finalPivotIndex) = try await partition(&elements, low: low, high: high, pivotIndex: pivotIndex, animationSpeed: animationSpeed)
            steps.append(contentsOf: partitionSteps)
            
            // 递归排序左半部分
            if low < finalPivotIndex - 1 {
                steps.append(createHighlightStep(
                    array: elements,
                    indices: Array(low..<finalPivotIndex),
                    description: "递归排序左半部分",
                    delay: animationSpeed
                ))
                
                let leftSteps = try await quickSort(&elements, low: low, high: finalPivotIndex - 1, animationSpeed: animationSpeed)
                steps.append(contentsOf: leftSteps)
            }
            
            // 递归排序右半部分
            if finalPivotIndex + 1 < high {
                steps.append(createHighlightStep(
                    array: elements,
                    indices: Array((finalPivotIndex + 1)...high),
                    description: "递归排序右半部分",
                    delay: animationSpeed
                ))
                
                let rightSteps = try await quickSort(&elements, low: finalPivotIndex + 1, high: high, animationSpeed: animationSpeed)
                steps.append(contentsOf: rightSteps)
            }
        }
        
        return steps
    }
    
    /// 分区操作
    private func partition(_ elements: inout [SortingElement], low: Int, high: Int, pivotIndex: Int, animationSpeed: Int) async throws -> ([SortingStep], Int) {
        var steps: [SortingStep] = []
        let pivot = elements[pivotIndex].value
        var i = low - 1
        
        steps.append(createHighlightStep(
            array: elements,
            indices: Array(low...high),
            description: "开始分区操作，基准值：\(pivot)",
            delay: animationSpeed
        ))
        
        
        for j in low..<high {
            guard await shouldContinue() else { break }
            
            // 等待暂停状态结束
            await waitForResume()
            
            // 比较当前元素与基准
            elements[j].state = .comparing
            elements[pivotIndex].state = .pivot
            
            steps.append(createCompareStep(
                array: elements,
                indices: [j, pivotIndex],
                description: "比较 \(elements[j].value) 和基准值 \(pivot)",
                delay: animationSpeed
            ))
            
            
            if elements[j].value <= pivot {
                i += 1
                
                if i != j {
                    // 交换元素
                    elements[i].state = .swapping
                    elements[j].state = .swapping
                    
                    steps.append(createSwapStep(
                        array: elements,
                        indices: [i, j],
                        description: "交换 \(elements[i].value) 和 \(elements[j].value)",
                        delay: animationSpeed
                    ))
                    
                    
                    // 执行交换
                    let temp = elements[i]
                    elements[i] = elements[j]
                    elements[j] = temp
                    
                    // 更新位置
                    elements[i].position = i
                    elements[j].position = j
                }
                
                // 重置状态
                elements[i].state = .normal
                elements[j].state = .normal
            } else {
                // 重置状态
                elements[j].state = .normal
            }
        }
        
        // 将基准元素放到正确位置
        let finalPivotIndex = i + 1
        if finalPivotIndex != pivotIndex {
            elements[finalPivotIndex].state = .swapping
            elements[pivotIndex].state = .swapping
            
            steps.append(createSwapStep(
                array: elements,
                indices: [finalPivotIndex, pivotIndex],
                description: "将基准元素 \(pivot) 放到正确位置 \(finalPivotIndex)",
                delay: animationSpeed
            ))
            
            
            // 执行交换
            let temp = elements[finalPivotIndex]
            elements[finalPivotIndex] = elements[pivotIndex]
            elements[pivotIndex] = temp
            
            // 更新位置
            elements[finalPivotIndex].position = finalPivotIndex
            elements[pivotIndex].position = pivotIndex
        }
        
        // 标记基准元素为已排序
        elements[finalPivotIndex].state = .sorted
        elements[finalPivotIndex].isSorted = true
        
        steps.append(createHighlightStep(
            array: elements,
            indices: [finalPivotIndex],
            description: "基准元素 \(pivot) 已排序",
            delay: animationSpeed
        ))
        
        
        return (steps, i + 1)
    }
}
