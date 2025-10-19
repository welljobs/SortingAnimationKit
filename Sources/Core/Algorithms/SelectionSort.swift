import Foundation

/// 选择排序算法实现
/// 时间复杂度：O(n²)
/// 空间复杂度：O(1)
/// 稳定性：不稳定
public class SelectionSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "选择排序", type: .selectionSort)
    }
    
    public override func performSort(_ array: [Int], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
        let n = elements.count
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始选择排序",
            delay: animationSpeed
        ))
        
        for i in 0..<n - 1 {
            guard await shouldContinue() else { break }
            
            var minIndex = i
            
            // 标记当前最小值
            elements[i].state = .min
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [i],
                description: "第 \(i + 1) 轮：假设位置 \(i) 为最小值",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            // 在未排序部分中寻找最小值
            for j in i + 1..<n {
                guard await shouldContinue() else { break }
                
                // 等待暂停状态结束
                await waitForResume()
                
                // 比较当前元素与最小值
                elements[j].state = .comparing
                elements[minIndex].state = .comparing
                
                steps.append(createCompareStep(
                    array: elements,
                    indices: [j, minIndex],
                    description: "比较 \(elements[j].value) 和当前最小值 \(elements[minIndex].value)",
                    delay: animationSpeed
                ))
                
                await waitForAnimation(delay: animationSpeed)
                
                if elements[j].value < elements[minIndex].value {
                    // 更新最小值索引
                    elements[minIndex].state = .normal
                    minIndex = j
                    elements[minIndex].state = .min
                    
                    steps.append(createHighlightStep(
                        array: elements,
                        indices: [minIndex],
                        description: "找到新的最小值 \(elements[minIndex].value)",
                        delay: animationSpeed
                    ))
                    
                    await waitForAnimation(delay: animationSpeed)
                } else {
                    // 重置比较状态
                    elements[j].state = .normal
                    elements[minIndex].state = .min
                }
            }
            
            // 如果最小值不是当前位置，则交换
            if minIndex != i {
                // 标记要交换的元素
                elements[i].state = .swapping
                elements[minIndex].state = .swapping
                
                steps.append(createSwapStep(
                    array: elements,
                    indices: [i, minIndex],
                    description: "交换位置 \(i) 和 \(minIndex) 的元素",
                    delay: animationSpeed
                ))
                
                await waitForAnimation(delay: animationSpeed)
                
                // 执行交换
                let temp = elements[i]
                elements[i] = elements[minIndex]
                elements[minIndex] = temp
                
                // 更新位置
                elements[i].position = i
                elements[minIndex].position = minIndex
                
                // 重置状态
                elements[i].state = .sorted
                elements[minIndex].state = .normal
            } else {
                // 当前位置就是最小值
                elements[i].state = .sorted
            }
            
            // 标记已排序的元素
            elements[i].isSorted = true
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [i],
                description: "位置 \(i) 已排序，值为 \(elements[i].value)",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
        }
        
        // 标记最后一个元素为已排序
        elements[n - 1].state = .sorted
        elements[n - 1].isSorted = true
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "选择排序完成！",
            delay: animationSpeed
        ))
        
        return steps
    }
}
