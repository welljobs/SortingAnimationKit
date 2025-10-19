//
//  SortingAnimationDemoApp.swift
//  SortingAnimationDemo
//
//  Created by Jobs Azeroth on 2025/10/20.
//

import SwiftUI
import SortingAnimationKit

@main
struct SortingAnimationDemoApp: App {
    var body: some Scene {
        WindowGroup {
            SortingAppView()
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 800, height: 600)
    }
}
