//
//  CXPermissions.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation

#if os(iOS) || os(tvOS) || os(macOS)

//MARK: - Photo Library

#if canImport(Photos)
import Photos

/// The app's Info.plist must contain the `NSPhotoLibraryAddUsageDescription` and `NSPhotoLibraryUsageDescription` key.
public class CXPhotosPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .photos }
}

extension CXPhotosPermission {
    
    /// Represents the user explicitly granted this app access to the photo library.
    @objc public var authorized: Bool {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus {
        var status: PHAuthorizationStatus
        if #available(iOS 14, tvOS 14, macOS 11.0, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        return transform(for: status)
    }
    
    /// Prompts the user to grant the app permission to access the photo library.
    ///
    /// - Returns: Information about your app’s authorization to access the user’s photo library.
    #if swift(>=5.5)
    @available(iOS 14, tvOS 14, macOS 11.0, *)
    public func requestAccess() async -> CXPermissionResult
    {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        let result = CXPermissionResult(type: type, status: transform(for: status))
        return result
    }
    #endif
    
    /// Prompts the user to grant the app permission to access the photo library.
    ///
    /// - Parameter handler: The callback the app invokes when it’s made a determination of the app’s status.
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        if #available(iOS 14, tvOS 14, macOS 11.0, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                let pStatus = self.transform(for: status)
                let pResult = CXPermissionResult(type: self.type, status: pStatus)
                completion(pResult)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                let pStatus = self.transform(for: status)
                let pResult = CXPermissionResult(type: self.type, status: pStatus)
                completion(pResult)
            }
        }
    }
    
    @objc public func transform(for status: PHAuthorizationStatus) -> CXPermissionStatus
    {
        switch status {
            // .restricted: The app isn’t authorized to access the photo library, and the user can’t grant such permission.
            // .denied: The user explicitly denied this app access to the photo library.
        case .restricted, .denied: return .unauthorized
            // .authorized: The user explicitly granted this app access to the photo library.
            // .limited: The user authorized this app for limited photo library access.
        case .authorized, .limited: return .authorized
            // .notDetermined: The user hasn’t set the app’s authorization status.
        case .notDetermined: return .unknown
        default: return .unauthorized
        }
    }
    
}
#endif

#endif


#if os(iOS) || os(tvOS)

#if os(iOS)

//MARK: - Camera

#if canImport(AVFoundation)
import AVFoundation

/// The app's Info.plist must contain a `NSCameraUsageDescription` key.
public class CXCameraPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .camera }
}

extension CXCameraPermission {
    
    /// Represents the user explicitly granted this app access to the camera.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return transform(for: status)
    }
    
    @objc public func transform(for status: AVAuthorizationStatus) -> CXPermissionStatus
    {
        switch status {
            // .restricted: The app isn’t authorized to access the photo library, and the user can’t grant such permission.
            // .denied: The user explicitly denied this app access to the photo library.
        case .restricted, .denied: return .unauthorized
            // .authorized: The user explicitly granted this app access to the photo library.
            // .limited: The user authorized this app for limited photo library access.
        case .authorized: return .authorized
            // .notDetermined: The user hasn’t set the app’s authorization status.
        case .notDetermined: return .unknown
        default: return .unauthorized
        }
    }
    
    #if swift(>=5.5)
    @available(iOS 13.0, *)
    public func requestAccess() async -> CXPermissionResult
    {
        let granted = await AVCaptureDevice.requestAccess(for: AVMediaType.video)
        return CXPermissionResult(type: type, status: granted ? .authorized : status)
    }
    #endif
    
    /// Prompts the user to grant the app permission to access the camera.
    ///
    /// - Parameter completion: A callback the app invokes with the result that indicates whether the user granted or denied access to your app.
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            let result = CXPermissionResult(type: self.type, status: granted ? .authorized : self.status)
            completion(result)
        }
    }
    
}
#endif


//MARK: - Microphone

#if canImport(AVFoundation)
import AVFoundation

