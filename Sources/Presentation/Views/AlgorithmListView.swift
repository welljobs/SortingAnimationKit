import SwiftUI

/// 算法列表视图
/// 显示所有支持的排序算法
public struct AlgorithmListView: View {
    
    // MARK: - Properties
    
    @StateObject private var coordinator: SortingCoordinator
    @State private var searchText = ""
    
    // MARK: - Initialization
    
    public init(coordinator: SortingCoordinator) {
        self._coordinator = StateObject(wrappedValue: coordinator)
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack {
                // 搜索栏
                SearchBar(text: $searchText)
                
                // 算法列表
                List {
                    // 比较排序算法
                    Section("比较排序算法") {
                        ForEach(filteredComparisonAlgorithms) { algorithm in
                            AlgorithmRowView(
                                algorithm: algorithm,
                                isSelected: algorithm == coordinator.selectedAlgorithm
                            ) {
                                coordinator.selectAlgorithm(algorithm)
                                coordinator.navigate(to: .algorithmDetail)
                            }
                        }
                    }
                    
                    // 非比较排序算法
                    Section("非比较排序算法") {
                        ForEach(filteredNonComparisonAlgorithms) { algorithm in
                            AlgorithmRowView(
                                algorithm: algorithm,
                                isSelected: algorithm == coordinator.selectedAlgorithm
                            ) {
                                coordinator.selectAlgorithm(algorithm)
                                coordinator.navigate(to: .algorithmDetail)
                            }
                        }
                    }
                }
                #if os(iOS)
                .listStyle(.insetGrouped)
                #else
                .listStyle(.inset)
                #endif
        }
    }
    
    // MARK: - Computed Properties
    
    private var filteredComparisonAlgorithms: [SortingAlgorithm] {
        let algorithms = coordinator.getComparisonAlgorithms()
        if searchText.isEmpty {
            return algorithms
        } else {
            return algorithms.filter { algorithm in
                algorithm.displayName.localizedCaseInsensitiveContains(searchText) ||
                algorithm.englishName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private var filteredNonComparisonAlgorithms: [SortingAlgorithm] {
        let algorithms = coordinator.getNonComparisonAlgorithms()
        if searchText.isEmpty {
            return algorithms
        } else {
            return algorithms.filter { algorithm in
                algorithm.displayName.localizedCaseInsensitiveContains(searchText) ||
                algorithm.englishName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

/// 算法行视图
struct AlgorithmRowView: View {
    let algorithm: SortingAlgorithm
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(algorithm.displayName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(algorithm.englishName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(algorithm.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                    
                    // 复杂度信息
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("时间复杂度")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text(algorithm.complexity.timeAverage)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// 搜索栏
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("搜索算法...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

#if DEBUG
struct AlgorithmListView_Previews: PreviewProvider {
    static var previews: some View {
        AlgorithmListView(coordinator: SortingCoordinator())
    }
}
#endif
