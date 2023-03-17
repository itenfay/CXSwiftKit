//
//  CGFloat+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation

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
    
}

extension CGFloat {
    
    /// Returns the width of a rectangle of the screen.
    public static var cx_screenWidth: CGFloat { return UIScreen.main.bounds.width }
    
    /// Returns the height of a rectangle of the screen.
    public static var cx_screenHeight: CGFloat { return UIScreen.main.bounds.height }
    
}
