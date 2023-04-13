//
//  UIDevice+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(UIKit)
import UIKit

extension CXSwiftBase where T : UIDevice {
    
    /// Triggers the medium impact feedback.
    @discardableResult
    public func makeImpactFeedback() -> UIImpactFeedbackGenerator
    {
        return base.cx_makeImpactFeedback()
    }
    
    /// Triggers impact feedback with feedback style.
    @discardableResult
    public func makeImpactFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator
    {
        return base.cx_makeImpactFeedback(style)
    }
    
    /// Triggers selection feedback.
    @discardableResult
    public func makeSelectionFeedback() -> UISelectionFeedbackGenerator
    {
        return base.cx_makeSelectionFeedback()
    }
    
    /// Triggers notification feedback with notification type.
    @discardableResult
    public func makeNotificationFeedback(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) -> UINotificationFeedbackGenerator
    {
        return base.cx_makeNotificationFeedback(notificationType)
    }
    
}

//MARK: - Feedback

extension UIDevice {
    
    /// Triggers the medium impact feedback.
    @discardableResult
    @objc public func cx_makeImpactFeedback() -> UIImpactFeedbackGenerator
    {
        return cx_makeImpactFeedback(.medium)
    }
    
    /// Triggers impact feedback with feedback style.
    @discardableResult
    @objc public func cx_makeImpactFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator
    {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
        return impactFeedbackGenerator
    }
    
    /// Triggers selection feedback.
    @discardableResult
    @objc public func cx_makeSelectionFeedback() -> UISelectionFeedbackGenerator
    {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
        return selectionFeedbackGenerator
    }
    
    /// Triggers notification feedback with notification type.
    @discardableResult
    @objc public func cx_makeNotificationFeedback(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) -> UINotificationFeedbackGenerator
    {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(notificationType)
        return notificationFeedbackGenerator
    }
    
}

#endif