/// The app's Info.plist must contain a `NSMicrophoneUsageDescription` key.
public class CXMicrophonePermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .microphone }
}

extension CXMicrophonePermission {
    
    /// Represents the user explicitly granted this app access to the microphone.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        return transform(for: status)
    }
    
    @objc public func transform(for status: AVAuthorizationStatus) -> CXPermissionStatus
    {
        return CXCameraPermission().transform(for: status)
    }
    
    #if swift(>=5.5)
    @available(iOS 13.0, *)
    public func requestAccess() async -> CXPermissionResult
    {
        let granted = await AVCaptureDevice.requestAccess(for: AVMediaType.audio)
        return CXPermissionResult(type: type, status: granted ? .authorized : status)
    }
    #endif
    
    /// Prompts the user to grant the app permission to access the camera.
    ///
    /// - Parameter completion: A callback the app invokes with the result that indicates whether the user granted or denied access to your app.
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        AVCaptureDevice.requestAccess(for: AVMediaType.audio) { granted in
            let result = CXPermissionResult(type: self.type, status: granted ? .authorized : self.status)
            completion(result)
        }
    }
    
}
#endif


//MARK: - Microphone (Another)

#if canImport(AVFAudio)
import AVFAudio

extension CXMicrophonePermission {
    
    /// Represents the user explicitly granted this app access to the microphone.
    @objc public var recordAuthorized: Bool
    {
        return recordStatus == .authorized
    }
    
    @objc public var recordStatus: CXPermissionStatus
    {
        let permission = AVAudioSession.sharedInstance().recordPermission
        return transform(forRecordPermission: permission)
    }
    
    @objc public func transform(forRecordPermission recordPermission: AVAudioSession.RecordPermission) -> CXPermissionStatus
    {
        switch recordPermission {
        case .undetermined: return .unknown
        case .denied: return .unauthorized
        case .granted: return .authorized
        default: return .unauthorized
        }
    }
    
    /// Requests the user’s permission to record audio.
    /// - Parameter completion: A block contains the result indicating whether the user granted or denied permission to record.
    @objc public func requestRecordPermission(completion: @escaping (CXPermissionResult) -> Void)
    {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            let result = CXPermissionResult(type: self.type, status: granted ? .authorized : self.recordStatus)
            completion(result)
        }
    }
    
}
#endif

#endif


//MARK: - Location

#if canImport(CoreLocation)
import CoreLocation

/// The app's Info.plist must contain the `NSLocationUsageDescription` and `NSLocationWhenInUseUsageDescription` key.
public class CXLocationBasePermission: NSObject, CLLocationManagerDelegate {
    
    /// The block for location fetching.
    fileprivate var fetchingHandler: ((Double, Double, NSError?) -> Void)?
    /// The block for location updating.
    fileprivate var authorizedHandler: ((CXPermissionResult) -> Void)?
    
    private var type_: CXPermissionType!
    
