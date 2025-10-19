#!/bin/bash

# SortingAnimationKit Demo - Xcode启动脚本
# 此脚本会打开Xcode项目，支持iOS和macOS多平台

echo "🎯 启动 SortingAnimationKit Demo (Xcode)"
echo "=================================="

# 检查Xcode是否安装
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ 错误: 未找到Xcode，请先安装Xcode"
    exit 1
fi

# 检查项目文件是否存在
PROJECT_PATH="Examples/SortingAnimationDemo.xcodeproj"
if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ 错误: 未找到Xcode项目文件: $PROJECT_PATH"
    exit 1
fi

echo "📱 支持的平台:"
echo "   • iOS 17.0+"
echo "   • macOS 12.0+"
echo ""

echo "🚀 正在打开Xcode项目..."
open "$PROJECT_PATH"

echo "✅ Xcode项目已打开!"
echo ""
echo "💡 使用说明:"
echo "   1. 在Xcode中选择目标设备 (iOS模拟器或Mac)"
echo "   2. 点击运行按钮 (⌘+R) 启动应用"
echo "   3. 体验完整的排序算法动画界面"
echo ""
echo "🔧 项目配置:"
echo "   • 主应用: SortingAnimationDemoApp.swift"
echo "   • 主视图: ContentView.swift"
echo "   • 依赖库: SortingAnimationKit (本地路径)"
