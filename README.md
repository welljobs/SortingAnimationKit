# SortingAnimationKit

一个基于SwiftUI的排序算法动画演示库，采用Clean Architecture + MVVM + Repository + Coordinator架构模式。

## 功能特性

- 🎯 **十大排序算法**：支持冒泡、选择、插入、希尔、归并、快速、堆、计数、桶、基数排序
- 🎨 **精美动画**：使用SwiftUI实现的流畅排序动画效果
- 🏗️ **现代架构**：采用Clean Architecture + MVVM + Repository + Coordinator模式
- ⚡ **异步支持**：基于async/await的现代异步编程
- 🧪 **完整测试**：包含单元测试和性能测试
- 📱 **SwiftUI原生**：完全基于SwiftUI构建，支持iOS 17+

## 支持的排序算法

### 比较排序算法
- **冒泡排序** (Bubble Sort) - O(n²)
- **选择排序** (Selection Sort) - O(n²)
- **插入排序** (Insertion Sort) - O(n²)
- **希尔排序** (Shell Sort) - O(n^1.3)
- **归并排序** (Merge Sort) - O(n log n)
- **快速排序** (Quick Sort) - O(n log n)
- **堆排序** (Heap Sort) - O(n log n)

### 非比较排序算法
- **计数排序** (Counting Sort) - O(n + k)
- **桶排序** (Bucket Sort) - O(n + k)
- **基数排序** (Radix Sort) - O(d(n + k))

## 安装

### Swift Package Manager

在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SortingAnimationKit.git", from: "1.0.0")
]
```

### CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'SortingAnimationKit', '~> 1.0.0'
```

## 快速开始

### 基本使用

```swift
import SwiftUI
import SortingAnimationKit

struct ContentView: View {
    var body: some View {
        SortingAppView()
    }
}
```

### 自定义使用

```swift
import SwiftUI
import SortingAnimationKit

struct CustomSortingView: View {
    @StateObject private var viewModel: SortingViewModel
    @StateObject private var coordinator: SortingCoordinator
    
    init() {
        // 创建依赖
        let repository = SortingRepository()
        let executor = SortingExecutor()
        let generateUseCase = GenerateArrayUseCase(repository: repository)
        let executeUseCase = ExecuteSortingUseCase(repository: repository, executor: executor)
        
        // 创建视图模型和协调器
        self._viewModel = StateObject(wrappedValue: SortingViewModel(
            generateArrayUseCase: generateUseCase,
            executeSortingUseCase: executeUseCase
        ))
        self._coordinator = StateObject(wrappedValue: SortingCoordinator())
    }
    
    var body: some View {
        SortingAnimationView(viewModel: viewModel, coordinator: coordinator)
    }
}
```

## 架构设计

### Clean Architecture

项目采用Clean Architecture分层设计：

```
Sources/
├── Domain/           # 领域层
│   ├── Entities/     # 实体
│   ├── UseCases/     # 用例
│   └── Repositories/ # 仓库接口
├── Data/             # 数据层
│   └── Repositories/ # 仓库实现
├── Presentation/     # 表现层
│   ├── ViewModels/   # 视图模型
│   ├── Views/        # 视图
│   └── Coordinators/ # 协调器
└── Core/             # 核心层
    └── Algorithms/   # 算法实现
```

### 设计模式

- **MVVM**: 视图与业务逻辑分离
- **Repository**: 数据访问抽象
- **Coordinator**: 导航和状态管理
- **Factory**: 算法实例创建
- **Strategy**: 不同排序算法实现

## API 文档

### SortingViewModel

主要的视图模型，管理排序动画的状态和逻辑。

```swift
@MainActor
class SortingViewModel: ObservableObject {
    @Published var elements: [SortingElement] = []
    @Published var isSorting: Bool = false
    @Published var currentAlgorithm: SortingAlgorithm = .bubbleSort
    
    func startSorting()
    func pauseSorting()
    func stopSorting()
    func resetSorting()
    func generateRandomArray()
}
```

### SortingCoordinator

协调器，管理视图之间的导航和状态传递。

```swift
@MainActor
class SortingCoordinator: ObservableObject {
    @Published var currentView: SortingViewType = .main
    @Published var selectedAlgorithm: SortingAlgorithm = .bubbleSort
    
    func navigate(to view: SortingViewType)
    func selectAlgorithm(_ algorithm: SortingAlgorithm)
}
```

### SortingAlgorithm

排序算法枚举，包含算法信息和复杂度分析。

```swift
enum SortingAlgorithm: String, CaseIterable {
    case bubbleSort = "bubble_sort"
    case selectionSort = "selection_sort"
    // ... 其他算法
    
    var displayName: String
    var complexity: AlgorithmComplexity
    var description: String
}
```

## 测试

项目包含完整的单元测试和性能测试：

```bash
# 运行测试
swift test

# 运行特定测试
swift test --filter SortingAlgorithmTests
```

### 测试覆盖

- ✅ 所有排序算法功能测试
- ✅ 边界情况测试（空数组、单元素、已排序等）
- ✅ 性能测试
- ✅ 视图模型测试
- ✅ 仓库测试

## 运行Demo应用

项目提供两种运行方式，支持iOS和macOS多平台：

### 方式一：Xcode GUI应用（推荐）

在Xcode中打开并运行完整的SwiftUI应用：

```bash
# 打开Xcode项目
./run-demo-xcode.sh

# 或者直接打开
open Examples/SortingAnimationDemo.xcodeproj
```

**功能特性：**
- 🎨 完整的SwiftUI界面
- 📱 支持iOS 17.0+ 和 macOS 13.0+
- 🎯 交互式排序动画
- 📊 实时统计信息
- 🔧 算法参数调节

### 方式二：命令行测试工具

快速测试库的功能和算法：

```bash
# 运行命令行测试
./run-demo-cli.sh

# 或者直接运行
swift Scripts/test-demo.swift
```

**功能特性：**
- 🧪 测试所有10种排序算法
- 📈 性能基准测试
- 📋 算法信息展示
- ⚡ 快速验证功能

### 示例应用代码

```swift
@main
struct SortingAnimationDemoApp: App {
    var body: some Scene {
        WindowGroup {
            SortingAppView()
        }
    }
}
```

## 贡献

欢迎贡献代码！请遵循以下步骤：

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系方式

- 项目链接: [https://github.com/yourusername/SortingAnimationKit](https://github.com/yourusername/SortingAnimationKit)
- 问题反馈: [Issues](https://github.com/yourusername/SortingAnimationKit/issues)

## 致谢

- 感谢所有排序算法的经典实现
- 感谢SwiftUI团队提供的优秀框架
- 感谢所有贡献者的支持
