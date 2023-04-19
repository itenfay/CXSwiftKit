//
//  CXPermissionManager.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(UIKit)
import UIKit
#if canImport(CoreLocation)
import CoreLocation
#endif
#if canImport(CoreBluetooth)
import CoreBluetooth
#endif

public class CXPermissionManager: NSObject {
    
    /// Declares a `CXPermissionManager` singleton.
    @objc public static let shared = CXPermissionManager()
    
    /// Private init().
    private override init() {
        super.init()
    }
    
    #if canImport(CoreLocation)
    
    /// The object that you use to start and stop the delivery of location-related events to your app.
    private var locationManager: CLLocationManager?
    
    /// The block for location updating.
    private var locationUpdatedHandler: ((_ granted: Bool, _ lat: Double, _ lng: Double, _ error: NSError?) -> Void)?
    
    private func setupLocationManager() {
        if locationManager != nil { return }
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.distanceFilter = 10
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    #endif
    
    #if canImport(CoreBluetooth)
    
    private var centralManager: CBCentralManager?
    private var centralManagerUpdatedHandler: ((_ granted: Bool) -> Void)?
    
    #endif
    
    /// Deeps link to your app’s custom settings in the Settings app.
    @objc public func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

//MARK: - Photo Library

#if canImport(Photos)
import Photos

extension CXPermissionManager {
    
    /// Represents the user explicitly granted this app access to the photo library.
    @objc public var photoLibraryAuthorized: Bool {
        var status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        return status == .authorized
    }
    
    /// Prompts the user to grant the app permission to access the photo library.
    ///
    /// - Returns: Information about your app’s authorization to access the user’s photo library.
    #if swift(>=5.5)
    @available(iOS 14, *)
    public func requestPhotoLibraryAccess() async -> PHAuthorizationStatus
    {
        return await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
    #endif
    
    /// Prompts the user to grant the app permission to access the photo library.
    ///
    /// - Parameter handler: The callback the app invokes when it’s made a determination of the app’s status.
    @objc public func requestPhotoLibraryAccessStatus(handler: @escaping (PHAuthorizationStatus) -> Void)
    {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: handler)
        } else {
            PHPhotoLibrary.requestAuthorization(handler)
        }
    }
    
    /// Prompts the user to grant the app permission to access the photo library.
    ///
    /// - Parameter handler: The callback the app invokes when it’s made a determination of the app’s status.
    @objc public func requestPhotoLibraryAccess(handler: @escaping (_ granted: Bool) -> Void)
    {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                handler(self.photoLibraryGranted(status))
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                handler(self.photoLibraryGranted(status))
            }
        }
    }
    
    @objc public func photoLibraryGranted(_ status: PHAuthorizationStatus) -> Bool
    {
        var granted = false
        switch status {
            // .notDetermined: The user hasn’t set the app’s authorization status.
            // .restricted: The app isn’t authorized to access the photo library, and the user can’t grant such permission.
            // .denied: The user explicitly denied this app access to the photo library.
        case .notDetermined, .restricted, .denied:
            granted = false
            // .authorized: The user explicitly granted this app access to the photo library.
            // .limited: The user authorized this app for limited photo library access.
        case .authorized, .limited:
            granted = true
        @unknown default: break
        }
        return granted
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

//MARK: - Camera & Microphone

#if canImport(AVFoundation)
import AVFoundation

extension CXPermissionManager {
    
    /// Represents the user explicitly granted this app access to the camera.
    @objc public var cameraAuthorized: Bool
    {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return status == .authorized
    }
    
    #if swift(>=5.5)
    public func requestCameraAccess() async -> Bool
    {
        return await AVCaptureDevice.requestAccess(for: AVMediaType.video)
    }
    #endif
    
    /// Prompts the user to grant the app permission to access the camera.
    ///
    /// - Parameter completion: A callback the app invokes with a Boolean value that indicates whether the user granted or denied access to your app.
    @objc public func requestCameraAccess(completion: @escaping (Bool) -> Void)
    {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: completion)
    }
    
    /// Represents the user explicitly granted this app access to the microphone.
    @objc public var microphoneAuthorized: Bool
    {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        return status == .authorized
    }
    
    #if swift(>=5.5)
    public func requestMicrophoneAccess() async -> Bool
    {
        return await AVCaptureDevice.requestAccess(for: AVMediaType.audio)
    }
    #endif
    
    /// Prompts the user to grant the app permission to access the microphone.
    ///
    /// - Parameter completion: A callback the app invokes with a Boolean value that indicates whether the user granted or denied access to your app.
    @objc public func requestMicrophoneAccess(completion: @escaping (Bool) -> Void)
    {
        AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: completion)
    }
    
}

