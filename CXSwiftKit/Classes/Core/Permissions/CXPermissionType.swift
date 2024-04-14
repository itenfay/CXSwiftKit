//
//  CXPermissionType.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/3/16.
//

/// The type for the permissions.
@objc public enum CXPermissionType: Int8, CustomStringConvertible {
    case none, photos, camera, microphone, locationAlways, locationInUse, notification, bluetooth, deviceBiometrics, devicePasscode, contacts, reminder, event, motion, speech, intents, health, media, appTracking
    
    public var description: String {
        switch self {
        case .none:             return "None"
        case .photos:           return "Photos"
        case .camera:           return "Camera"
        case .microphone:       return "Microphone"
        case .locationAlways:   return "LocationAlways"
        case .locationInUse:    return "LocationInUse"
        case .notification:     return "Notification"
        case .bluetooth:        return "Bluetooth"
        case .deviceBiometrics: return "DeviceBiometrics" // TouchID or FaceID
        case .devicePasscode:   return "DevicePasscode"   // Passcode
        case .contacts:         return "Contacts"
        case .reminder:         return "Reminder"
        case .event:            return "Calendar"
        case .motion:           return "Motion"
        case .speech:           return "Speech"
        case .intents:          return "Siri"        // Siri
        case .health:           return "Health"      // Health
        case .media:            return "AppleMusic"  // Apple Music
        case .appTracking:      return "AppTracking"
        }
    }
}