    /// Represents the user explicitly granted this app access to the location.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        #if canImport(CoreLocation)
        var status: CLAuthorizationStatus
        if #available(iOS 14.0, tvOS 14.0, *) {
            status = CLLocationManager().authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        return transform(for: status)
        #else
        return CXPermissionStatus.unknown
        #endif
    }
    
    #if canImport(CoreLocation)
    /// The object that you use to start and stop the delivery of location-related events to your app.
    private var locationManager: CLLocationManager?
    
    @objc public func transform(for status: CLAuthorizationStatus) -> CXPermissionStatus
    {
        guard CLLocationManager.locationServicesEnabled() else {
            return .disabled
        }
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        #if os(iOS)
        case .authorized, .authorizedAlways, .authorizedWhenInUse: return .authorized
        #else
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        #endif
        default: return .unauthorized
        }
    }
    
    @objc public func setupLocationManager() {
        if locationManager != nil { return }
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.distanceFilter = 10
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @objc public func startUpdatingLocation(_ type: CXPermissionType) {
        if locationManager == nil { return }
        #if os(iOS)
        type == .locationAlways
        ? locationManager?.requestAlwaysAuthorization()
        : locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        #else
        type == .locationAlways
        ? locationManager?.requestLocation()
        : locationManager?.requestWhenInUseAuthorization()
        #endif
    }
    
    /// Stops the generation of location updates.
    @objc public func stopUpdatingLocation()
    {
        if locationManager == nil { return }
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        authorizedHandler = nil
        fetchingHandler = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else { return }
        authorizedHandler?(CXPermissionResult(type: type_, status: .authorized))
        let latitude  = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        fetchingHandler?(latitude, longitude, nil)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        let err = error as NSError
        fetchingHandler?(0, 0, err)
        if err.code == CLAuthorizationStatus.notDetermined.rawValue {
            CXLogger.log(level: .error, message: "User has not yet made a choice with regards to this application.")
            authorizedHandler?(CXPermissionResult(type: type_, status: .unknown))
        } else if err.code == CLAuthorizationStatus.restricted.rawValue {
            CXLogger.log(level: .error, message: "This application is not authorized to use location services.")
            authorizedHandler?(CXPermissionResult(type: type_, status: .unauthorized))
        } else if err.code == CLAuthorizationStatus.denied.rawValue {
            CXLogger.log(level: .error, message: "The user denied the use of location services for the app or they are disabled globally in Settings.")
            authorizedHandler?(CXPermissionResult(type: type_, status: .unauthorized))
        } else {
            CXLogger.log(level: .error, message: "error=\(err)")
            authorizedHandler?(CXPermissionResult(type: type_, status: status))
        }
    }
    #endif
    
}

/// The app's Info.plist must contain a `NSLocationAlwaysUsageDescription` key.
public class CXLocationAlwaysPermission: CXLocationBasePermission, CXPermission {
    @objc public var type: CXPermissionType { return .locationAlways }
}

extension CXLocationAlwaysPermission {
    
    /// Prompts the user to grant the app permission to access the location.
    ///
    /// - Parameter completion: A callback the app invokes.
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        authorizedHandler = completion
        #if canImport(CoreLocation)
        setupLocationManager()
        startUpdatingLocation(type)
        #endif
    }
    
    /// Fethces the location always.
    @objc public func fetchLocation(completion: @escaping (_ latitude: Double, _ longtitude: Double, _ error: NSError?) -> Void)
    {
        fetchingHandler = completion
        #if canImport(CoreLocation)
        setupLocationManager()
        startUpdatingLocation(type)
        #endif
    }
    
}

/// The app's Info.plist must contain a `NSLocationWhenInUseUsageDescription` key.
public class CXLocationInUsePermission: CXLocationBasePermission, CXPermission {
    @objc public var type: CXPermissionType { .locationInUse }
}

extension CXLocationInUsePermission {
    
    /// Prompts the user to grant the app permission to access the location.
    ///
    /// - Parameter completion: A callback the app invokes.
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        authorizedHandler = completion
        #if canImport(CoreLocation)
        setupLocationManager()
        startUpdatingLocation(type)
        #endif
    }
    
    /// Fethces the location when in use.
    @objc public func fetchLocation(completion: @escaping (_ latitude: Double, _ longtitude: Double, _ error: NSError?) -> Void)
    {
        fetchingHandler = completion
        #if canImport(CoreLocation)
        setupLocationManager()
        startUpdatingLocation(type)
        #endif
    }
    
}
#endif


//MARK: - Notification

#if canImport(UserNotifications)
import UserNotifications

public class CXNotificationPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { .notification }
}

extension CXNotificationPermission {
    
