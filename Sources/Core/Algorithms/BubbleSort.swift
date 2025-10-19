import Foundation

/// 冒泡排序算法实现
/// 时间复杂度：O(n²)
/// 空间复杂度：O(1)
/// 稳定性：稳定
public class BubbleSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "冒泡排序", type: .bubbleSort)
    }
    
    public override func performSort(_ array: [Int], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
        let n = elements.count
        
        // 处理空数组
        if n == 0 {
            return steps
        }
        
        // 处理单元素数组
        if n == 1 {
            elements[0].state = .sorted
            elements[0].isSorted = true
            steps.append(createSortedStep(
                array: elements,
                description: "单元素数组已排序",
                delay: animationSpeed
            ))
            return steps
        }
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始冒泡排序",
            delay: animationSpeed
        ))
        
        for i in 0..<n {
            guard await shouldContinue() else { break }
            
            var swapped = false
            
            // 添加当前轮次开始步骤
            steps.append(createHighlightStep(
                array: elements,
                indices: [i],
                description: "第 \(i + 1) 轮排序开始",
                delay: animationSpeed
            ))
            
            for j in 0..<n - i - 1 {
                guard await shouldContinue() else { break }
                
                // 等待暂停状态结束
                await waitForResume()
                
                // 比较相邻元素
                elements[j].state = .comparing
                elements[j + 1].state = .comparing
                
                steps.append(createCompareStep(
                    array: elements,
                    indices: [j, j + 1],
                    description: "比较 \(elements[j].value) 和 \(elements[j + 1].value)",
                    delay: animationSpeed
                ))
                
                await waitForAnimation(delay: animationSpeed)
                
                if elements[j].value > elements[j + 1].value {
                    // 交换元素
                    elements[j].state = .swapping
                    elements[j + 1].state = .swapping
                    
                    steps.append(createSwapStep(
                        array: elements,
                        indices: [j, j + 1],
                        description: "交换 \(elements[j].value) 和 \(elements[j + 1].value)",
                        delay: animationSpeed
                    ))
                    
                    await waitForAnimation(delay: animationSpeed)
                    
                    // 执行交换
                    let temp = elements[j]
                    elements[j] = elements[j + 1]
                    elements[j + 1] = temp
                    
                    // 更新位置
                    elements[j].position = j
                    elements[j + 1].position = j + 1
                    
                    swapped = true
                }
                
                // 重置状态
                elements[j].state = .normal
                elements[j + 1].state = .normal
            }
            
            // 标记已排序的元素
            elements[n - i - 1].state = .sorted
            elements[n - i - 1].isSorted = true
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [n - i - 1],
                description: "第 \(n - i - 1) 个位置已排序",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            // 如果没有发生交换，说明数组已经有序
            if !swapped {
                // 标记所有剩余元素为已排序
                for k in 0..<n - i - 1 {
                    elements[k].state = .sorted
                    elements[k].isSorted = true
                }
                
                steps.append(createHighlightStep(
                    array: elements,
                    indices: Array(0..<n - i - 1),
                    description: "数组已有序，提前结束",
                    delay: animationSpeed
                ))
                
                break
            }
        }
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "冒泡排序完成！",
            delay: animationSpeed
        ))
        
        return steps
    }
}
