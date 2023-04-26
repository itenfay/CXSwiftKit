//
//  CXPermissions.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(Foundation)
import Foundation

//MARK: - Photo Library

/// The app's Info.plist must contain the `NSPhotoLibraryAddUsageDescription` and `NSPhotoLibraryUsageDescription` keys.
public class CXPhotosPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .photos }
}

#if canImport(Photos)
import Photos

extension CXPhotosPermission {
    
    /// Represents the user explicitly granted this app access to the photo library.
    @objc public var authorized: Bool {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus {
        var status: PHAuthorizationStatus
        if #available(iOS 14, *) {
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
    @available(iOS 14, *)
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
        if #available(iOS 14, *) {
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
    
    @objc public func fetchLatestPHAsset() -> PHAsset?
    {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        return fetchResult.firstObject
    }
    
    /// Fetches a latest image from the photo library.
    ///
    /// - Parameter completion: A block called, exactly once, when image loading is complete.
    @objc public func fetchLatestImage(completion: @escaping (_ imageData: Data?) -> Void)
    {
        guard let asset = fetchLatestPHAsset() else {
            return
        }
        let imageManager = PHImageManager.default()
        if #available(iOS 13, *) {
            imageManager.requestImageDataAndOrientation(for: asset, options: nil) { imageData, dataUTI, orientation, info in
                completion(imageData)
            }
        } else {
            imageManager.requestImageData(for: asset, options: nil) { imageData, dataUTI, orientation, info in
                completion(imageData)
            }
        }
    }
    
}

#endif


//MARK: - Camera

/// The app's Info.plist must contain a `NSCameraUsageDescription` key.
public class CXCameraPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .camera }
}

#if canImport(AVFoundation)
import AVFoundation

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

/// The app's Info.plist must contain a `NSMicrophoneUsageDescription` key.
public class CXMicrophonePermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .microphone }
}

#if canImport(AVFoundation)
import AVFoundation

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


//MARK: - Location

#if canImport(CoreLocation)
import CoreLocation
#endif

public class CXLocationPermission: NSObject, CXPermission, CLLocationManagerDelegate {
    
    /// The block for location fetching.
    fileprivate var fetchingHandler: ((Double, Double, NSError?) -> Void)?
    /// The block for location updating.
    fileprivate var authorizedHandler: ((CXPermissionResult) -> Void)?
    
    @objc public var type: CXPermissionType { .locationInUse }
    
    #if canImport(CoreLocation)
    /// The object that you use to start and stop the delivery of location-related events to your app.
    private var locationManager: CLLocationManager?
    
    /// Represents the user explicitly granted this app access to the location.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        var status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = CLLocationManager().authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        return transform(for: status)
    }
    
    @objc public func transform(for status: CLAuthorizationStatus) -> CXPermissionStatus
    {
        guard CLLocationManager.locationServicesEnabled() else {
            return .disabled
        }
        switch status {
        case .notDetermined: return .unknown
        case .restricted, .denied: return .unauthorized
        case .authorized, .authorizedAlways, .authorizedWhenInUse: return .authorized
        default: return .unauthorized
        }
    }
    
    fileprivate func setupLocationManager() {
        if locationManager != nil { return }
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.distanceFilter = 10
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    fileprivate func startUpdatingLocation(always: Bool)
    {
        if locationManager == nil { return }
        always
        ? locationManager?.requestAlwaysAuthorization()
        : locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
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
        authorizedHandler?(CXPermissionResult(type: type, status: .authorized))
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
            authorizedHandler?(CXPermissionResult(type: type, status: .unknown))
        } else if err.code == CLAuthorizationStatus.restricted.rawValue {
            CXLogger.log(level: .error, message: "This application is not authorized to use location services.")
            authorizedHandler?(CXPermissionResult(type: type, status: .unauthorized))
        } else if err.code == CLAuthorizationStatus.denied.rawValue {
            CXLogger.log(level: .error, message: "The user denied the use of location services for the app or they are disabled globally in Settings.")
            authorizedHandler?(CXPermissionResult(type: type, status: .unauthorized))
        } else {
            CXLogger.log(level: .error, message: "error=\(err)")
            authorizedHandler?(CXPermissionResult(type: type, status: status))
        }
    }
    #endif
    
}

/// The app's Info.plist must contain a `NSLocationAlwaysUsageDescription` key.
public class CXLocationAlwaysPermission: CXLocationPermission {
    @objc public override var type: CXPermissionType { return .locationAlways }
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
        startUpdatingLocation(always: true)
        #endif
    }
    
    /// Fethces the location always.
    @objc public func fetchLocation(completion: @escaping (_ latitude: Double, _ longtitude: Double, _ error: NSError?) -> Void)
    {
        fetchingHandler = completion
        #if canImport(CoreLocation)
        setupLocationManager()
        startUpdatingLocation(always: true)
        #endif
    }
    
}

/// The app's Info.plist must contain the `NSLocationUsageDescription` and `NSLocationWhenInUseUsageDescription` key.
public class CXLocationInUsePermission: CXLocationPermission {
    @objc public override var type: CXPermissionType { .locationInUse }
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
        startUpdatingLocation(always: false)
        #endif
    }
    
    /// Fethces the location when in use.
    @objc public func fetchLocation(completion: @escaping (_ latitude: Double, _ longtitude: Double, _ error: NSError?) -> Void)
    {
        fetchingHandler = completion
        #if canImport(CoreLocation)
        setupLocationManager()
        startUpdatingLocation(always: false)
        #endif
    }
    
}


