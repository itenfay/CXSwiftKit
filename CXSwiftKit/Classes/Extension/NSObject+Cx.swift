//
//  NSObject+Cx.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/11/14.
//

import Foundation

#if os(iOS) || os(tvOS)

extension NSObject: CXSwiftBaseCompatible {}

extension CXSwiftBase where T : NSObject {
    
    /// Adds an entry to the notification center to call the provided selector with the notification.
    public func addObserver(_ observer: Any, selector aSelector: Selector, name aName: Notification.Name?, object anObject: Any? = nil)
    {
        self.base.cx_addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    /// Removes all entries specifying an observer from the notification center's dispatch table.
    public func removeObserver(_ observer: Any)
    {
        self.base.cx_removeObserver(observer)
    }
    
    /// Removes matching entries from the notification center's dispatch table.
    public func removeObserver(_ observer: Any, name aName: Notification.Name?, object anObject: Any? = nil)
    {
        self.base.cx_removeObserver(observer, name: aName, object: anObject)
    }
    
    /// Creates a notification with a given name and sender and posts it to the notification center.
    public func postNotification(withName name: Notification.Name, object anObject: Any? = nil)
    {
        self.base.cx_postNotification(withName: name)
    }
    
    /// Creates a notification with a given name, sender, and information and posts it to the notification center.
    public func postNotification(withName name: Notification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]? = nil)
    {
        self.base.cx_postNotification(withName: name, object: anObject, userInfo: aUserInfo)
    }
    
}

//MARK: - Notification

extension NSObject {
    
    /// Adds an entry to the notification center to call the provided selector with the notification.
    @objc public func cx_addObserver(_ observer: Any, selector aSelector: Selector, name aName: Notification.Name?, object anObject: Any? = nil)
    {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    /// Removes all entries specifying an observer from the notification center's dispatch table.
    @objc public func cx_removeObserver(_ observer: Any)
    {
        NotificationCenter.default.removeObserver(observer)
    }
    
    /// Removes matching entries from the notification center's dispatch table.
    @objc public func cx_removeObserver(_ observer: Any, name aName: Notification.Name?, object anObject: Any? = nil)
    {
        guard let name = aName else {
            return
        }
        NotificationCenter.default.removeObserver(observer, name: name, object: anObject)
    }
    
    /// Creates a notification with a given name and sender and posts it to the notification center.
    @objc public func cx_postNotification(withName name: Notification.Name, object anObject: Any? = nil)
    {
        NotificationCenter.default.post(name: name, object: anObject)
    }
    
    /// Creates a notification with a given name, sender, and information and posts it to the notification center.
    @objc public func cx_postNotification(withName name: Notification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]? = nil)
    {
        NotificationCenter.default.post(name: name, object: anObject, userInfo: aUserInfo)
    }
    
}

#endif
