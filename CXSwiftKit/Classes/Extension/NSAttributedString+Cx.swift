//
//  NSAttributedString+Cx.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/11/14.
//

import Foundation
#if !os(watchOS) && canImport(UIKit)
import UIKit

extension CXSwiftBase where T : NSAttributedString {
    
    /// Add the underline with the specified parameters.
    public func addUnderline(with color: CXColor, offset: Float = 0, style: NSUnderlineStyle = [.single]) -> NSAttributedString {
        return base.cx_addUnderline(with: color, offset: offset, style: style)
    }
    
    /// Add the strikethrough with the specified parameters.
    public func addStrikethrough(with color: CXColor, offset: Float = 0, style: NSUnderlineStyle = [.single]) -> NSAttributedString {
        return base.cx_addStrikethrough(with: color, offset: offset, style: style)
    }
    
}

extension NSAttributedString {
    
    /// Add the underline with the specified parameters.
    public func cx_addUnderline(with color: CXColor, offset: Float = 0, style: NSUnderlineStyle = [.single]) -> NSAttributedString {
        let attrs: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.underlineStyle : NSNumber(value: style.rawValue),
            NSAttributedString.Key.underlineColor : color,
            NSAttributedString.Key.baselineOffset : NSNumber(value: offset)
        ]
        let attrString = NSMutableAttributedString(string: self.string)
        attrString.addAttributes(attrs, range: NSRange(location: 0, length: self.string.utf16.count))
        return attrString
    }
    
    /// Add the strikethrough with the specified parameters.
    public func cx_addStrikethrough(with color: CXColor, offset: Float = 0, style: NSUnderlineStyle = [.single]) -> NSAttributedString {
        let attrs: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strikethroughStyle : NSNumber(value: style.rawValue),
            NSAttributedString.Key.strikethroughColor : color,
            NSAttributedString.Key.baselineOffset : NSNumber(value: offset)
        ]
        let attrString = NSMutableAttributedString(string: self.string)
        attrString.addAttributes(attrs, range: NSRange(location: 0, length: self.string.utf16.count))
        return attrString
    }
    
}

extension CXSwiftBase where T : NSMutableAttributedString {
    
    /// Insert the image to the mutable attributed string.
    public func insertTextAttachment(withImage image: CXImage?, rect: CGRect, atIndex index: Int) {
        base.cx_insertTextAttachment(withImage: image, rect: rect, atIndex: index)
    }
    
    /// Add the paragraph style.
    public func addParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle) {
        base.cx_addParagraphStyle(paragraphStyle)
    }
    
}

extension NSMutableAttributedString {
    
    /// Insert the image to the mutable attributed string.
    public func cx_insertTextAttachment(withImage image: CXImage?, rect: CGRect, atIndex index: Int) {
        if index < 0 || index >= self.string.cx.length {
            return
        }
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = rect
        let attrString = NSAttributedString(attachment: attachment)
        self.insert(attrString, at: index)
    }
    
    /// Add the paragraph style.
    public func cx_addParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle) {
        self.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: self.string.cx.length)
        )
    }
    
}

#endif