    /// Represents the user explicitly granted this app access to the notification.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @available(macOS 10.14, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    @objc public var unStatus: UNAuthorizationStatus
    {
        let semaphore = DispatchSemaphore(value: 1)
        let center = UNUserNotificationCenter.current()
        var status: UNAuthorizationStatus = .notDetermined
        center.getNotificationSettings { settings in
            status = settings.authorizationStatus
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return status
    }
    
    @objc public var status: CXPermissionStatus
    {
        if #available(macOS 10.14, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            return transform(for: unStatus)
        } else {
            #if os(iOS)
            let settings = UIApplication.shared.currentUserNotificationSettings
            guard let types = settings?.types else {
                return .unauthorized
            }
            if types.contains(.alert) || types.contains(.badge) || types.contains(.sound) {
                return .authorized
            }
            return .unknown
            #else
            return .unknown
            #endif
        }
    }
    
    @available(macOS 10.14, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    @objc public func transform(for status: UNAuthorizationStatus) -> CXPermissionStatus
    {
        switch status {
        case .notDetermined: return .unknown
        case .denied: return .unauthorized
            //authorized: The application is authorized to post user notifications.
            //provisional: The application is authorized to post non-interruptive user notifications.
            //ephemeral: The application is temporarily authorized to post notifications. Only available to app clips.
        case .authorized, .provisional, .ephemeral: return .authorized
        default: return .unauthorized
        }
    }
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void) {
        if #available(macOS 10.14, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                if error != nil {
                    CXLogger.log(level: .error, message: "error=\(error!)")
                }
                let result = CXPermissionResult(type: self.type, status: granted ? .authorized : self.status)
                completion(result)
            }
        } else {
            // Don't execute this codes, because of needing higher os.
            #if os(iOS)
            if #available(iOS 8.0, *) {
                let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                let result = CXPermissionResult(type: type, status: .authorized)
                completion(result)
            } else {
                UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
                UIApplication.shared.registerForRemoteNotifications()
                let result = CXPermissionResult(type: type, status: .authorized)
                completion(result)
            }
            #else
            completion(CXPermissionResult(type: type, status: .unknown))
            #endif
        }
    }
    
}
#endif


//MARK: - Bluetooth

#if os(iOS) && canImport(CoreBluetooth)
import CoreBluetooth

/// The app's Info.plist must contain the `NSBluetoothAlwaysUsageDescription` and `NSBluetoothPeripheralUsageDescription` key.
public class CXBluetoothPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .bluetooth }
    
    fileprivate var centralManager: CBCentralManager?
    fileprivate var authorizedHandler: ((CXPermissionResult) -> Void)?
}

extension CXBluetoothPermission: CBCentralManagerDelegate {
    
    /// Represents the user explicitly granted this app access to the bluetooth.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        if #available(iOS 13.0, *) {
            var status: CBManagerAuthorization
            if #available(iOS 13.1, *) {
                status = CBCentralManager.authorization
            } else {
                status = CBCentralManager().authorization
            }
            switch status {
            case .notDetermined: return .unknown
            case .restricted, .denied: return .unauthorized
            case .allowedAlways: return .authorized
            default: return .unauthorized
            }
        } else {
            let status = CBPeripheralManager.authorizationStatus()
            switch status {
            case .notDetermined: return .unknown
            case .restricted, .denied: return .unauthorized
            case .authorized: return .authorized
            default: return .unauthorized
            }
        }
    }
    
    /// Asks the central manager to stop scanning for peripherals.
    @objc public func stop()
    {
        centralManager?.stopScan()
        centralManager = nil
        authorizedHandler = nil
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        authorizedHandler?(CXPermissionResult(type: type, status: status))
    }
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        authorizedHandler = completion
        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: nil, options: [:])
        } else {
            authorizedHandler?(CXPermissionResult(type: type, status: status))
        }
    }
    
}
#endif


//MARK: - Device TouchID/FaceID、Passcode

#if os(iOS) && canImport(LocalAuthentication)
import LocalAuthentication

public class CXDeviceSafetyContext: NSObject {
    @objc public private(set) var type: CXPermissionType = .deviceBiometrics
    
    @objc public init(type: CXPermissionType) {
        self.type = type
    }
}

extension CXDeviceSafetyContext {
    
    @available(iOS 11.0, *)
    @objc public var biometryType: LABiometryType
    {
        let context = LAContext()
        return context.biometryType
    }
    