//MARK: - Notification

public class CXNotificationPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { .notification }
}

#if canImport(UserNotifications)
import UserNotifications

extension CXNotificationPermission {
    
    /// Represents the user explicitly granted this app access to the notification.
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @available(macOS 10.14, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    @objc public var unStatus: UNAuthorizationStatus
    {
        let semaphore = DispatchSemaphore(value: 0)
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
            if #available(iOS 8.0, *) {
                let settings = UIApplication.shared.currentUserNotificationSettings
                guard let types = settings?.types else {
                    return .unauthorized
                }
                if types.contains(.alert) ||
                    types.contains(.badge) ||
                    types.contains(.sound) {
                    return .authorized
                }
            }
            return .unknown
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
        } else if #available(iOS 8, *) {
            let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            let result = CXPermissionResult(type: self.type, status: .authorized)
            completion(result)
        } else {
            UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
            UIApplication.shared.registerForRemoteNotifications()
            let result = CXPermissionResult(type: self.type, status: .authorized)
            completion(result)
        }
    }
    
}

#endif


//MARK: - Bluetooth

/// The app's Info.plist must contain a `NSBluetoothPeripheralUsageDescription` key.
public class CXBluetoothPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .bluetooth }
    
    #if canImport(CoreBluetooth)
    fileprivate var centralManager: CBCentralManager?
    fileprivate var authorizedHandler: ((CXPermissionResult) -> Void)?
    #endif
}

#if canImport(CoreBluetooth) && os(iOS)
import CoreBluetooth

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

public class CXDeviceSafetyPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .deviceBiometrics }
}

#if canImport(LocalAuthentication)
import LocalAuthentication

extension CXDeviceSafetyPermission {
    
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
    @available(iOS 11.0, *)
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @available(iOS 11.0, *)
    @objc public var status: CXPermissionStatus {
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
    }
    
}

#endif

public class CXDeviceBiometricsPermission: CXDeviceSafetyPermission {
    @objc public override var type: CXPermissionType { return .deviceBiometrics }
}

#if canImport(LocalAuthentication)

extension CXDeviceBiometricsPermission {
    
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

#endif

public class CXDevicePasscodePermission: CXDeviceSafetyPermission {
    @objc public override var type: CXPermissionType { return .devicePasscode }
}

#if canImport(LocalAuthentication)

extension CXDevicePasscodePermission {
    
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

/// The app's Info.plist must contain a `NSContactsUsageDescription` key.
public class CXContactsPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .contacts }
}

#if canImport(Contacts)
import Contacts

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
    @available(iOS 13.0, *)
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

/// The app's Info.plist must contain a `NSRemindersUsageDescription` key.
public class CXReminderPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .reminder }
}

#if canImport(EventKit)
import EventKit

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

/// The app's Info.plist must contain a `NSCalendarsUsageDescription` key.
public class CXCalendarPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .event }
}

#if canImport(EventKit)
import EventKit

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

/// The app's Info.plist must contain a `NSMotionUsageDescription` key.
public class CXMotionPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .motion }
}

#if canImport(CoreMotion)
import CoreMotion

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

/// The app's Info.plist must contain a `NSSpeechRecognitionUsageDescription` key.
public class CXSpeechPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .speech }
}

#if canImport(Speech)
import Speech

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

public class CXSiriPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .intents }
}

#if canImport(Intents)
import Intents

extension CXSiriPermission {
    
    @objc public var authorized: Bool
    {
        return status == .authorized
    }
    
    @objc public var status: CXPermissionStatus
    {
        let status = INPreferences.siriAuthorizationStatus()
        return transform(for: status)
    }
    
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
        INPreferences.requestSiriAuthorization { status in
            completion(CXPermissionResult(type: self.type, status: self.transform(for: status)))
        }
    }
    
}

#endif


//MARK: - Health

public class CXHealthPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .health }
}

#if canImport(HealthKit)
import HealthKit

extension CXHealthPermission {
    
    @objc public func authorized(forType type: HKObjectType) -> Bool
    {
        return status(forType: type) == .authorized
    }
    
    @objc public func status(forType type: HKObjectType) -> CXPermissionStatus
    {
        let status = HKHealthStore().authorizationStatus(for: type)
        return transform(for: status)
    }
    
    @objc public func transform(for status: HKAuthorizationStatus) -> CXPermissionStatus {
        switch status {
        case .notDetermined: return .unknown
        case .sharingDenied: return .unauthorized
        case .sharingAuthorized: return .authorized
        default: return .unauthorized
        }
    }
    
    #if !os(tvOS)
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


//MARK: - Apple Music

/// The app's Info.plist must contain a `NSAppleMusicUsageDescription` key.
public class CXMediaPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .media }
}

#if canImport(MediaPlayer)
import MediaPlayer

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
        //if #available(iOS 9.3, *) {
            let status = await MPMediaLibrary.requestAuthorization()
            return CXPermissionResult(type: type, status: transform(for: status))
        //} else {
        //    return CXPermissionResult(type: type, status: .disabled)
        //}
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

public class CXAppTrackingPermission: NSObject, CXPermission {
    @objc public var type: CXPermissionType { return .appTracking }
}

#if canImport(AppTrackingTransparency)
import AppTrackingTransparency

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
