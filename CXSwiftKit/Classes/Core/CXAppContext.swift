//
//  CXAppContext.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/11/14.
//

import Foundation

public class CXAppContext: NSObject {
    
    #if os(iOS)
    /// This is private because the use of 'appConfiguration' is preferred.
    private var isTestFlight: Bool { Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" }
    #endif
    
    @objc public var embeddedProvisionPath: String { Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") ?? "" }
    
    /// This can be used to add debug statements.
    @objc public var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    #if os(iOS)
    @objc public var configuration: AppConfiguration {
        if isDebug {
            return .debug
        } else if isTestFlight {
            return .testFlight
        } else if !embeddedProvisionPath.isEmpty {
            if let reader = CXLineReader(path: embeddedProvisionPath) {
                while let line = reader.nextLine {
                    if line.contains("<key>Name</key>") {
                        // <string>xxx Ad Hoc Provisioning Profile: com.xxx.xxx</string>
                        // <string>com.xxx.xxx InHouse</string>
                        let nextLine = reader.nextLine?.lowercased() ?? ""
                        if nextLine.contains("ad hoc") ||
                            nextLine.contains("adhoc") {
                            return .adHoc
                        } else if nextLine.contains("inhouse") {
                            return .inHouse
                        }
                    }
                    if line.contains("<key>ProvisionsAllDevices</key>") {
                        return .inHouse
                    } else if line.contains("<key>ProvisionedDevices</key>") {
                        return .adHoc
                    }
                }
            }
            return .adHoc
        } else {
            return .appStore
        }
    }
    
    /// Check resign of the app by the team identifier. false indicates that nobody re-signs this app, otherwise true.
    @objc public func checkResign(_ teamIdentifier: String) -> Bool {
        let path = embeddedProvisionPath
        guard !path.isEmpty else {
            return false
        }
        if let reader = CXLineReader(path: path) {
            while let line = reader.nextLine {
                if line.contains("<key>com.apple.developer.team-identifier</key>") {
                    let nextLine = reader.nextLine ?? ""
                    if nextLine.contains("<string>\(teamIdentifier)</string>") {
                        return false
                    }
                    break
                }
            }
        }
        return true
    }
    
    /// Go to AppStore by the open url.
    ///
    /// - Parameter id: The app's identifier.
    @objc public func toAppStore(withAppId appId: String) {
        //"itms-apps://itunes.apple.com/app/id\(appId)?mt=8"
        guard let url = URL(string: "https://itunes.apple.com/app/id\(appId)?mt=8")
        else {
            CXLogger.log(level: .info, message: "The url is null.")
            return
        }
        self.openURL(url)
    }
    
    /// Go AppStore to write the review.
    ///
    /// - Parameter appId: The app's identifier.
    @objc public func toWriteReview(withAppId appId: String) {
        guard let url = URL(string: "https://itunes.apple.com/app/id\(appId)?action=write-review")
        else {
            CXLogger.log(level: .info, message: "The url is null.")
            return
        }
        self.openURL(url)
    }
    
    /// Install app with the url string.
    ///
    /// - Parameter url: The url represents the location of the app.
    @objc public func installApp(_ url: String?) {
        installApp(url, action: "download-manifest")
    }
    
    /// Install app with the url string and the specified action.
    ///
    /// - Parameters:
    ///   - url: The url represents the location of the app.
    ///   - action: e.g.: "download-manifest"
    @objc public func installApp(_ url: String?, action: String) {
        guard let urlStr = url, urlStr.cx.isNotEmpty() else {
            CXLogger.log(level: .warning, message: "The url is null or empty.")
            return
        }
        // It was used to install ipa(Development, AdHoc or InHouse).
        self.openURL(URL(string: "itms-services://?action=\(action)&url=\(urlStr)"))
    }
    
    /// Attempts to asynchronously open the resource at the specified URL.
    ///
    /// - Parameters:
    ///   - url: A URL (Universal Resource Locator).
    ///   - completion: The block to execute with the results. Provide a value for this parameter if you want to be informed of the success or failure of opening the URL.
    @objc public func openURL(_ url: URL?, completionHandler completion: ((Bool) -> Void)? = nil) {
        #if canImport(UIKit)
        guard let aURL = url else {
            CXLogger.log(level: .info, message: "The url is null.")
            completion?(false)
            return
        }
        UIApplication.shared.open(aURL, options: [:], completionHandler: completion)
        #else
        CXLogger.log(level: .info, message: "UIKit can not be imported.")
        completion?(false)
        #endif
    }
    
    #if canImport(UIKit)
    /// Returns a Boolean value that indicates whether an app is available to handle a URL scheme.
    ///
    /// - Parameter url: A URL (Universal Resource Locator).
    /// - Returns: false if the device doesn’t have an installed app registered to handle the URL’s scheme, or if you haven’t declared the URL’s scheme in your Info.plist file; otherwise, true.
    @objc public func canOpenURL(_ url: URL?) -> Bool {
        guard let aURL = url else {
            CXLogger.log(level: .info, message: "The url is null.")
            return false
        }
        let ret = UIApplication.shared.canOpenURL(aURL)
        if !ret {
            CXLogger.log(level: .error, message: "The url(\(aURL)) can not be opened.")
        }
        return ret
    }
    
    /// Attempts to asynchronously open the resource at the specified URL.
    ///
    /// - Parameters:
    ///   - url: A URL (Universal Resource Locator).
    ///   - options: A dictionary of options to use when opening the URL.
    ///   - completion: The block to execute with the results. Provide a value for this parameter if you want to be informed of the success or failure of opening the URL.
    @objc public func openURL(_ url: URL?, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)? = nil) {
        guard let aURL = url else {
            CXLogger.log(level: .info, message: "The url is null.")
            completion?(false)
            return
        }
        UIApplication.shared.open(aURL, options: options, completionHandler: completion)
    }
    #endif
    #endif
    
    /// Constructed from the bundle’s Info.plist file, that contains information about the receiver.
    @objc public var infoDictionary: [String : Any] { Bundle.main.infoDictionary ?? [:] }
    
    /// The bundle identifier for the app.
    @objc public var bundleIdentifier: String { Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String ?? "" }
    
    /// The display name for the app.
    @objc public var displayName: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "" }
    
    /// The short version for the app.
    @objc public var version: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "" }
    
    /// The build version for the app.
    @objc public var buildVersion: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "" }
    
    /// The executable file name for the app.
    @objc public var executableName: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String ?? "" }
    
}