//MARK: - Microphone (Another)

extension CXPermissionManager {
    
    /// Returns an enum indicating whether the user has granted or denied permission to record, or has
    /// not been asked
    @objc public var recordPermission: AVAudioSession.RecordPermission
    {
        return AVAudioSession.sharedInstance().recordPermission
    }
    
    /// Requests the user’s permission to record audio.
    /// - Parameter completion: A block contains a Boolean value indicating whether the user granted or denied permission to record.
    @objc public func requestRecordPermission(completion: @escaping (Bool) -> Void)
    {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            completion(granted)
        }
    }
    
}

#endif

//MARK: - Location

#if canImport(CoreLocation)

extension CXPermissionManager: CLLocationManagerDelegate {
    
    /// The current authorization status for the app.
    @objc public var locationAuthorizedStatus: CLAuthorizationStatus
    {
        if #available(iOS 14.0, *) {
            let mgr = CLLocationManager()
            return mgr.authorizationStatus
        }
        return CLLocationManager.authorizationStatus()
    }
    
    /// Represents the user explicitly granted this app access to the location.
    @objc public var locationAuthorized: Bool
    {
        let enabled = CLLocationManager.locationServicesEnabled()
        if enabled {
            let status = self.locationAuthorizedStatus
            return status == .authorizedWhenInUse || status == .authorizedAlways
        }
        return false
    }
    
    /// Prompts the user to grant the app permission to access the location.
    ///
    /// - Parameter completion: A callback the app invokes.
    @objc public func requestLocationAccess(withAlways always: Bool = false, completion: @escaping (_ granted: Bool, _ latitude: Double, _ longtitude: Double, _ error: NSError?) -> Void)
    {
        locationUpdatedHandler = completion
        setupLocationManager()
        startUpdatingLocation(always)
    }
    
    private func startUpdatingLocation(_ always: Bool)
    {
        if locationManager == nil { return }
        always
        ? locationManager?.requestAlwaysAuthorization()
        : locationManager?.requestWhenInUseAuthorization()
        //locationManager?.startUpdatingHeading()
        locationManager?.startUpdatingLocation()
    }
    
    /// Stops the generation of location updates.
    @objc public func stopUpdatingLocation()
    {
        if locationManager == nil { return }
        //locationManager?.stopUpdatingHeading()
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        locationUpdatedHandler = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let currLocation = locations.last!
        let latitude  = currLocation.coordinate.latitude
        let longitude = currLocation.coordinate.longitude
        locationUpdatedHandler?(true, latitude, longitude, nil)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        CXLogger.log(level: .info, message: "error=\(error).")
        let _error = error as NSError
        if _error.code == CLAuthorizationStatus.notDetermined.rawValue {
            CXLogger.log(level: .info, message: "User has not yet made a choice with regards to this application.")
        } else if _error.code == CLAuthorizationStatus.restricted.rawValue {
            CXLogger.log(level: .info, message: "This application is not authorized to use location services.")
            locationUpdatedHandler?(false, 0, 0, _error)
        } else if _error.code == CLAuthorizationStatus.denied.rawValue {
            locationUpdatedHandler?(false, 0, 0, _error)
        }
    }
    
}

#endif

//MARK: - Contacts

#if canImport(Contacts)
import Contacts

extension CXPermissionManager {
    
    /// Returns the current authorization status to access the contact data.
    @objc public var contactsAuthorizedStatus: CNAuthorizationStatus
    {
        return CNContactStore.authorizationStatus(for: CNEntityType.contacts)
    }
    
    /// Represents the user explicitly granted this app access to the contacts.
    @objc public var contactsAuthorized: Bool
    {
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        return status == .authorized
    }
    
