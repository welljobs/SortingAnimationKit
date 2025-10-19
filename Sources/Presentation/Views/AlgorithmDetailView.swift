import SwiftUI

/// 算法详情视图
/// 显示选中算法的详细信息
public struct AlgorithmDetailView: View {
    
    // MARK: - Properties
    
    let algorithm: SortingAlgorithm
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Initialization
    
    public init(algorithm: SortingAlgorithm) {
        self.algorithm = algorithm
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 算法基本信息
                    algorithmInfoSection
                    
                    // 复杂度信息
                    complexitySection
                    
                    // 算法描述
                    descriptionSection
                    
                    // 特点说明
                    featuresSection
                    
                    // 适用场景
                    useCasesSection
                }
                .padding()
            }
            .navigationTitle(algorithm.displayName)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Algorithm Info Section
    
    private var algorithmInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("算法信息")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(title: "中文名称", value: algorithm.displayName)
                InfoRow(title: "英文名称", value: algorithm.englishName)
                InfoRow(title: "算法类型", value: algorithmTypeDescription)
                InfoRow(title: "稳定性", value: algorithm.complexity.stable ? "稳定" : "不稳定")
            }
            .padding()
            .background(Color(NSColor.controlColor))
            .cornerRadius(10)
        }
    }
    
    // MARK: - Complexity Section
    
    private var complexitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("复杂度分析")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ComplexityRow(
                    title: "最好时间复杂度",
                    value: algorithm.complexity.timeBest,
                    color: .green
                )
                
                ComplexityRow(
                    title: "平均时间复杂度",
                    value: algorithm.complexity.timeAverage,
                    color: .blue
                )
                
                ComplexityRow(
                    title: "最坏时间复杂度",
                    value: algorithm.complexity.timeWorst,
                    color: .red
                )
                
                ComplexityRow(
                    title: "空间复杂度",
                    value: algorithm.complexity.space,
                    color: .purple
                )
            }
            .padding()
            .background(Color(NSColor.controlColor))
            .cornerRadius(10)
        }
    }
    
    // MARK: - Description Section
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("算法描述")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(algorithm.description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding()
                .background(Color(NSColor.controlColor))
                .cornerRadius(10)
        }
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("算法特点")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                FeatureRow(
                    icon: "checkmark.circle.fill",
                    text: algorithm.complexity.stable ? "稳定排序" : "不稳定排序",
                    color: algorithm.complexity.stable ? .green : .orange
                )
                
                FeatureRow(
                    icon: "arrow.up.arrow.down",
                    text: "原地排序",
                    color: algorithm.complexity.space == "O(1)" ? .green : .blue
                )
                
                FeatureRow(
                    icon: "clock",
                    text: "时间复杂度: \(algorithm.complexity.timeAverage)",
                    color: .blue
                )
            }
            .padding()
            .background(Color(NSColor.controlColor))
            .cornerRadius(10)
        }
    }
    
    // MARK: - Use Cases Section
    
    private var useCasesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("适用场景")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(useCases, id: \.self) { useCase in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        
                        Text(useCase)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(NSColor.controlColor))
            .cornerRadius(10)
        }
    }
    
    // MARK: - Computed Properties
    
    private var algorithmTypeDescription: String {
        let comparisonAlgorithms: [SortingAlgorithm] = [
            .bubbleSort, .selectionSort, .insertionSort, .shellSort,
            .mergeSort, .quickSort, .heapSort
        ]
        
        if comparisonAlgorithms.contains(algorithm) {
            return "比较排序"
        } else {
            return "非比较排序"
        }
    }
    
    private var useCases: [String] {
        switch algorithm {
        case .bubbleSort:
            return [
                "教学演示排序原理",
                "小规模数据排序",
                "简单实现场景"
            ]
        case .selectionSort:
            return [
                "小规模数据排序",
                "内存受限环境",
                "简单实现场景"
            ]
        case .insertionSort:
            return [
                "小规模数据排序",
                "部分有序数据",
                "混合排序算法的基础"
            ]
        case .shellSort:
            return [
                "中等规模数据排序",
                "需要原地排序的场景",
                "插入排序的改进版本"
            ]
        case .mergeSort:
            return [
                "大规模数据排序",
                "需要稳定排序的场景",
                "外部排序"
            ]
        case .quickSort:
            return [
                "大规模数据排序",
                "平均性能要求高的场景",
                "内存充足的场景"
            ]
        case .heapSort:
            return [
                "大规模数据排序",
                "需要原地排序的场景",
                "优先级队列实现"
            ]
        case .countingSort:
            return [
                "整数排序",
                "数据范围较小的场景",
                "需要稳定排序的场景"
            ]
        case .bucketSort:
            return [
                "均匀分布的数据",
                "浮点数排序",
                "需要稳定排序的场景"
            ]
        case .radixSort:
            return [
                "整数排序",
                "多关键字排序",
                "需要稳定排序的场景"
            ]
        }
    }
}

// MARK: - Supporting Views

/// 信息行
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

/// 复杂度行
struct ComplexityRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color.opacity(0.2))
                .cornerRadius(4)
        }
    }
}

/// 特点行
struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.subheadline)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct AlgorithmDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlgorithmDetailView(algorithm: .quickSort)
    }
}
#endif
