//
//  CXDevice.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(CoreTelephony)
import CoreTelephony
#endif
#if canImport(SystemConfiguration)
import SystemConfiguration.CaptiveNetwork
#endif
#if canImport(DYFSwiftKeychain)
import DYFSwiftKeychain
#endif
/// Needs the advertising SDK to use it.
#if CXAdTracking && !os(watchOS)
import AdSupport
#endif

@objcMembers public class CXDevice: NSObject {
    
    /// The key for storaging the device identifier.
    @nonobjc fileprivate let kDeviceIdentifierStorage = "CXDeviceIdentifierStoragekey"
    
    #if os(iOS) || os(tvOS)
    /// The system version for the OS.
    public var systemVersion: String { UIDevice.current.systemVersion }
    
    /// The system name for the OS.
    public var systemName: String { UIDevice.current.systemName }
    
    /// The name for the device.
    public var deviceName: String { UIDevice.current.name }
    
    /// The model for the device.
    public var model: String { UIDevice.current.model }
    
    /// The localized model for the device，e.g.: "A1533".
    public var localizedModel: String { UIDevice.current.localizedModel }
    
    /// IDFV: Returns a string created from the UUID, such as “E621E1F8-C36C-495A-93FC-0C247A3E6E5F”
    public var idfv: String { UIDevice.current.identifierForVendor?.uuidString ?? uuid() }
    #endif
    
    #if !os(watchOS) && CXAdTracking
    /// IDFA: Returns a string created from the UUID, such as “E621E1F8-C36C-495A-93FC-0C247A3E6E5F”
    @available(iOS 6.0, macOS 10.14, tvOS 6.0, *)
    public var idfa: String { ASIdentifierManager.shared().advertisingIdentifier.uuidString }
    
    /// A Boolean value that indicates whether the user has limited ad tracking enabled.
    @available(iOS 6.0, macOS 10.14, tvOS 6.0, *)
    public var isAdTrackingEnabled: Bool { ASIdentifierManager.shared().isAdvertisingTrackingEnabled }
    #endif
    
    /// Creates a Universally Unique Identifier (UUID) string.
    public func uuid() -> String {
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        /// (strRef! as String).replacingOccurrences(of: "-", with: "")
        let uuidString = strRef! as String
        return uuidString
    }
    
    /// Creates an identifier for the device, if exists, return it.
    public var identifier: String {
        #if canImport(DYFSwiftKeychain)
        let kc = DYFSwiftKeychain()
        guard let deviceId = kc.get(kDeviceIdentifierStorage) else {
            var id = ""
            #if os(iOS) || os(tvOS)
            id = idfv
            #else
            id = uuid()
            #endif
            kc.set(id, forKey: kDeviceIdentifierStorage)
            CXLogger.log(level: .info, message: "deviceId=\(id)")
            return id
        }
        CXLogger.log(level: .info, message: "deviceId=\(deviceId)")
        return deviceId
        #else
        #if os(iOS) || os(tvOS)
            return idfv
        #else
            return uuid()
        #endif
        #endif
    }
    
