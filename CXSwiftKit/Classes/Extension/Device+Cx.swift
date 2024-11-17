//
//  Device+Cx.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/11/14.
//

#if os(iOS)
import UIKit

extension CXSwiftBase where T : UIDevice {
    
    /// Triggers the medium impact feedback. If save the instance in the class, you can call `impactOccurred()` where needed.
    @discardableResult
    public func makeImpactFeedback() -> UIImpactFeedbackGenerator
    {
        return base.cx_makeImpactFeedback()
    }
    
    /// Triggers impact feedback with feedback style. If save the instance in the class, you can call `impactOccurred()` where needed.
    @discardableResult
    public func makeImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator
    {
        return base.cx_makeImpactFeedback(style: style)
    }
    
    /// Triggers selection feedback. If save the instance in the class, you can call `selectionChanged()` where needed.
    @discardableResult
    public func makeSelectionFeedback() -> UISelectionFeedbackGenerator
    {
        return base.cx_makeSelectionFeedback()
    }
    
    /// Triggers notification feedback with notification type. If save the instance in the class, you can call `notificationOccurred(type)` where needed.
    @discardableResult
    public func makeNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) -> UINotificationFeedbackGenerator
    {
        return base.cx_makeNotificationFeedback(type: type)
    }
    
}

//MARK: - Feedback

extension UIDevice {
    
    /// Triggers the medium impact feedback. If save the instance in the class, you can call `impactOccurred()` where needed.
    @discardableResult
    @objc public func cx_makeImpactFeedback() -> UIImpactFeedbackGenerator
    {
        return cx_makeImpactFeedback(style: .medium)
    }
    
    /// Triggers impact feedback with feedback style. If save the instance in the class, you can call `impactOccurred()` where needed.
    @discardableResult
    @objc public func cx_makeImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator
    {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
        return impactFeedbackGenerator
    }
    
    /// Triggers selection feedback. If save the instance in the class, you can call `selectionChanged()` where needed.
    @discardableResult
    @objc public func cx_makeSelectionFeedback() -> UISelectionFeedbackGenerator
    {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
        return selectionFeedbackGenerator
    }
    
    /// Triggers notification feedback with notification type. If save the instance in the class, you can call `notificationOccurred(type)` where needed.
    @discardableResult
    @objc public func cx_makeNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) -> UINotificationFeedbackGenerator
    {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(type)
        return notificationFeedbackGenerator
    }
    
}

#endif
