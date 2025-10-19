import Foundation

/// 计数排序算法实现
/// 时间复杂度：O(n + k)
/// 空间复杂度：O(k)
/// 稳定性：稳定
public class CountingSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "计数排序", type: .countingSort)
    }
    
    public override func performSort(_ array: [Int], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
        let n = elements.count
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始计数排序",
            delay: animationSpeed
        ))
        
        // 找到最大值和最小值
        let maxValue = elements.map { $0.value }.max() ?? 0
        let minValue = elements.map { $0.value }.min() ?? 0
        let range = maxValue - minValue + 1
        
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "数组范围：[\(minValue), \(maxValue)]，计数数组大小：\(range)",
            delay: animationSpeed
        ))
        
        await waitForAnimation(delay: animationSpeed)
        
        // 创建计数数组
        var count = Array(repeating: 0, count: range)
        
        // 统计每个值的出现次数
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "统计每个值的出现次数",
            delay: animationSpeed
        ))
        
        for i in 0..<n {
            guard await shouldContinue() else { break }
            
            // 等待暂停状态结束
            await waitForResume()
            
            let value = elements[i].value
            let index = value - minValue
            
            elements[i].state = .comparing
            
            steps.append(createCompareStep(
                array: elements,
                indices: [i],
                description: "统计值 \(value)，计数数组索引：\(index)",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            count[index] += 1
            
            elements[i].state = .normal
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [i],
                description: "值 \(value) 出现次数：\(count[index])",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
        }
        
        // 计算累积计数
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "计算累积计数",
            delay: animationSpeed
        ))
        
        for i in 1..<range {
            count[i] += count[i - 1]
        }
        
        await waitForAnimation(delay: animationSpeed)
        
        // 创建输出数组
        var output = Array(repeating: SortingElement(value: 0, position: 0), count: n)
        
        // 根据计数数组重新排列元素
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "根据计数数组重新排列元素",
            delay: animationSpeed
        ))
        
        for i in stride(from: n - 1, through: 0, by: -1) {
            guard await shouldContinue() else { break }
            
            // 等待暂停状态结束
            await waitForResume()
            
            let value = elements[i].value
            let countIndex = value - minValue
            let outputIndex = count[countIndex] - 1
            
            elements[i].state = .comparing
            
            steps.append(createCompareStep(
                array: elements,
                indices: [i],
                description: "值 \(value) 应该放在输出数组的位置 \(outputIndex)",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            // 创建输出元素
            output[outputIndex] = SortingElement(value: value, position: outputIndex)
            output[outputIndex].state = .sorted
            output[outputIndex].isSorted = true
            
            elements[i].state = .normal
            
            steps.append(createMoveStep(
                array: elements,
                indices: [outputIndex],
                description: "将 \(value) 放入输出数组位置 \(outputIndex)",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            count[countIndex] -= 1
        }
        
        // 更新原数组
        elements = output
        
        steps.append(createHighlightStep(
            array: elements,
            indices: Array(0..<n),
            description: "计数排序完成，所有元素已排序",
            delay: animationSpeed
        ))
        
        await waitForAnimation(delay: animationSpeed)
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "计数排序完成！",
            delay: animationSpeed
        ))
        
        return steps
    }
}