    #if swift(>=5.5)
    public func requestContactsAccess() async -> Bool
    {
        let contactStore = CNContactStore()
        do {
            return try await contactStore.requestAccess(for: CNEntityType.contacts)
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error).")
            return false
        }
    }
    #endif
    
    public func requestContactsAccess(completion: @escaping (Bool) -> Void)
    {
        let contactStore = CNContactStore()
        contactStore.requestAccess(for: CNEntityType.contacts) { granted, error in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!)")
            }
            completion(granted)
        }
    }
    
    /// Fetches contacts from the contacts store app.
    ///
    /// - Parameter completion: A block called, when enumeration of all contacts matching a contact fetch request.
    public func fetchContacts(completion: @escaping (CNContact?) -> Void) {
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
                completion(contact)
            })
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error)")
            completion(nil)
        }
    }
    
}

#endif

//MARK: - Notification

#if canImport(UNNotification)
import UNNotification

extension CXPermissionManager {
    
    @available(iOS 10, *)
    @objc public var notificationAuthorizedStatus: UNAuthorizationStatus
    {
        let semaphore = DispatchSemaphore(value: 0)
        let center = UNUserNotificationCenter.current()
        var status = .notDetermined
        center.getNotificationSettings { settings in
            status == settings.authorizationStatus
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return status
    }
    
    /// Represents the user explicitly granted this app access to the notification.
    @objc public var notificationAuthorized: Bool
    {
        if #available(iOS 10, *) {
            return notificationAuthorizedStatus == .authorized
        } else {
            let settings = UIApplication.shared.currentUserNotificationSettings
            guard let types = settings?.types else {
                return false
            }
            return types.contains(.alert) || types.contains(.badge) || types.contains(.sound)
        }
    }
    
    @objc public func requestNotificationAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                if error != nil {
                    CXLogger.log(level: .error, message: "error=\(error!)")
                }
                completion(granted)
            }
        } else if #available(iOS 8, *) {
            let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            completion(true)
        } else {
            UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
            UIApplication.shared.registerForRemoteNotifications()
            completion(true)
        }
    }
    
}

#endif

//MARK: - Reminder & Calendar

#if canImport(EventKit)
import EventKit

extension CXPermissionManager {
    
    /// The current authorization status for a reminder entity type.
    @objc public var reminderAuthorizedStatus: EKAuthorizationStatus
    {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.reminder)
        return status
    }
    
    @objc public var reminderAuthorized: Bool
    {
        return reminderAuthorizedStatus == .authorized
    }
    
    /// The app's Info.plist must contain an NSRemindersUsageDescription key
    @objc public func requestReminderAccess(completion: @escaping (Bool) -> Void)
    {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.reminder) { (granted, error) in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!)")
            }
            completion(granted)
        }
    }
    
    /// The current authorization status for a calendar entity type.
    @objc public var calendarAuthorizedStatus: EKAuthorizationStatus
    {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        return status
    }
    
    @objc public var calendarAuthorized: Bool
    {
        return calendarAuthorizedStatus == .authorized
    }
    
    /// The app's Info.plist must contain an NSCalendarsUsageDescription key
    @objc public func requestCalendarAccess(completion: @escaping (Bool) -> Void)
    {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!)")
            }
            completion(granted)
        }
    }
    
}

#endif

//MARK: - Bluetooth

#if canImport(CoreBluetooth)

extension CXPermissionManager: CBCentralManagerDelegate {
    
    /// The current authorization state of a Core Bluetooth manager.
    @available(iOS 13.0, *)
    @objc public var centralManagerAuthorizedStatus: CBManagerAuthorization
    {
        if #available(iOS 13.1, *) {
            return CBCentralManager.authorization
        } else {
            return CBCentralManager().authorization
        }
    }
    
    /// Represents the current authorization state of the peripheral manager.
    @available(iOS, introduced: 7.0, deprecated: 13.0)
    @objc public var peripheralManagerAuthorizedStatus: CBPeripheralManagerAuthorizationStatus {
        return CBPeripheralManager.authorizationStatus()
    }
    
    @objc public func requestBluetoothAccess(completion: @escaping (Bool) -> Void)
    {
        centralManagerUpdatedHandler = completion
        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: nil, options: [:])
        } else {
            if #available(iOS 13, *) {
                centralManagerUpdatedHandler?(centralManagerAuthorizedStatus == .allowedAlways)
            } else {
                centralManagerUpdatedHandler?(peripheralManagerAuthorizedStatus == .authorized)
            }
        }
    }
    
    /// Asks the central manager to stop scanning for peripherals.
    @objc public func stop()
    {
        centralManager?.stopScan()
        centralManager = nil
        centralManagerUpdatedHandler = nil
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 13.0, *) {
            centralManagerUpdatedHandler?(central.authorization == .allowedAlways)
        } else {
            centralManagerUpdatedHandler?(peripheralManagerAuthorizedStatus == .authorized)
        }
    }
    
}

