import Foundation

/// 插入排序算法实现
/// 时间复杂度：O(n²)
/// 空间复杂度：O(1)
/// 稳定性：稳定
public class InsertionSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "插入排序", type: .insertionSort)
    }
    
    public override func performSort(_ elements: [SortingElement], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = elements
        let n = elements.count
        
        print("🔧 InsertionSort: 开始插入排序，数组大小: \(n)")
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始插入排序",
            delay: animationSpeed
        ))
        
        // 标记第一个元素为已排序
        elements[0].state = .sorted
        elements[0].isSorted = true
        
        steps.append(createHighlightStep(
            array: elements,
            indices: [0],
            description: "第一个元素 \(elements[0].value) 已排序",
            delay: animationSpeed
        ))
        
        for i in 1..<n {
            guard await shouldContinue() else { break }
            
            let key = elements[i]
            var j = i - 1
            
            // 标记当前要插入的元素
            elements[i].state = .comparing
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [i],
                description: "准备插入元素 \(key.value)",
                delay: animationSpeed
            ))
            
            // 在已排序部分中寻找插入位置
            while j >= 0 {
                guard await shouldContinue() else { break }
                
                // 等待暂停状态结束
                await waitForResume()
                
                // 比较当前元素与已排序部分的元素
                elements[j].state = .comparing
                elements[i].state = .comparing
                
                steps.append(createCompareStep(
                    array: elements,
                    indices: [j, i],
                    description: "比较 \(elements[j].value) 和 \(elements[i].value)",
                    delay: animationSpeed
                ))
                
                if elements[j].value > key.value {
                    // 需要继续向左移动
                    elements[j].state = .normal
                    elements[i].state = .normal
                    
                    steps.append(createMoveStep(
                        array: elements,
                        indices: [j, i],
                        description: "\(elements[j].value) > \(key.value)，继续向左寻找",
                        delay: animationSpeed
                    ))
                    
                    j -= 1
                } else {
                    // 找到插入位置
                    elements[j].state = .normal
                    elements[i].state = .normal
                    
                    steps.append(createHighlightStep(
                        array: elements,
                        indices: [j + 1],
                        description: "找到插入位置：\(j + 1)",
                        delay: animationSpeed
                    ))
                    
                    break
                }
            }
            
            // 执行插入操作
            if j + 1 != i {
                // 标记要移动的元素
                for k in (j + 1)...i {
                    elements[k].state = .swapping
                }
                
                steps.append(createSwapStep(
                    array: elements,
                    indices: Array((j + 1)...i),
                    description: "将元素 \(key.value) 插入到位置 \(j + 1)",
                    delay: animationSpeed
                ))
                
                // 移动元素
                for k in stride(from: i, to: j + 1, by: -1) {
                    elements[k] = elements[k - 1]
                    elements[k].position = k
                }
                
                // 插入元素
                elements[j + 1] = key
                elements[j + 1].position = j + 1
                elements[j + 1].state = .sorted
                elements[j + 1].isSorted = true
                
                // 重置其他元素状态
                for k in 0..<j + 1 {
                    elements[k].state = .sorted
                }
                for k in j + 2..<n {
                    elements[k].state = .normal
                }
            } else {
                // 元素已经在正确位置
                elements[i].state = .sorted
                elements[i].isSorted = true
            }
            
            steps.append(createHighlightStep(
                array: elements,
                indices: Array(0...i),
                description: "前 \(i + 1) 个元素已排序",
                delay: animationSpeed
            ))
        }
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "插入排序完成！",
            delay: animationSpeed
        ))
        
        print("✅ InsertionSort: 插入排序完成，生成 \(steps.count) 个步骤")
        return steps
    }
}
