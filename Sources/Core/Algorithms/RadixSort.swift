import Foundation

/// 基数排序算法实现
/// 时间复杂度：O(d(n + k))
/// 空间复杂度：O(n + k)
/// 稳定性：稳定
public class RadixSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "基数排序", type: .radixSort)
    }
    
    public override func performSort(_ array: [Int], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
        let n = elements.count
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始基数排序",
            delay: animationSpeed
        ))
        
        // 找到最大值
        let maxValue = elements.map { $0.value }.max() ?? 0
        
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "最大值：\(maxValue)，需要 \(String(maxValue).count) 位数字",
            delay: animationSpeed
        ))
        
        await waitForAnimation(delay: animationSpeed)
        
        // 按每一位进行计数排序
        var exp = 1
        while maxValue / exp > 0 {
            guard await shouldContinue() else { break }
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [],
                description: "按第 \(String(exp).count) 位数字排序",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            // 执行计数排序
            let countingSteps = try await countingSortByDigit(&elements, exp: exp, animationSpeed: animationSpeed)
            steps.append(contentsOf: countingSteps)
            
            exp *= 10
        }
        
        // 标记所有元素为已排序
        for i in 0..<n {
            elements[i].state = .sorted
            elements[i].isSorted = true
        }
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "基数排序完成！",
            delay: animationSpeed
        ))
        
        return steps
    }
    
    /// 按指定位数进行计数排序
    private func countingSortByDigit(_ elements: inout [SortingElement], exp: Int, animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        let n = elements.count
        
        // 创建计数数组
        var count = Array(repeating: 0, count: 10)
        
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "统计第 \(String(exp).count) 位数字的出现次数",
            delay: animationSpeed
        ))
        
        // 统计每个数字的出现次数
        for i in 0..<n {
            guard await shouldContinue() else { break }
            
            // 等待暂停状态结束
            await waitForResume()
            
            let digit = (elements[i].value / exp) % 10
            
            elements[i].state = .comparing
            
            steps.append(createCompareStep(
                array: elements,
                indices: [i],
                description: "值 \(elements[i].value) 的第 \(String(exp).count) 位数字是 \(digit)",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            count[digit] += 1
            
            elements[i].state = .normal
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [i],
                description: "数字 \(digit) 出现次数：\(count[digit])",
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
        
        for i in 1..<10 {
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
            let digit = (value / exp) % 10
            let outputIndex = count[digit] - 1
            
            elements[i].state = .comparing
            
            steps.append(createCompareStep(
                array: elements,
                indices: [i],
                description: "值 \(value) 的第 \(String(exp).count) 位数字是 \(digit)，应该放在位置 \(outputIndex)",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            // 创建输出元素
            output[outputIndex] = SortingElement(value: value, position: outputIndex)
            output[outputIndex].state = .normal
            
            elements[i].state = .normal
            
            steps.append(createMoveStep(
                array: elements,
                indices: [outputIndex],
                description: "将 \(value) 放入位置 \(outputIndex)",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            count[digit] -= 1
        }
        
        // 更新原数组
        elements = output
        
        steps.append(createHighlightStep(
            array: elements,
            indices: Array(0..<n),
            description: "第 \(String(exp).count) 位数字排序完成",
            delay: animationSpeed
        ))
        
        await waitForAnimation(delay: animationSpeed)
        
        return steps
    }
}