#endif

//MARK: - Device TouchID/FaceID、Passcode

#if canImport(LocalAuthentication)
import LocalAuthentication

extension CXPermissionManager {
    
    @available(iOS 11.0, *)
    @objc public var biometryType: LABiometryType
    {
        let context = LAContext()
        //guard context.biometryType == .faceID else {
        //    return .notSupported
        //}
        //var error: NSError?
        //let isReady = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        //switch error?.code {
        //case nil where isReady:
        //    return .notDetermined
        //case LAError.biometryNotAvailable.rawValue:
        //    return .denied
        //case LAError.biometryNotEnrolled.rawValue:
        //    return .notSupported
        //default:
        //    return .notSupported
        //}
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
    
    /// Evaluates the device biometrics.
    @available(iOS 8.0, *)
    @objc public func evaluateDeviceBiometrics(completion: @escaping (Bool) -> Void)
    {
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { success, error in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!).")
            }
            completion(success)
        }
    }
    
    /// Evaluates the device passcode.
    @available(iOS 8.0, *)
    @objc public func evaluateDevicePasscode(completion: @escaping (Bool) -> Void)
    {
        LAContext().evaluatePolicy(.deviceOwnerAuthentication, localizedReason: " ") { success, error in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!).")
            }
            completion(success)
        }
    }
    
    #if swift(>=5.5)
    @available(iOS 8.0, *)
    public func evaluateDeviceBiometrics() async -> Bool
    {
        do {
            return try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ")
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error).")
            return false
        }
    }
    
    @available(iOS 8.0, *)
    public func evaluateDevicePasscode() async throws -> Bool
    {
        do {
            return try await LAContext().evaluatePolicy(.deviceOwnerAuthentication, localizedReason: " ")
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error).")
            return false
        }
    }
    #endif
    
}

#endif

//MARK: - Apple Music

#if canImport(MediaPlayer)
import MediaPlayer

extension CXPermissionManager {
    
    @available(iOS 9.3, *)
    @objc public var mediaLibraryAuthorizedStatus: MPMediaLibraryAuthorizationStatus
    {
        return MPMediaLibrary.authorizationStatus()
    }
    
    @available(iOS 9.3, *)
    @objc public var mediaLibraryauthorized: Bool
    {
        return mediaLibraryAuthorizedStatus == .authorized
    }
    
    @available(iOS 9.3, *)
    @objc public func requestMediaLibraryAccessStatus(completion: @escaping (MPMediaLibraryAuthorizationStatus) -> Void)
    {
        MPMediaLibrary.requestAuthorization { status in
            completion(status)
        }
    }
    
    @available(iOS 9.3, *)
    @objc public func requestMediaLibraryAccess(completion: @escaping (Bool) -> Void)
    {
        MPMediaLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
    }
    
    #if swift(>=5.5)
    @available(iOS 9.3, *)
    public func requestMediaLibraryAccessStatus() async -> MPMediaLibraryAuthorizationStatus
    {
        return await MPMediaLibrary.requestAuthorization()
    }
    
    @available(iOS 9.3, *)
    public func requestMediaLibraryAccess() async -> Bool
    {
        return await requestMediaLibraryAccessStatus() == .authorized
    }
    #endif
    
}

#endif

//MARK: - Motion

#if canImport(CoreMotion)
import CoreMotion

extension CXPermissionManager {
    
    @available(iOS 11.0, *)
    @objc public var motionAuthorizedStatus: CMAuthorizationStatus
    {
        return CMMotionActivityManager.authorizationStatus()
    }
    
    @available(iOS 11.0, *)
    @objc public var motionAuthorized: Bool
    {
        return motionAuthorizedStatus == .authorized
    }
    