    @available(iOS 11.0, *)
    @objc public var isFaceID: Bool {
        return biometryType == .faceID
    }
    
    @available(iOS 11.0, *)
    @objc public var isTouchID: Bool {
        return biometryType == .touchID
    }
    
    /// Represents the user explicitly granted this app access to the biometrics.
    @objc public var authorized: Bool
    {
        if #available(iOS 11.0, *) {
            return status == .authorized
        } else {
            return false
        }
    }
    
    @objc public var status: CXPermissionStatus {
        if #available(iOS 11.0, *) {
            if type == .deviceBiometrics {
                let context = LAContext()
                guard context.biometryType == .faceID || context.biometryType == .touchID
                else {
                    return .disabled
                }
                var error: NSError?
                let isReady = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
                switch error?.code {
                case nil where isReady:
                    return .unknown
                case LAError.biometryNotAvailable.rawValue:
                    return .unauthorized
                case LAError.biometryNotEnrolled.rawValue:
                    return .unauthorized
                default:
                    return .unauthorized
                }
            } else {
                return .unknown
            }
        } else {
            return .unknown
        }
    }
    
    /// Evaluates the device biometrics.
    @available(iOS 8.0, *)
    @objc public func evaluateDeviceBiometrics(completion: @escaping (CXPermissionResult) -> Void)
    {
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { success, error in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!).")
            }
            let result = CXPermissionResult(type: self.type, status: success ? .authorized : .unauthorized)
            completion(result)
        }
    }
    
    /// Evaluates the device passcode.
    @available(iOS 8.0, *)
    @objc public func evaluateDevicePasscode(completion: @escaping (CXPermissionResult) -> Void)
    {
        LAContext().evaluatePolicy(.deviceOwnerAuthentication, localizedReason: " ") { success, error in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!).")
            }
            let result = CXPermissionResult(type: self.type, status: success ? .authorized : .unauthorized)
            completion(result)
        }
    }
    
}

/// The app's Info.plist must contain a `NSFaceIDUsageDescription` key.
public class CXDeviceBiometricsPermission: CXDeviceSafetyContext, CXPermission {
    @objc public override var type: CXPermissionType { return .deviceBiometrics }
}

extension CXDeviceBiometricsPermission {
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void) {
        evaluateDeviceBiometrics { result in
            completion(result)
        }
    }
    
    #if swift(>=5.5)
    @available(iOS 13.0, *)
    public func evaluateDeviceBiometrics() async -> CXPermissionResult
    {
        var result: CXPermissionResult
        do {
            let success = try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ")
            result = CXPermissionResult(type: type, status: success ? .authorized : .unauthorized)
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error).")
            result = CXPermissionResult(type: type, status: .unauthorized)
        }
        return result
    }
    #endif
    
}

public class CXDevicePasscodePermission: CXDeviceSafetyContext, CXPermission {
    @objc public override var type: CXPermissionType { return .devicePasscode }
}

extension CXDevicePasscodePermission {
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void) {
        evaluateDevicePasscode { result in
            completion(result)
        }
    }
    
    #if swift(>=5.5)
    @available(iOS 13.0, *)
    public func evaluateDevicePasscode() async -> CXPermissionResult
    {
        do {
            let success = try await LAContext().evaluatePolicy(.deviceOwnerAuthentication, localizedReason: " ")
            return CXPermissionResult(type: type, status: success ? .authorized : .unauthorized)
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error).")
        }
        return CXPermissionResult(type: type, status: .unauthorized)
    }
    #endif
    
}
#endif


//MARK: - Contacts

#if canImport(Contacts)
import Contacts

/// The app's Info.plist must contain a `NSContactsUsageDescription` key.
public class CXContactsPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .contacts }
}

extension CXContactsPermission {
    
    /// Represents the user explicitly granted this app access to the contacts.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    /// Returns the current status to access the contact data.
    @objc public var status: CXPermissionStatus
    {
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        return transform(for: status)
    }
    
