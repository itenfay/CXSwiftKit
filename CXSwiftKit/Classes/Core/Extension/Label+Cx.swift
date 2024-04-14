//
//  Label+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit
#if canImport(CoreText)
import CoreText
#endif

extension CXSwiftBase where T : UILabel {
    
    /// The required height for a label.
    public var requiredHeight: CGFloat {
        return base.cx_requiredHeight
    }
    
    /// Returns the height that best fits the specified size.
    public var fittingHeight: CGFloat {
        return base.cx_fittingHeight
    }
    
    /// Returns the width that best fits the specified size.
    public var fittingWidth: CGFloat {
        return base.cx_fittingWidth
    }
    
    /// Appends a string to display with a given font and foreground color for the label.
    ///
    /// - Parameters:
    ///   - string: A string to display.
    ///   - font: A font to display(Optional).
    ///   - foregroundColor: A foreground Color to display.
    public func appendString(
        string: String,
        font: UIFont? = nil,
        foregroundColor: UIColor)
    {
        base.cx_appendString(string: string, font: font, foregroundColor: foregroundColor)
    }
    
    //MARK: - Rich Text
    
    #if canImport(CoreText)
    public var clickEffectEnabled: Bool
    {
        get { base.cx_clickEffectEnabled }
        set (enabled) {
            base.cx_clickEffectEnabled = enabled
        }
    }
    
    public var clickEffectColor: UIColor
    {
        get { base.cx_clickEffectColor }
        set (color) {
            base.cx_clickEffectColor = color
        }
    }
    
    public func getRectForLine(_ line: CTLine, atPoint point: CGPoint) -> CGRect {
        return base.cx_getRectForLine(line, atPoint: point)
    }
    
    public func clickRichTextWithStrings(_ strings: [String], completion: ((_ string: String, _ range: NSRange, _ index: Int) -> Void)?)
    {
        base.cx_clickRichTextWithStrings(strings, completion: completion)
    }
    #endif
    
}

//MARK: -  UILabel

extension UILabel {
    
    /// The required height for a label.
    @objc public var cx_requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
    /// Returns the height that best fits the specified size.
    @objc public var cx_fittingHeight: CGFloat {
        let specifiedSize = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        let size = sizeThatFits(specifiedSize)
        return size.height
    }
    
    /// Returns the width that best fits the specified size.
    @objc public var cx_fittingWidth: CGFloat {
        let specifiedSize = CGSize(width: .greatestFiniteMagnitude, height: frame.height)
        let size = sizeThatFits(specifiedSize)
        return size.width
    }
    
    /// Appends a string to display with a given font and foreground color for the label.
    ///
    /// - Parameters:
    ///   - string: A string to display.
    ///   - font: A font to display(Optional).
    ///   - foregroundColor: A foreground Color to display.
    @objc public func cx_appendString(
        string: String,
        font: UIFont? = nil,
        foregroundColor: UIColor)
    {
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(attributedText ?? NSAttributedString(string: ""))
        
        let attributes = [NSAttributedString.Key.font: font ?? self.font]
        let appendString = NSMutableAttributedString(string: string, attributes: attributes as [NSAttributedString.Key : Any])
        let range: NSRange = NSMakeRange(0, appendString.length)
        appendString.addAttribute(NSAttributedString.Key.foregroundColor, value: foregroundColor, range: range)
        attrString.append(appendString)
        attributedText = attrString
    }
    
}

//MARK: - Rich text

#if canImport(CoreText)
import ObjectiveC

struct CXRichTextModel: CXBaseModel {
    var string: String = ""
    var range: NSRange = NSRange(location: 0, length: 0)
}

extension UILabel {
    