    #if os(iOS)
    /// The machine for the device, e.g.: "iPhone15,3".
    public func machine() -> String {
        var systemInfo = utsname.init()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    /// The machine model name for the device. View: https://www.theiphonewiki.com/wiki/Models.
    public func modelName() -> String {
        let identifier = machine()
        CXLogger.log(level: .info, message: "machine: \(identifier)")
        switch identifier {
        //------------------------------iPhone--------------------------
        case "iPhone1,1": return "iPhone 2G"
        case "iPhone1,2": return "iPhone 3G"
        case "iPhone2,1": return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4S"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE"
        case "iPhone9,1", "iPhone9,3": return "iPhone 7"
        case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone12,8": return "iPhone SE 2nd Gen"
        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,6": return "iPhone SE 3nd Gen"
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"
            
        //------------------------------iPad--------------------------
        case "iPad1,1": return "iPad"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad6,11", "iPad6,12": return "iPad 5"
        case "iPad7,5", "iPad7,6": return "iPad 6"
        case "iPad7,11", "iPad7,12": return "iPad 7"
        case "iPad11,6", "iPad11,7": return "iPad 8"
            
        //------------------------------iPad Pro-----------------------
        case "iPad6,3", "iPad6,4": return "iPad Pro 9.7-inch"
        case "iPad6,7", "iPad6,8": return "iPad Pro 12.9-inch"
        case "iPad7,1", "iPad7,2": return "iPad Pro 12.9-inch 2"
        case "iPad7,3", "iPad7,4": return "iPad Pro 10.5-inch"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro 11 inch"
        case "iPad8,9", "iPad8,10": return "iPad Pro 11 inch 2"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro 12.9 inch 3"
        case "iPad8,11", "iPad8,12": return "iPad Pro 12.9 inch 4"
            
        //------------------------------iPad Air-----------------------
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad11,3", "iPad11,4": return "iPad Air 3"
        case "iPad13,1", "iPad13,2": return "iPad Air 4"
            
        //------------------------------iPad Mini-----------------------
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad mini"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad mini 3"
        case "iPad5,1", "iPad5,2": return "iPad mini 4"
        case "iPad11,1", "iPad11,2": return "iPad mini 5"
            
        //------------------------------iTouch------------------------
        case "iPod1,1": return "iTouch"
        case "iPod2,1": return "iTouch2"
        case "iPod3,1": return "iTouch3"
        case "iPod4,1": return "iTouch4"
        case "iPod5,1": return "iTouch5"
        case "iPod7,1": return "iTouch6"
        case "iPod9,1": return "iTouch7"
            
        //------------------------------Samulitor-------------------------------------
        case "i386", "x86_64": return "iPhone Simulator"
            
        default: return identifier
        }
    }
    #endif
    
    /// Returns an ip address.
    public func ipAddress() -> String? {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            
            // For each interface ...
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname,
                                        socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8: hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                
                ptr = ptr!.pointee.ifa_next
            }
            
            freeifaddrs(ifaddr)
        }
        
        CXLogger.log(level: .info, message: "Addresses: \(addresses)")
        
