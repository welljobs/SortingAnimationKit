#!/bin/bash

# SortingAnimationKit Demo - 命令行测试脚本
# 此脚本会运行命令行测试工具，展示库的功能

echo "🎯 启动 SortingAnimationKit Demo (命令行)"
echo "====================================="

# 检查Swift是否安装
if ! command -v swift &> /dev/null; then
    echo "❌ 错误: 未找到Swift，请先安装Swift"
    exit 1
fi

# 检查测试脚本是否存在
TEST_SCRIPT="Scripts/test-demo.swift"
if [ ! -f "$TEST_SCRIPT" ]; then
    echo "❌ 错误: 未找到测试脚本: $TEST_SCRIPT"
    exit 1
fi

echo "📱 支持平台: macOS, Linux"
echo "🔧 Swift版本: $(swift --version | head -n1)"
echo ""

echo "🚀 正在运行命令行测试..."
echo ""

# 运行测试脚本
swift "$TEST_SCRIPT"

echo ""
echo "✅ 命令行测试完成!"
echo ""
echo "💡 其他运行方式:"
echo "   • Xcode GUI: ./run-demo-xcode.sh"
echo "   • 直接运行: swift Scripts/test-demo.swift"
echo "   • 构建库: swift build"
echo "   • 运行测试: swift test"
