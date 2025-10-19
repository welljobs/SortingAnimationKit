import Foundation

/// 归并排序算法实现
/// 时间复杂度：O(n log n)
/// 空间复杂度：O(n)
/// 稳定性：稳定
public class MergeSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "归并排序", type: .mergeSort)
    }
    
    public override func performSort(_ elements: [SortingElement], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = elements
        
        print("🔧 MergeSort: 开始归并排序，数组大小: \(elements.count)")
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始归并排序",
            delay: animationSpeed
        ))
        
        // 执行归并排序
        let mergeSortSteps = try await mergeSort(&elements, left: 0, right: elements.count - 1, animationSpeed: animationSpeed)
        steps.append(contentsOf: mergeSortSteps)
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "归并排序完成！",
            delay: animationSpeed
        ))
        
        print("✅ MergeSort: 归并排序完成，生成 \(steps.count) 个步骤")
        return steps
    }
    
    /// 归并排序递归实现
    private func mergeSort(_ elements: inout [SortingElement], left: Int, right: Int, animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        
        guard await shouldContinue() else { return steps }
        
        if left < right {
            let mid = left + (right - left) / 2
            
            // 标记当前分割的区间
            steps.append(createHighlightStep(
                array: elements,
                indices: Array(left...right),
                description: "分割区间 [\(left), \(right)]，中点：\(mid)",
                delay: animationSpeed
            ))
            
            
            // 递归排序左半部分
            let leftSteps = try await mergeSort(&elements, left: left, right: mid, animationSpeed: animationSpeed)
            steps.append(contentsOf: leftSteps)
            
            // 递归排序右半部分
            let rightSteps = try await mergeSort(&elements, left: mid + 1, right: right, animationSpeed: animationSpeed)
            steps.append(contentsOf: rightSteps)
            
            // 合并两个已排序的部分
            let mergeSteps = try await merge(&elements, left: left, mid: mid, right: right, animationSpeed: animationSpeed)
            steps.append(contentsOf: mergeSteps)
        } else if left == right {
            // 单个元素，标记为已排序
            elements[left].state = .sorted
            elements[left].isSorted = true
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [left],
                description: "单个元素 \(elements[left].value) 已排序",
                delay: animationSpeed
            ))
            
        }
        
        return steps
    }
    
    /// 合并两个已排序的数组
    private func merge(_ elements: inout [SortingElement], left: Int, mid: Int, right: Int, animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        
        guard await shouldContinue() else { return steps }
        
        // 创建临时数组
        let leftArray = Array(elements[left...mid])
        let rightArray = Array(elements[(mid + 1)...right])
        
        steps.append(createHighlightStep(
            array: elements,
            indices: Array(left...right),
            description: "合并区间 [\(left), \(mid)] 和 [\(mid + 1), \(right)]",
            delay: animationSpeed
        ))
        
        
        var i = 0  // 左数组索引
        var j = 0  // 右数组索引
        var k = left  // 原数组索引
        
        // 比较并合并
        while i < leftArray.count && j < rightArray.count {
            guard await shouldContinue() else { break }
            
            // 等待暂停状态结束
            await waitForResume()
            
            // 标记正在比较的元素
            let leftIndex = left + i
            let rightIndex = mid + 1 + j
            
            // 找到当前比较的元素在原数组中的位置
            let leftElement = leftArray[i]
            let rightElement = rightArray[j]
            
            // 标记比较状态
            for (index, element) in elements.enumerated() {
                if element.value == leftElement.value && element.position == leftIndex {
                    elements[index].state = .comparing
                } else if element.value == rightElement.value && element.position == rightIndex {
                    elements[index].state = .comparing
                }
            }
            
            steps.append(createCompareStep(
                array: elements,
                indices: [leftIndex, rightIndex],
                description: "比较 \(leftElement.value) 和 \(rightElement.value)",
                delay: animationSpeed
            ))
            
            
            if leftArray[i].value <= rightArray[j].value {
                // 选择左数组元素
                elements[k] = leftArray[i]
                elements[k].position = k
                elements[k].state = .normal
                
                steps.append(createMoveStep(
                    array: elements,
                    indices: [k],
                    description: "选择 \(leftArray[i].value)",
                    delay: animationSpeed
                ))
                
                
                i += 1
            } else {
                // 选择右数组元素
                elements[k] = rightArray[j]
                elements[k].position = k
                elements[k].state = .normal
                
                steps.append(createMoveStep(
                    array: elements,
                    indices: [k],
                    description: "选择 \(rightArray[j].value)",
                    delay: animationSpeed
                ))
                
                
                j += 1
            }
            
            k += 1
        }
        
        // 复制剩余元素
        while i < leftArray.count {
            guard await shouldContinue() else { break }
            
            elements[k] = leftArray[i]
            elements[k].position = k
            elements[k].state = .normal
            
            steps.append(createMoveStep(
                array: elements,
                indices: [k],
                description: "复制剩余左元素 \(leftArray[i].value)",
                delay: animationSpeed
            ))
            
            
            i += 1
            k += 1
        }
        
        while j < rightArray.count {
            guard await shouldContinue() else { break }
            
            elements[k] = rightArray[j]
            elements[k].position = k
            elements[k].state = .normal
            
            steps.append(createMoveStep(
                array: elements,
                indices: [k],
                description: "复制剩余右元素 \(rightArray[j].value)",
                delay: animationSpeed
            ))
            
            
            j += 1
            k += 1
        }
        
        // 标记合并后的区间为已排序
        for index in left...right {
            elements[index].state = .sorted
            elements[index].isSorted = true
        }
        
        steps.append(createHighlightStep(
            array: elements,
            indices: Array(left...right),
            description: "区间 [\(left), \(right)] 合并完成",
            delay: animationSpeed
        ))
        
        
        return steps
    }
}