    @available(iOS 7.0, *)
    @objc public func requestMotionAccess(completion: @escaping (Bool) -> Void)
    {
        let manager = CMMotionActivityManager()
        let today = Date()
        manager.queryActivityStarting(from: today, to: today, to: OperationQueue.main, withHandler: { (activities: [CMMotionActivity]?, error: Error?) -> () in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!).")
            }
            completion(error == nil)
            manager.stopActivityUpdates()
        })
    }
    
}

#endif

//MARK: - Health

#if canImport(HealthKit)
import HealthKit

extension CXPermissionManager {
    
    @objc public func healthAuthorizedStatus(forType type: HKObjectType) -> HKAuthorizationStatus
    {
        return HKHealthStore().authorizationStatus(for: type)
    }
    
    @objc public func healthAuthorized(forType type: HKObjectType) -> Bool
    {
        return healthAuthorizedStatus(forType: type) == .sharingAuthorized
    }
    
    @objc public func requestHealthAccess(forReading readingTypes: Set<HKObjectType>, writing writingTypes: Set<HKSampleType>, completion: @escaping (Bool) -> Void)
    {
        HKHealthStore().requestAuthorization(toShare: writingTypes, read: readingTypes) { success, error in
            if error != nil {
                CXLogger.log(level: .error, message: "error=\(error!).")
            }
            completion(success)
        }
    }
    
    #if swift(>=5.5) && !os(tvOS)
    @available(iOS 15.0, watchOS 8.0, macOS 13.0, *)
    public func requestHealthAccess(forReading readingTypes: Set<HKObjectType>, writing writingTypes: Set<HKSampleType>) async -> Bool
    {
        do {
            try await HKHealthStore().requestAuthorization(toShare: writingTypes, read: readingTypes)
            return true
        } catch {
            CXLogger.log(level: .error, message: "error=\(error).")
            return false
        }
    }
    #endif
    
}

#endif

//MARK: - Siri

#if canImport(Intents)
import Intents

extension CXPermissionManager {
    
    @objc public var siriAuthorizedStatus: INSiriAuthorizationStatus
    {
        return INPreferences.siriAuthorizationStatus()
    }
    
    @objc public var siriAuthorized: Bool
    {
        return siriAuthorizedStatus == .authorized
    }
    
    @objc public func requestSiriAccessStatus(completion: @escaping (INSiriAuthorizationStatus) -> Void)
    {
        INPreferences.requestSiriAuthorization(completion)
    }
    
    @objc public func requestSiriAccess(completion: @escaping (Bool) -> Void)
    {
        INPreferences.requestSiriAuthorization { status in
            completion(status == .authorized)
        }
    }
    
}

#endif

//MARK: - Speech

#if canImport(Speech)
import Speech

extension CXPermissionManager {
    
    @objc public var speechAuthorizedStatus: SFSpeechRecognizerAuthorizationStatus
    {
        return SFSpeechRecognizer.authorizationStatus()
    }
    
    @objc public var speechAuthorized: Bool
    {
        return speechAuthorizedStatus == .authorized
    }
    
    @objc public func requestSpeechAccessStatus(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void)
    {
        SFSpeechRecognizer.requestAuthorization(completion)
    }
    
    @objc public func requestSpeechAccess(completion: @escaping (Bool) -> Void)
    {
        SFSpeechRecognizer.requestAuthorization { status in
            completion(status == .authorized)
        }
    }
    
}

#endif

//MARK: - Tracking

#if canImport(AppTrackingTransparency)
import AppTrackingTransparency

@available(iOS 14, *)
extension CXPermissionManager {
    
    @objc public var trackingAuthorizedStatus: ATTrackingManager.AuthorizationStatus
    {
        return ATTrackingManager.trackingAuthorizationStatus
    }
    
    @objc public var trackingAuthorized: Bool
    {
        return trackingAuthorizedStatus == .authorized
    }
    
    @objc public func requestTrackingAccessStatus(completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void)
    {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: completion)
    }
    
    @objc public func requestTrackingAccess(completion: @escaping (Bool) -> Void)
    {
        ATTrackingManager.requestTrackingAuthorization { status in
            completion(status == .authorized)
        }
    }
    
}

#endif

#endif