    @objc public func transform(for status: CNAuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        case .authorized: return .authorized
        default: return .unauthorized
        }
    }
    
    #if swift(>=5.5)
    @available(iOS 13.0, tvOS 13.0, *)
    public func requestAccess() async -> CXPermissionResult
    {
        let contactStore = CNContactStore()
        do {
            let success = try await contactStore.requestAccess(for: CNEntityType.contacts)
            return CXPermissionResult(type: type, status: success ? .authorized : status)
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error).")
        }
        return CXPermissionResult(type: type, status: .unauthorized)
    }
    #endif
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        let contactStore = CNContactStore()
        contactStore.requestAccess(for: CNEntityType.contacts) { granted, error in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!)")
            }
            let result = CXPermissionResult(type: self.type, status: granted ? .authorized : self.status)
            completion(result)
        }
    }
    
    /// Fetches contacts from the contacts store app.
    ///
    /// - Parameter completion: A block called, when enumeration of all contacts matching a contact fetch request.
    @objc public func fetchContacts(completion: @escaping ([CNContact]) -> Void) {
        /// Specified keys.
        let keysToFetch = [CNContactGivenNameKey as NSString,
                           CNContactFamilyNameKey as NSString,
                           CNContactPhoneNumbersKey as NSString,
                           CNContactEmailAddressesKey as NSString,
                           CNContactBirthdayKey as NSString,
                           CNContactNicknameKey as NSString,
                           CNContactNoteKey as NSString]
        fetchContacts(keysToFetch, completion: completion)
    }
    
    /// Fetches contacts from the contacts store app.
    ///
    /// - Parameters:
    ///   - keysToFetch: An array of contact property keys and/or key descriptors from contacts objects to be fetched in the returned contacts. For a list of possible keys, see [Contact Keys](doc://com.apple.documentation/documentation/contacts/contact_keys?language=swift).
    ///   - completion: A block called, when enumeration of all contacts matching a contact fetch request.
    @objc public func fetchContacts(_ keys: [CNKeyDescriptor]?, completion: @escaping ([CNContact]) -> Void) {
        guard let keysToFetch = keys else {
            CXLogger.log(level: .info, message: "The keys is null.")
            completion([])
            return
        }
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        let contactStore = CNContactStore()
        do {
            var tContacts: [CNContact] = []
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { contact, stop in
                //let familyName = contact.familyName
                //let givenName = contact.givenName
                //let name = "\(contact.familyName)\(contact.givenName)"
                
                //let cnphoneNumber = contact.phoneNumbers[0].value
                //let phoneNumber = cnphoneNumber.stringValue
                
                //for labelValue in contact.phoneNumbers {
                //    let label = labelValue.label
                //    let phoneNumber = labelValue.value
                //    var string = phoneNumber.stringValue
                //    string = string.replacingOccurrences(of: "+86", with: "")
                //    string = string.replacingOccurrences(of: "-", with: "")
                //    string = string.replacingOccurrences(of: "(", with: "")
                //    string = string.replacingOccurrences(of: ")", with: "")
                //    string = string.replacingOccurrences(of: " ", with: "")
                //    string = string.replacingOccurrences(of: " ", with: "")
                //}
                tContacts.append(contact)
                if stop.pointee.boolValue {
                    completion(tContacts)
                }
            })
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error)")
            completion([])
        }
    }
    
}
#endif


//MARK: - Reminder

#if canImport(EventKit)
import EventKit

/// The app's Info.plist must contain a `NSRemindersUsageDescription` key.
public class CXReminderPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .reminder }
}

extension CXReminderPermission {
    
    /// Represents the user explicitly granted this app access to the reminder.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        // The current authorization status for a reminder entity type.
        let status = EKEventStore.authorizationStatus(for: EKEntityType.reminder)
        return transform(for: status)
    }
    
    @objc public func transform(for status: EKAuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        case .authorized: return .authorized
        default: return .unauthorized
        }
    }
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.reminder) { (granted, error) in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!)")
            }
            let result = CXPermissionResult(type: self.type, status: granted ? .authorized : self.status)
            completion(result)
        }
    }
    
}
#endif


