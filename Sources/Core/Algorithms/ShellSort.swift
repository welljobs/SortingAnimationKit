import Foundation

/// 希尔排序算法实现
/// 时间复杂度：O(n^1.3) 平均，O(n²) 最坏
/// 空间复杂度：O(1)
/// 稳定性：不稳定
public class ShellSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "希尔排序", type: .shellSort)
    }
    
    public override func performSort(_ array: [Int], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = array.enumerated().map { SortingElement(value: $0.element, position: $0.offset) }
        let n = elements.count
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始希尔排序",
            delay: animationSpeed
        ))
        
        // 使用希尔增量序列
        var gap = n / 2
        
        while gap > 0 {
            guard await shouldContinue() else { break }
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [],
                description: "使用间隔 \(gap) 进行插入排序",
                delay: animationSpeed
            ))
            
            await waitForAnimation(delay: animationSpeed)
            
            // 对每个间隔进行插入排序
            for i in gap..<n {
                guard await shouldContinue() else { break }
                
                // 等待暂停状态结束
                await waitForResume()
                
                let temp = elements[i]
                var j = i
                
                // 标记当前要插入的元素
                elements[i].state = .comparing
                
                steps.append(createHighlightStep(
                    array: elements,
                    indices: [i],
                    description: "准备插入元素 \(temp.value)（间隔 \(gap)）",
                    delay: animationSpeed
                ))
                
                await waitForAnimation(delay: animationSpeed)
                
                // 在间隔为gap的已排序部分中寻找插入位置
                while j >= gap {
                    guard await shouldContinue() else { break }
                    
                    // 等待暂停状态结束
                    await waitForResume()
                    
                    // 比较当前元素与间隔为gap的前一个元素
                    elements[j].state = .comparing
                    elements[j - gap].state = .comparing
                    
                    steps.append(createCompareStep(
                        array: elements,
                        indices: [j, j - gap],
                        description: "比较 \(elements[j].value) 和 \(elements[j - gap].value)（间隔 \(gap)）",
                        delay: animationSpeed
                    ))
                    
                    await waitForAnimation(delay: animationSpeed)
                    
                    if elements[j - gap].value > temp.value {
                        // 需要继续向前移动
                        elements[j].state = .normal
                        elements[j - gap].state = .normal
                        
                        steps.append(createMoveStep(
                            array: elements,
                            indices: [j, j - gap],
                            description: "\(elements[j - gap].value) > \(temp.value)，继续向前移动",
                            delay: animationSpeed
                        ))
                        
                        await waitForAnimation(delay: animationSpeed)
                        
                        // 移动元素
                        elements[j] = elements[j - gap]
                        elements[j].position = j
                        
                        j -= gap
                    } else {
                        // 找到插入位置
                        elements[j].state = .normal
                        elements[j - gap].state = .normal
                        
                        steps.append(createHighlightStep(
                            array: elements,
                            indices: [j],
                            description: "找到插入位置：\(j)",
                            delay: animationSpeed
                        ))
                        
                        await waitForAnimation(delay: animationSpeed)
                        break
                    }
                }
                
                // 插入元素
                elements[j] = temp
                elements[j].position = j
                elements[j].state = .normal
                
                steps.append(createMoveStep(
                    array: elements,
                    indices: [j],
                    description: "插入元素 \(temp.value) 到位置 \(j)",
                    delay: animationSpeed
                ))
                
                await waitForAnimation(delay: animationSpeed)
            }
            
            // 减少间隔
            gap /= 2
            
            if gap > 0 {
                steps.append(createHighlightStep(
                    array: elements,
                    indices: [],
                    description: "减少间隔到 \(gap)",
                    delay: animationSpeed
                ))
                
                await waitForAnimation(delay: animationSpeed)
            }
        }
        
        // 标记所有元素为已排序
        for i in 0..<n {
            elements[i].state = .sorted
            elements[i].isSorted = true
        }
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "希尔排序完成！",
            delay: animationSpeed
        ))
        
        return steps
    }
}
