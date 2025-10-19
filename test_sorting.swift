#!/usr/bin/env swift

import Foundation

// 简单的测试脚本来验证排序算法
print("测试排序算法...")

// 测试数组
let testArray = [64, 34, 25, 12, 22, 11, 90]
print("原始数组: \(testArray)")

// 模拟冒泡排序
var array = testArray
let n = array.count

print("开始冒泡排序...")
for i in 0..<n {
    for j in 0..<(n-i-1) {
        if array[j] > array[j+1] {
            let temp = array[j]
            array[j] = array[j+1]
            array[j+1] = temp
            print("交换 \(array[j+1]) 和 \(array[j])")
        }
    }
}

print("排序后数组: \(array)")
print("测试完成！")
