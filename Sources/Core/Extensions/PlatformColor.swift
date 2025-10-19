import SwiftUI

#if os(macOS)
import AppKit
public typealias PlatformColor = NSColor
#else
import UIKit
public typealias PlatformColor = UIColor
#endif

extension Color {
    static var platformBackground: Color {
        #if os(macOS)
        return Color(NSColor.controlBackgroundColor)
        #else
        return Color(UIColor.systemGray6)
        #endif
    }
    
    static var platformSeparator: Color {
        #if os(macOS)
        return Color(NSColor.separatorColor)
        #else
        return Color(UIColor.separator)
        #endif
    }
}
