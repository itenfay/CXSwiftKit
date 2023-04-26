//
//  CGFloat+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(Foundation)
import Foundation

#if canImport(UIKit)
import UIKit
#endif

extension CGFloat: CXSwiftBaseCompatible {}

extension CXSwiftBase where T == CGFloat {
    
    /// Returns the width of a rectangle of the screen.
    public static var screenWidth: CGFloat {
        return CGFloat.cx_screenWidth
    }
    
    /// Returns the height of a rectangle of the screen.
    public static var screenHeight: CGFloat {
        return CGFloat.cx_screenHeight
    }
    
    #if os(iOS) && canImport(UIKit)
    public static var safeAreaTop: CGFloat { CGFloat.cx_safeAreaTop }
    public static var safeAreaBottom: CGFloat { CGFloat.cx_safeAreaBottom }
    /// The height of the status bar.
    public static var statusBarHeight: CGFloat { CGFloat.cx_statusBarHeight }
    /// The height of the navigation bar.
    public static var navigationBarHeight: CGFloat { CGFloat.cx_navigationBarHeight }
    /// The height of the tab bar.
    public static var tabBarHeight: CGFloat { CGFloat.cx_tabBarHeight }
    #endif
    
}

extension CGFloat {
    
    /// Returns the width of a rectangle of the screen.
    public static var cx_screenWidth: CGFloat {
        #if canImport(UIKit)
        return UIScreen.main.bounds.width
        #else
        return 0
        #endif
    }
    
    /// Returns the height of a rectangle of the screen.
    public static var cx_screenHeight: CGFloat {
        #if canImport(UIKit)
        return UIScreen.main.bounds.height
        #else
        return 0
        #endif
    }
    
    #if os(iOS) && canImport(UIKit)
    public static var cx_safeAreaTop: CGFloat { cxSafeAreaTop }
    public static var cx_safeAreaBottom: CGFloat { cxSafeAreaBottom }
    /// The height of the status bar.
    public static var cx_statusBarHeight: CGFloat { cxStatusBarHeight }
    /// The height of the navigation bar.
    public static var cx_navigationBarHeight: CGFloat { cxNavigationBarHeight }
    /// The height of the tab bar.
    public static var cx_tabBarHeight: CGFloat { cxTabBarHeight }
    #endif
    
}

#endif