//MARK: - Calendar

#if canImport(EventKit)

/// The app's Info.plist must contain a `NSCalendarsUsageDescription` key.
public class CXCalendarPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .event }
}

extension CXCalendarPermission {
    
    /// Represents the user explicitly granted this app access to the calendar.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        // The current authorization status for a calendar entity type.
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        return transform(for: status)
    }
    
    @objc public func transform(for status: EKAuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        case .authorized: return .authorized
        default: return .unauthorized
        }
    }
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!)")
            }
            let result = CXPermissionResult(type: self.type, status: granted ? .authorized : self.status)
            completion(result)
        }
    }
    
}
#endif


//MARK: - Motion

#if canImport(CoreMotion)
import CoreMotion

/// The app's Info.plist must contain a `NSMotionUsageDescription` key.
public class CXMotionPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .motion }
}

extension CXMotionPermission {
    
    /// Represents the user explicitly granted this app access to the motion.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        if #available(iOS 11.0, *) {
            let status = CMMotionActivityManager.authorizationStatus()
            return transform(for: status)
        } else {
            return .unknown
        }
    }
    
    @available(iOS 11.0, *)
    @objc public func transform(for status: CMAuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        case .authorized: return .authorized
        default: return .unauthorized
        }
    }
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        let manager = CMMotionActivityManager()
        let today = Date()
        manager.queryActivityStarting(from: today, to: today, to: OperationQueue.main, withHandler: { (activities: [CMMotionActivity]?, error: Error?) -> () in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!).")
            }
            let result = CXPermissionResult(type: self.type, status: error == nil ? .authorized : .unauthorized)
            completion(result)
            manager.stopActivityUpdates()
        })
    }
    
}
#endif


//MARK: - Speech

#if canImport(Speech)
import Speech

/// The app's Info.plist must contain a `NSSpeechRecognitionUsageDescription` key.
public class CXSpeechPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .speech }
}

extension CXSpeechPermission {
    
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        let status = SFSpeechRecognizer.authorizationStatus()
        return transform(for: status)
    }
    
    @objc public func transform(for status: SFSpeechRecognizerAuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        case .authorized: return .authorized
        default: return .unauthorized
        }
    }
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        SFSpeechRecognizer.requestAuthorization { status in
            completion(CXPermissionResult(type: self.type, status: self.transform(for: status)))
        }
    }
    
}
#endif


//MARK: - Siri

#if canImport(Intents)
import Intents

/// The app's Info.plist must contain a `NSSiriUsageDescription` key.
public class CXSiriPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .intents }
}

extension CXSiriPermission {
    
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        if #available(tvOS 14.0, *) {
            let status = INPreferences.siriAuthorizationStatus()
            return transform(for: status)
        } else {
            return .disabled
        }
    }
    
    @available(tvOS 14.0, *)
    @objc public func transform(for status: INSiriAuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        case .authorized: return .authorized
        default: return .unauthorized
        }
    }
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        if #available(tvOS 14.0, *) {
            INPreferences.requestSiriAuthorization { status in
                completion(CXPermissionResult(type: self.type, status: self.transform(for: status)))
            }
        } else {
            completion(CXPermissionResult(type: type, status: .disabled))
        }
    }
    
}
#endif

//MARK: - Apple Music

#if os(iOS) && canImport(MediaPlayer)
import MediaPlayer

/// The app's Info.plist must contain a `NSAppleMusicUsageDescription` key.
public class CXMediaPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .media }
}

