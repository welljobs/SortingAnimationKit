import Foundation
import SwiftUI

/// 排序动画协调器
/// 负责管理视图之间的导航和状态传递
@MainActor
public class SortingCoordinator: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 当前显示的视图
    @Published public var currentView: SortingViewType = .main
    
    /// 导航路径
    @Published public var navigationPath: [SortingViewType] = []
    
    /// 选中的算法
    @Published public var selectedAlgorithm: SortingAlgorithm = .bubbleSort
    
    /// 是否显示算法详情
    @Published public var showAlgorithmDetail: Bool = false
    
    /// 是否显示设置
    @Published public var showSettings: Bool = false
    
    // MARK: - Private Properties
    
    private let algorithmFactory: SortingAlgorithmFactory
    
    // MARK: - Initialization
    
    public init(algorithmFactory: SortingAlgorithmFactory = .shared) {
        self.algorithmFactory = algorithmFactory
    }
    
    // MARK: - Public Methods
    
    /// 导航到指定视图
    public func navigate(to view: SortingViewType) {
        currentView = view
        navigationPath.append(view)
    }
    
    /// 返回上一页
    public func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
            currentView = navigationPath.last ?? .main
        }
    }
    
    /// 返回主页
    public func goToMain() {
        currentView = .main
        navigationPath.removeAll()
    }
    
    /// 选择算法
    public func selectAlgorithm(_ algorithm: SortingAlgorithm) {
        selectedAlgorithm = algorithm
    }
    
    /// 显示算法详情
    public func showAlgorithmDetail(_ algorithm: SortingAlgorithm) {
        selectedAlgorithm = algorithm
        showAlgorithmDetail = true
    }
    
    /// 隐藏算法详情
    public func hideAlgorithmDetail() {
        showAlgorithmDetail = false
    }
    
    /// 显示设置
    public func presentSettings() {
        showSettings = true
    }
    
    /// 隐藏设置
    public func hideSettings() {
        showSettings = false
    }
    
    /// 获取所有支持的算法
    public func getAllAlgorithms() -> [SortingAlgorithm] {
        return algorithmFactory.getAllAlgorithms()
    }
    
    /// 获取比较排序算法
    public func getComparisonAlgorithms() -> [SortingAlgorithm] {
        return algorithmFactory.getComparisonAlgorithms()
    }
    
    /// 获取非比较排序算法
    public func getNonComparisonAlgorithms() -> [SortingAlgorithm] {
        return algorithmFactory.getNonComparisonAlgorithms()
    }
}

/// 排序视图类型枚举
public enum SortingViewType: CaseIterable, Identifiable {
    case main
    case algorithmList
    case algorithmDetail
    case settings
    case statistics
    
    public var id: String {
        switch self {
        case .main:
            return "main"
        case .algorithmList:
            return "algorithmList"
        case .algorithmDetail:
            return "algorithmDetail"
        case .settings:
            return "settings"
        case .statistics:
            return "statistics"
        }
    }
    
    public var title: String {
        switch self {
        case .main:
            return "排序动画"
        case .algorithmList:
            return "算法列表"
        case .algorithmDetail:
            return "算法详情"
        case .settings:
            return "设置"
        case .statistics:
            return "统计信息"
        }
    }
}