        return addresses.first
    }
    
    /// Returns a mac address.
    public func macAddress() -> String {
        let index = Int32(if_nametoindex("en0"))
        let bsdData = "en0".data(using: String.Encoding.utf8)
        var mib: [Int32] = [CTL_NET, AF_ROUTE, 0, AF_LINK, NET_RT_IFLIST, index]
        var len = 0
        
        if mib[5] == 0 {
            CXLogger.log(level: .error, message: "if_nametoindex error.")
            return "00:00:00:00:00:00"
        }
        
        if sysctl(&mib, UInt32(mib.count), nil, &len, nil, 0) < 0 {
            CXLogger.log(level: .info, message: "Could not determine length of info data structure.")
            return "00:00:00:00:00:00"
        }
        
        var buffer = [CChar](repeating: 0, count: len)
        if sysctl(&mib, UInt32(mib.count), &buffer, &len, nil, 0) < 0 {
            CXLogger.log(level: .info, message: "Could not read info data structure.")
            return "00:00:00:00:00:00"
        }
        
        let infoData: NSData = NSData(bytes: buffer, length: len)
        //var interfaceMsgStruct = if_msghdr()
        //infoData.getBytes(&interfaceMsgStruct, length: 1000)
        
        let socketStructStart = 1
        let socketStructData = NSData(data: infoData.subdata(with: NSMakeRange(socketStructStart, len - socketStructStart)))
        let rangeOfToken = socketStructData.range(of: bsdData!, options: NSData.SearchOptions(rawValue: 0), in: NSMakeRange(0, socketStructData.count))
        
        let macAddressData = NSData(data: socketStructData.subdata(with: NSMakeRange(rangeOfToken.location + 3, 6)))
        var macAddressDataBytes = [UInt8](repeating: 0, count: 6)
        macAddressData.getBytes(&macAddressDataBytes, length: 6)
        
        return macAddressDataBytes.map({ String(format:"%02x", $0) }).joined(separator: ":")
    }
    
    #if os(iOS)
    /// Returns the ssid for the current network.
    public func ssid() -> String? {
        let interfaces: NSArray = CNCopySupportedInterfaces() ?? []
        var ssid: String? = nil
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                ssid = dict["SSID"] as? String
            }
        }
        return ssid
    }
    
    /// Returns the WiFi mac for the current network.
    public func wifiMac() -> String? {
        let interfaces: NSArray = CNCopySupportedInterfaces() ?? []
        var mac: String? = nil
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                mac = dict["BSSID"] as? String
            }
        }
        return mac
    }
    
    #if canImport(CoreTelephony)
    /// Returns the subscriber cellular provider.
    public func getCellularProvider() -> CTCarrier? {
        let info = CTTelephonyNetworkInfo.init()
        if #available(iOS 12.0, *) {
            return info.serviceSubscriberCellularProviders?.values.first
        } else {
            return info.subscriberCellularProvider
        }
    }
    
    /// Returns the mobile country code.
    public func mobileCountryCode() -> String? {
        let carrier = getCellularProvider()
        return carrier?.mobileCountryCode
    }
    
    /// Returns the mobile network code.
    public func mobileNetworkCode() -> String? {
        let carrier = getCellularProvider()
        return carrier?.mobileNetworkCode
    }
    
    ///IMSI：International Mobile Subscriber Identification Number.
    ///IMSI：MCC(Mobile Country Code)，MNC(Mobile Network Code)
    public func imsi() -> String {
        if let carrier = getCellularProvider() {
            let countryCode = carrier.mobileCountryCode
            let networkCode = carrier.mobileNetworkCode
            if countryCode != nil && networkCode != nil {
                return "\(countryCode!)\(networkCode!)"
            }
        }
        return "00000"
    }
    
    /// Return the iso country code, e.g.: "cn".
    public func isoCountryCode() -> String? {
        let carrier = getCellularProvider()
        return carrier?.isoCountryCode
    }
    
    /// Returns the carrier name.
    public func carrierName() -> String {
        let carrier = getCellularProvider()
        var carrierName = "No carrier"
        if self.isoCountryCode() != nil {
            carrierName = carrier?.carrierName ?? "No carrier"
        }
        return carrierName
    }
    
    /// Return the carrier net type.
    public func carrierNetType() -> String {
        let info = CTTelephonyNetworkInfo.init()
        let ct: String?
        if #available(iOS 12.0, *) {
            ct = info.serviceCurrentRadioAccessTechnology?.values.first
        } else {
            ct = info.currentRadioAccessTechnology
        }
        guard let tct = ct else { return "Unkown" }
        switch tct {
            //CTRadioAccessTechnologyGPRS: 2G GPRS (Also known as 2.5G)
            //CTRadioAccessTechnologyEdge: 2G EDGE (Also known as 2.5G extension)
        case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge: return "2G"
            //CTRadioAccessTechnologyWCDMA: 3G WCDMA
            //CTRadioAccessTechnologyCDMA1x: 3G CDMA (3G spread spectrum technology)
            //CTRadioAccessTechnologyHSDPA: 3G EDGE (Also known as 3.5G)
            //CTRadioAccessTechnologyHSUPA: 3G HSUPA (Also known as 3.75G)
            //CTRadioAccessTechnologyeHRPD: An upgrade scheme of 3G
            //CTRadioAccessTechnologyCDMAEVDORev0: 3G CDMA (An upgrade scheme of 3G)
            //CTRadioAccessTechnologyCDMAEVDORevA: 3G CDMA (An upgrade scheme of 3G)
            //CTRadioAccessTechnologyCDMAEVDORevB: 3G CDMA (An upgrade scheme of 3G)
        case CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyCDMA1x, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyeHRPD, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB: return "3G"
            //CTRadioAccessTechnologyLTE: 4G LTE
        case CTRadioAccessTechnologyLTE: return "4G"
        default:
            //CTRadioAccessTechnologyNR: 5G NR
            //CTRadioAccessTechnologyNRNSA: 5G NRNSA
            if #available(iOS 14.1, *) {
                if tct == CTRadioAccessTechnologyNR || tct == CTRadioAccessTechnologyNRNSA {
                    return "5G"
                }
            } else {
                return "Unkown"
            }
        }
        return "Unkown"
    }
    #endif
    #endif
    
    public var isSimulator: Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        //#if TARGET_OS_SIMULATOR
        isSim = true
        #endif
        return isSim
    }
    
}
