import Foundation

/// 桶排序算法实现
/// 时间复杂度：O(n + k) 平均，O(n²) 最坏
/// 空间复杂度：O(n + k)
/// 稳定性：稳定
public class BucketSort: BaseSortingAlgorithm {
    
    public init() {
        super.init(name: "桶排序", type: .bucketSort)
    }
    
    public override func performSort(_ elements: [SortingElement], animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        var elements = elements
        let n = elements.count
        
        print("🔧 BucketSort: 开始桶排序，数组大小: \(elements.count)")
        
        // 添加初始状态步骤
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "开始桶排序",
            delay: animationSpeed
        ))
        
        // 找到最大值和最小值
        let maxValue = elements.map { $0.value }.max() ?? 0
        let minValue = elements.map { $0.value }.min() ?? 0
        
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "数组范围：[\(minValue), \(maxValue)]",
            delay: animationSpeed
        ))
        
        
        // 创建桶
        let bucketCount = n
        var buckets: [[SortingElement]] = Array(repeating: [], count: bucketCount)
        
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "创建 \(bucketCount) 个桶",
            delay: animationSpeed
        ))
        
        
        // 将元素分配到桶中
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "将元素分配到桶中",
            delay: animationSpeed
        ))
        
        for i in 0..<n {
            guard await shouldContinue() else { break }
            
            // 等待暂停状态结束
            await waitForResume()
            
            let value = elements[i].value
            let bucketIndex = min(Int(Double(value - minValue) / Double(maxValue - minValue) * Double(bucketCount - 1)), bucketCount - 1)
            
            elements[i].state = .comparing
            
            steps.append(createCompareStep(
                array: elements,
                indices: [i],
                description: "值 \(value) 分配到桶 \(bucketIndex)",
                delay: animationSpeed
            ))
            
            
            // 将元素添加到桶中
            var element = elements[i]
            element.position = buckets[bucketIndex].count
            buckets[bucketIndex].append(element)
            
            elements[i].state = .normal
            
            steps.append(createMoveStep(
                array: elements,
                indices: [i],
                description: "将 \(value) 放入桶 \(bucketIndex)",
                delay: animationSpeed
            ))
            
        }
        
        // 对每个桶进行排序
        steps.append(createHighlightStep(
            array: elements,
            indices: [],
            description: "对每个桶进行排序",
            delay: animationSpeed
        ))
        
        
        var sortedElements: [SortingElement] = []
        var currentPosition = 0
        
        for bucketIndex in 0..<bucketCount {
            guard await shouldContinue() else { break }
            
            if !buckets[bucketIndex].isEmpty {
                steps.append(createHighlightStep(
                    array: elements,
                    indices: [],
                    description: "排序桶 \(bucketIndex)（包含 \(buckets[bucketIndex].count) 个元素）",
                    delay: animationSpeed
                ))
                
                
                // 对桶进行插入排序
                let bucketSteps = try await insertionSortBucket(&buckets[bucketIndex], bucketIndex: bucketIndex, animationSpeed: animationSpeed)
                steps.append(contentsOf: bucketSteps)
                
                // 将排序后的桶元素添加到结果中
                for element in buckets[bucketIndex] {
                    var sortedElement = element
                    sortedElement.position = currentPosition
                    sortedElement.state = .sorted
                    sortedElement.isSorted = true
                    sortedElements.append(sortedElement)
                    currentPosition += 1
                }
                
                steps.append(createHighlightStep(
                    array: elements,
                    indices: [],
                    description: "桶 \(bucketIndex) 排序完成",
                    delay: animationSpeed
                ))
                
            }
        }
        
        // 更新原数组
        elements = sortedElements
        
        steps.append(createHighlightStep(
            array: elements,
            indices: Array(0..<n),
            description: "桶排序完成，所有元素已排序",
            delay: animationSpeed
        ))
        
        
        // 添加排序完成步骤
        steps.append(createSortedStep(
            array: elements,
            description: "桶排序完成！",
            delay: animationSpeed
        ))
        
        print("✅ BucketSort: 桶排序完成，生成 \(steps.count) 个步骤")
        return steps
    }
    
    /// 对桶进行插入排序
    private func insertionSortBucket(_ bucket: inout [SortingElement], bucketIndex: Int, animationSpeed: Int) async throws -> [SortingStep] {
        var steps: [SortingStep] = []
        
        guard bucket.count > 1 else { return steps }
        
        for i in 1..<bucket.count {
            guard await shouldContinue() else { break }
            
            // 等待暂停状态结束
            await waitForResume()
            
            let key = bucket[i]
            var j = i - 1
            
            // 标记当前要插入的元素
            bucket[i].state = .comparing
            
            steps.append(createCompareStep(
                array: bucket,
                indices: [i],
                description: "桶 \(bucketIndex)：准备插入元素 \(key.value)",
                delay: animationSpeed
            ))
            
            
            // 在已排序部分中寻找插入位置
            while j >= 0 {
                guard await shouldContinue() else { break }
                
                // 等待暂停状态结束
                await waitForResume()
                
                // 比较当前元素与已排序部分的元素
                bucket[j].state = .comparing
                bucket[i].state = .comparing
                
                steps.append(createCompareStep(
                    array: bucket,
                    indices: [j, i],
                    description: "桶 \(bucketIndex)：比较 \(bucket[j].value) 和 \(bucket[i].value)",
                    delay: animationSpeed
                ))
                
                
                if bucket[j].value > key.value {
                    // 需要继续向左移动
                    bucket[j].state = .normal
                    bucket[i].state = .normal
                    
                    steps.append(createMoveStep(
                        array: bucket,
                        indices: [j, i],
                        description: "桶 \(bucketIndex)：\(bucket[j].value) > \(key.value)，继续向左寻找",
                        delay: animationSpeed
                    ))
                    
                    
                    // 移动元素
                    bucket[j + 1] = bucket[j]
                    bucket[j + 1].position = j + 1
                    
                    j -= 1
                } else {
                    // 找到插入位置
                    bucket[j].state = .normal
                    bucket[i].state = .normal
                    
                    steps.append(createHighlightStep(
                        array: bucket,
                        indices: [j + 1],
                        description: "桶 \(bucketIndex)：找到插入位置：\(j + 1)",
                        delay: animationSpeed
                    ))
                    
                    break
                }
            }
            
            // 插入元素
            bucket[j + 1] = key
            bucket[j + 1].position = j + 1
            bucket[j + 1].state = .normal
            
            steps.append(createMoveStep(
                array: bucket,
                indices: [j + 1],
                description: "桶 \(bucketIndex)：插入元素 \(key.value) 到位置 \(j + 1)",
                delay: animationSpeed
            ))
            
        }
        
        return steps
    }
}