extension CXMediaPermission {
    
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        if #available(iOS 9.3, *) {
            let status = MPMediaLibrary.authorizationStatus()
            return transform(for: status)
        } else {
            return .disabled
        }
    }
    
    @available(iOS 9.3, *)
    @objc public func transform(for status: MPMediaLibraryAuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        case .authorized: return .authorized
        default: return .unauthorized
        }
    }
    
    #if swift(>=5.5)
    @available(iOS 13.0, *)
    public func requestAccess() async -> CXPermissionResult
    {
        let status = await MPMediaLibrary.requestAuthorization()
        return CXPermissionResult(type: type, status: transform(for: status))
    }
    #endif
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        if #available(iOS 9.3, *) {
            MPMediaLibrary.requestAuthorization { status in
                completion(CXPermissionResult(type: self.type, status: self.transform(for: status)))
            }
        } else {
            return completion(CXPermissionResult(type: type, status: .disabled))
        }
    }
    
}
#endif


//MARK: - App Tracking

#if os(iOS) && canImport(AppTrackingTransparency)
import AppTrackingTransparency

/// The app's Info.plist must contain a `NSUserTrackingUsageDescription` key.
public class CXAppTrackingPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .appTracking }
}

extension CXAppTrackingPermission {
    
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            return transform(for: status)
        } else {
            return .disabled
        }
    }
    
    @available(iOS 14, *)
    @objc public func transform(for status: ATTrackingManager.AuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        case .authorized: return .authorized
        default: return .unauthorized
        }
    }
    
    @objc public func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
    {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                completion(CXPermissionResult(type: self.type, status: self.transform(for: status)))
            }
        } else {
            completion(CXPermissionResult(type: type, status: .disabled))
        }
    }
    
}
#endif

#endif


//MARK: - Health

#if !os(tvOS) && canImport(HealthKit)
import HealthKit

public class CXHealthPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .health }
}

/// The app's Info.plist must contain the `NSHealthUpdateUsageDescription` and `NSHealthShareUsageDescription` key.
extension CXHealthPermission {
    
    public var authorized: Bool {
        CXLogger.log(level: .warning, message: "Do not support it.")
        return false
    }
    
    public var status: CXPermissionStatus {
        CXLogger.log(level: .warning, message: "Do not support it.")
        return .unknown
    }
    
    public func requestAccess(completion: @escaping (CXPermissionResult) -> Void) {
        CXLogger.log(level: .warning, message: "Do not support it.")
    }
    
    @available(iOS 8.0, watchOS 8.0, macOS 13.0, *)
    @objc public func authorized(forType type: HKObjectType) -> Bool
    {
        return status(forType: type) == .authorized
    }
    
    @available(iOS 8.0, watchOS 8.0, macOS 13.0, *)
    @objc public func status(forType type: HKObjectType) -> CXPermissionStatus
    {
        let status = HKHealthStore().authorizationStatus(for: type)
        return transform(for: status)
    }
    
    @available(iOS 8.0, watchOS 8.0, macOS 13.0, *)
    @objc public func transform(for status: HKAuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .sharingDenied: return .unauthorized
        case .sharingAuthorized: return .authorized
        default: return .unauthorized
        }
    }
    
    #if !os(tvOS)
    @available(iOS 8.0, watchOS 8.0, macOS 13.0, *)
    @objc public func requestAccess(forReading readingTypes: Set<HKObjectType>, writing writingTypes: Set<HKSampleType>, completion: @escaping (CXPermissionResult) -> Void)
    {
        HKHealthStore().requestAuthorization(toShare: writingTypes, read: readingTypes) { success, error in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!).")
            }
            let result = CXPermissionResult(type: self.type, status: success ? .authorized : .unauthorized)
            completion(result)
        }
    }
    #endif
    
    #if swift(>=5.5) && !os(tvOS)
    @available(iOS 15.0, watchOS 8.0, macOS 13.0, *)
    public func requestAccess(forReading readingTypes: Set<HKObjectType>, writing writingTypes: Set<HKSampleType>) async -> CXPermissionResult
    {
        do {
            try await HKHealthStore().requestAuthorization(toShare: writingTypes, read: readingTypes)
            return CXPermissionResult(type: type, status: .authorized)
        } catch {
            CXLogger.log(level: .error, message: "error=\(error).")
        }
        return CXPermissionResult(type: type, status: .unauthorized)
    }
    #endif
    
}
#endif
