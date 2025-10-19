import Foundation

/// 堆排序算法实现
/// 时间复杂度：O(n log n)
/// 空间复杂度：O(1)
/// 稳定性：不稳定
public class HeapSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "堆排序", type: .heapSort)
    }
    
    public override func performSort(_ elements: [SortingElement], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = elements
        let n = elements.count
        
        print("🔧 HeapSort: 开始堆排序，数组大小: \(elements.count)")
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始堆排序",
            delay: animationSpeed
        ))
        
        // 构建最大堆
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "构建最大堆",
            delay: animationSpeed
        ))
        
        for i in stride(from: n / 2 - 1, through: 0, by: -1) {
            guard await shouldContinue() else { break }
            
            let heapifySteps = try await heapify(&elements, n: n, i: i, animationSpeed: animationSpeed)
            steps.append(contentsOf: heapifySteps)
        }
        
        // 逐个提取元素
        for i in stride(from: n - 1, to: 0, by: -1) {
            guard await shouldContinue() else { break }
            
            // 交换根节点和最后一个节点
            elements[0].state = .swapping
            elements[i].state = .swapping
            
            steps.append(createSwapStep(
                array: elements,
                indices: [0, i],
                description: "交换根节点 \(elements[0].value) 和位置 \(i) 的元素 \(elements[i].value)",
                delay: animationSpeed
            ))
            
            
            // 执行交换
            let temp = elements[0]
            elements[0] = elements[i]
            elements[i] = temp
            
            // 更新位置
            elements[0].position = 0
            elements[i].position = i
            
            // 标记已排序的元素
            elements[i].state = .sorted
            elements[i].isSorted = true
            
            steps.append(createHighlightStep(
                array: elements,
                indices: [i],
                description: "位置 \(i) 已排序，值为 \(elements[i].value)",
                delay: animationSpeed
            ))
            
            
            // 重新堆化
            let heapifySteps = try await heapify(&elements, n: i, i: 0, animationSpeed: animationSpeed)
            steps.append(contentsOf: heapifySteps)
        }
        
        // 标记第一个元素为已排序
        elements[0].state = .sorted
        elements[0].isSorted = true
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "堆排序完成！",
            delay: animationSpeed
        ))
        
        print("✅ HeapSort: 堆排序完成，生成 \(steps.count) 个步骤")
        return steps
    }
    
    /// 堆化操作
    private func heapify(_ elements: inout [SortingElement], n: Int, i: Int, animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        
        guard await shouldContinue() else { return steps }
        
        var largest = i
        let left = 2 * i + 1
        let right = 2 * i + 2
        
        // 标记当前节点
        elements[i].state = .comparing
        
        steps.append(createHighlightStep(
            array: elements,
            indices: [i],
            description: "堆化节点 \(i)，值为 \(elements[i].value)",
            delay: animationSpeed
        ))
        
        
        // 比较左子节点
        if left < n {
            elements[left].state = .comparing
            
            steps.append(createCompareStep(
                array: elements,
                indices: [i, left],
                description: "比较父节点 \(elements[i].value) 和左子节点 \(elements[left].value)",
                delay: animationSpeed
            ))
            
            
            if elements[left].value > elements[largest].value {
                largest = left
                
                steps.append(createHighlightStep(
                    array: elements,
                    indices: [left],
                    description: "左子节点更大，更新最大值索引",
                    delay: animationSpeed
                ))
                
            }
            
            elements[left].state = .normal
        }
        
        // 比较右子节点
        if right < n {
            elements[right].state = .comparing
            
            steps.append(createCompareStep(
                array: elements,
                indices: [largest, right],
                description: "比较当前最大值 \(elements[largest].value) 和右子节点 \(elements[right].value)",
                delay: animationSpeed
            ))
            
            
            if elements[right].value > elements[largest].value {
                largest = right
                
                steps.append(createHighlightStep(
                    array: elements,
                    indices: [right],
                    description: "右子节点更大，更新最大值索引",
                    delay: animationSpeed
                ))
                
            }
            
            elements[right].state = .normal
        }
        
        // 如果最大值不是根节点，则交换并递归堆化
        if largest != i {
            elements[i].state = .swapping
            elements[largest].state = .swapping
            
            steps.append(createSwapStep(
                array: elements,
                indices: [i, largest],
                description: "交换节点 \(i) 和 \(largest)",
                delay: animationSpeed
            ))
            
            
            // 执行交换
            let temp = elements[i]
            elements[i] = elements[largest]
            elements[largest] = temp
            
            // 更新位置
            elements[i].position = i
            elements[largest].position = largest
            
            // 重置状态
            elements[i].state = .normal
            elements[largest].state = .normal
            
            // 递归堆化
            let recursiveSteps = try await heapify(&elements, n: n, i: largest, animationSpeed: animationSpeed)
            steps.append(contentsOf: recursiveSteps)
        } else {
            elements[i].state = .normal
        }
        
        return steps
    }
}
