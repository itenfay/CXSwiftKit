//
//  UIView+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import UIKit

extension CXSwiftBase where T : UIView {
    
    /// The y-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    public var top: CGFloat {
        get {
            return self.base.cx_top
        }
        set {
            self.base.cx_top = newValue
        }
    }
    
    /// The y-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    public var y: CGFloat {
        get {
            return self.base.cx_y
        }
        set (ny) {
            self.base.cx_y = ny
        }
    }
    
    /// The x-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    public var left: CGFloat {
        get {
            return self.base.cx_left
        }
        set {
            self.base.cx_left = newValue
        }
    }
    
    /// The x-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    public var x: CGFloat {
        get {
            return self.base.cx_x
        }
        set {
            self.base.cx_x = newValue
        }
    }
    
    /// The bottom x-coordinate of the coordinates of the rectangle’s origin.
    public var bottom: CGFloat {
        get {
            return self.base.cx_bottom
        }
        set {
            self.base.cx_bottom = newValue
        }
    }
    
    /// The right x-coordinate of the coordinates of the rectangle’s origin.
    public var right: CGFloat {
        get {
            return self.base.cx_right
        }
        set {
            self.base.cx_right = newValue
        }
    }
    
    /// A value that specifies the width of the view's frame rectangle.
    public var width: CGFloat {
        get {
            return self.base.cx_width
        }
        set {
            self.base.cx_width = newValue
        }
    }
    
    /// A value that specifies the height of the view's frame rectangle.
    public var height: CGFloat {
        get {
            return self.base.cx_height
        }
        set {
            self.base.cx_height = newValue
        }
    }
    
    /// The x-coordinate of the center point of the view's frame rectangle.
    public var centerX: CGFloat {
        get {
            return self.base.cx_centerX
        }
        set {
            self.base.cx_centerX = newValue
        }
    }
    
    /// The y-coordinate of the center point of the view's frame rectangle.
    public var centerY: CGFloat {
        get {
            return self.base.cx_centerY
        }
        set {
            self.base.cx_centerY = newValue
        }
    }
    
    /// A point that specifies the coordinates of the rectangle’s origin.
    public var origin: CGPoint {
        get {
            return self.base.cx_origin
        }
        set {
            self.base.cx_origin = newValue
        }
    }
    
    /// A size that specifies the height and width of the rectangle.
    public var size: CGSize {
        get {
            return self.base.cx_size
        }
        set {
            self.base.cx_size = newValue
        }
    }
    
}

//MARK: - Layout

extension UIView {
    
    /// The y-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /// The y-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set (newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
    
    /// The x-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// The x-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// The bottom x-coordinate of the coordinates of the rectangle’s origin.
    @objc public var cx_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
    
    /// The right x-coordinate of the coordinates of the rectangle’s origin.
    @objc public var cx_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }
    
    /// A value that specifies the width of the view's frame rectangle.
    @objc public var cx_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /// A value that specifies the height of the view's frame rectangle.
    @objc public var cx_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /// The x-coordinate of the center point of the view's frame rectangle.
    @objc public var cx_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint.init(x: newValue, y: self.center.y)
        }
    }
    
    /// The y-coordinate of the center point of the view's frame rectangle.
    @objc public var cx_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint.init(x: self.center.x, y: newValue)
        }
    }
    
    /// A point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    /// A size that specifies the height and width of the rectangle.
    @objc public var cx_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
}