    @objc public var cx_clickEffectEnabled: Bool {
        get {
            guard let enabled = objc_getAssociatedObject(self, &CXAssociatedKey.labelRichTextClickEffectEnabled) as? Bool
            else { return false }
            return enabled
        }
        set (enabled) {
            objc_setAssociatedObject(self, &CXAssociatedKey.labelRichTextClickEffectEnabled, enabled, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    @objc public var cx_clickEffectColor: UIColor {
        get {
            guard let color = objc_getAssociatedObject(self, &CXAssociatedKey.labelRichTextClickColor) as? UIColor
            else { return .lightGray }
            return color
        }
        set (color) {
            objc_setAssociatedObject(self, &CXAssociatedKey.labelRichTextClickColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var cx_attributeStrings: [CXRichTextModel] {
        get {
            guard let array = objc_getAssociatedObject(self, &CXAssociatedKey.labelRichTextAttributeStrings) as? [CXRichTextModel]
            else { return [] }
            return array
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.labelRichTextAttributeStrings, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var cx_effectDict: [AnyHashable : Any] {
        get {
            guard let dict = objc_getAssociatedObject(self, &CXAssociatedKey.labelRichTextEffectDict) as? [AnyHashable : Any]
            else { return [:] }
            return dict
        }
        set (dict) {
            objc_setAssociatedObject(self, &CXAssociatedKey.labelRichTextEffectDict, dict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var cx_hasClickAction: Bool {
        get {
            let value = objc_getAssociatedObject(self, &CXAssociatedKey.labelRichTextHasClickAction) as? Bool
            return value ?? false
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.labelRichTextHasClickAction, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public typealias CXRichTextClickAction = (String, NSRange, Int) -> Void
    
    fileprivate var cx_clickAction: CXRichTextClickAction? {
        get {
            return objc_getAssociatedObject(self, &CXAssociatedKey.labelRichTextClickAction) as? CXRichTextClickAction
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.labelRichTextClickAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @objc public func cx_getRectForLine(_ line: CTLine, atPoint point: CGPoint) -> CGRect {
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        let width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, &leading))
        let height: CGFloat = ascent + abs(descent) + leading
        return CGRect(x: point.x, y: point.y, width: width, height: height)
    }
    
    @objc public func cx_clickRichTextWithStrings(_ strings: [String], completion: ((_ string: String, _ range: NSRange, _ index: Int) -> Void)?) {
        cx_setupRichTextModelsWithStrings(strings)
        cx_clickAction = completion
    }
    
    private func cx_setupRichTextModelsWithStrings(_ strings: [String]) {
        guard let attributedText = attributedText, !strings.isEmpty else {
            cx_hasClickAction = false
            return
        }
        cx_hasClickAction = true
        var attr = NSString(string: attributedText.string)
        cx_attributeStrings = []
        for (_, s) in strings.enumerated() {
            let range = attr.range(of: s)
            if range.length != 0 {
                let rAttr = attr.replacingCharacters(in: range, with: cx_stringWithNSRange(range))
                attr = NSString(string: rAttr)
                var model = CXRichTextModel()
                model.string = s
                model.range = range
                cx_attributeStrings.append(model)
            }
        }
    }
    
    private func cx_stringWithNSRange(_ range: NSRange) -> String {
        var string: String = ""
        for _ in 0..<range.length {
            string.append(" ")
        }
        return string
    }
    
    fileprivate var cx_transformForCoreText: CGAffineTransform {
        return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, bounds.height), 1.0, -1.0)
    }
    
    fileprivate func cx_findRichTextFrameByTouchPoint(_ point: CGPoint, result: ((String, NSRange, Int) -> Void)?) -> Bool {
        guard let attributedText = attributedText else {
            return false
        }
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        var path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        var frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
        let range = CTFrameGetVisibleStringRange(frame)
        
        if attributedText.length > range.length {
            var font: UIFont!
            if let aFont = attributedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
                font = aFont
            } else if let sFont = self.font {
                font = sFont
            } else {
                font = UIFont.systemFont(ofSize: 16)
            }
            var lineSpace: CGFloat = 0
            if let paragraphStyle = attributedText.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
                lineSpace = paragraphStyle.lineSpacing
            }
            path = CGMutablePath()
            path.addRect(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + font.lineHeight - lineSpace))
            frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
        }
        
        let lines = CTFrameGetLines(frame)
        let count = CFArrayGetCount(lines)
        var origins = Array<CGPoint>(repeating: .zero, count: count)
        CTFrameGetLineOrigins(frame, CFRange(location: 0, length: 0), &origins)
        let transform = cx_transformForCoreText
        let verticalOffset: CGFloat = 0
        
        for i in 0..<origins.count {
            let linePoint = origins[i]
            guard let linePointer = CFArrayGetValueAtIndex(lines, i) else {
                continue
            }
            let line = linePointer as! CTLine
            let flippedRect = cx_getRectForLine(line, atPoint: linePoint)
            var rect = CGRectApplyAffineTransform(flippedRect, transform)
            rect = CGRectInset(rect, 0, 0)
            rect = CGRectOffset(rect, 0, verticalOffset)
            var lineSpace: CGFloat = 0
            if let style = attributedText.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
                lineSpace = style.lineSpacing
            }
            let lineOutSpace: CGFloat = (bounds.height - lineSpace * CGFloat(count - 1) - rect.height * CGFloat(count)) / 2
            rect.origin.y = lineOutSpace + rect.height * CGFloat(i) + lineSpace * CGFloat(i)
            if CGRectContainsPoint(rect, point) {
                let relativePoint = CGPoint(x: point.x - rect.minX, y: point.y - rect.minY)
                var index = CTLineGetStringIndexForPosition(line, relativePoint)
                var offset: CGFloat = 0
                CTLineGetOffsetForStringIndex(line, index, &offset)
                if offset > relativePoint.x {
                    index--
                }
                let linkCount = cx_attributeStrings.count
                for i in 0..<linkCount {
                    let model = cx_attributeStrings[i]
                    if NSLocationInRange(index, model.range) {
                        result?(model.string, model.range, i)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func cx_setupEffectDictWithNSRange(_ range: NSRange) {
        cx_effectDict = [:]
        if let attributedSubstring = attributedText?.attributedSubstring(from: range) {
            cx_effectDict[NSStringFromRange(range)] = attributedSubstring
        }
    }
    
    @objc private func cx_clickEffectWithStatus(_ status: Bool) {
        if cx_clickEffectEnabled, let attributedText = attributedText {
            guard let value = cx_effectDict.values.first as? NSAttributedString,
                  let key = cx_effectDict.keys.first as? String
            else {
                return
            }
            let range = NSRangeFromString(key)
            let attrStr = NSMutableAttributedString(attributedString: attributedText)
            let subAttr = NSMutableAttributedString(attributedString: value)
            if status {
                subAttr.addAttribute(.backgroundColor, value: cx_clickEffectColor, range: range)
            }
            attrStr.replaceCharacters(in: range, with: subAttr)
            self.attributedText = attrStr
        }
    }
    
    //MARK: - Touch Event
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !cx_hasClickAction { return }
        let touch = (touches as NSSet).anyObject() as! UITouch
        let point = touch.location(in: self)
        _ = cx_findRichTextFrameByTouchPoint(point) { [weak self] (string, range, index) in
            guard let `self` = self else { return }
            self.cx_clickAction?(string, range, index)
            if self.cx_clickEffectEnabled {
                self.cx_setupEffectDictWithNSRange(range)
                self.cx_clickEffectWithStatus(true)
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if cx_hasClickAction && cx_clickEffectEnabled {
            performSelector(onMainThread: #selector(cx_clickEffectWithStatus(_:)), with: false, waitUntilDone: false)
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if cx_hasClickAction && cx_clickEffectEnabled {
            performSelector(onMainThread: #selector(cx_clickEffectWithStatus(_:)), with: false, waitUntilDone: false)
        }
    }
    
    //MARK: - hitTest
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if cx_hasClickAction && cx_findRichTextFrameByTouchPoint(point, result: nil) {
            return self
        }
        return super.hitTest(point, with: event)
    }
    
}

#endif

#endif
