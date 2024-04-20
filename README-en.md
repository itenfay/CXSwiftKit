[中文版](README.md) | **English Version**

# CXSwiftKit

`CXSwiftKit` provides the utilities and rich extensions of Swift language.

[![Version](https://img.shields.io/cocoapods/v/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![License](https://img.shields.io/cocoapods/l/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![Platform](https://img.shields.io/cocoapods/p/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)

## Preview

**More content needs you to explore.**

<div align=left>
&emsp; <img src="https://github.com/chenxing640/CXSwiftKit/raw/master/IMG_0716.gif" width="50%" />
</div>

> **If you think it's okay, please give it a `star`**

## Fetures

- **ApplePay**`(Optional)`：This is used for Apple payment.
- **AVToolbox**：This is used for audio and video format conversion.
- **Base**：Includes configuration, definition, and log output.
- **Core**：Includes APP resignature detection, obtaining device information, album operation, screen recording, screenshot detection, redirection, etc.
- **Camera**：This is used for iOS camera sampling data capture.
- **DocumentPicker**：This is used for system file operations.
- **Extension**：Includes the extensions of `Array、Dictionary、Int、Double、CGFloat、String、NSAttributedString、CALayer、NSObject、DispatchQueue、UIDevice、UIColor、UIImage、UIImageView、UIView、UIViewController, etc.`. 
- **FileOperation**：This is used for iOS sandbox file operations.
<!--- **HandyJSONHelper**`(Optional)`：`HandyJSONHelper` wraps the JSON conversion.-->
- **KingfisherWrapper**`(Optional)`：`Kingfisher`'s anti-theft chain settings, `UIButton/UIImageView`'s extensions is used to set the image, and wraps commonly used functions.
- **LiveGift**：This is used to showcase small gifts for live streaming.
- **OverlayView**：This is used to pop up overlay views in all directions up, down, left, and right.
-  **Permissions**：Various permissions for iOS, including `photo library, camera, microphone, location, Bluetooth, contacts, reminders, calendar, Siri, notifications, tracking, and more`.
- **Timer**：Encapsulated `Dispatch Timer` and `Timer`.
- **Transition**：This is for switching transitional scene.
- **Widget**：The custom widgets.
- **SDWebImageWrapper**`(Optional)`：`SDWebImage`'s anti-theft chain settings and common functions encapsulation.

## Requirements

* Xcode 14.0+
* iOS 11.0, tvOS 11.0, macOS 11.0, watchOS 5.0

## Installation

CXSwiftKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

* CXSwiftKit
```ruby
pod 'CXSwiftKit'
```

* ApplePay
```
pod 'CXSwiftKit/ApplePay'
```

* HandyJSONHelper
```
pod 'CXSwiftKit/HandyJSONHelper'
```

* KingfisherWrapper
```
pod 'CXSwiftKit/KingfisherWrapper'
```

* SDWebImageWrapper
```
pod 'CXSwiftKit/SDWebImageWrapper'
```

## Tree Structure Description

```
CXSwiftKit
  ┣ ApplePay
  ┃   ┗ CXApplePayContext.swift     // The implementation for Apple payment.
  ┃
  ┣ Base
  ┃   ┣ 
  ┃   ┣ CXConfig.swift              // The configuration of this kit.
  ┃   ┣ CXDefines.swift             // The definitions of this kit.
  ┃   ┣ CXLock.swift                // Includes multi-thread locks(`CXUnfairLock, CXMutex, CXRecursiveMutex, CXSpin, CXConditionLock`).
  ┃   ┗ CXLogger.swift              // Outputs logs to the console.
  ┃
  ┣ Core
  ┃   ┣ CXAppContext.swift
  ┃   ┣ CXDevice.swift                 // Used to provide some device informations.
  ┃   ┣ CXDeviceScreenMonitor.swift    // Used to observe some changes of device screen.
  ┃   ┣ CXHaptics.swift                // Some haptic feedback that works on iPhone 6 and up.
  ┃   ┣ CXImageBufferProcessor.swift   // Used to process image buffer.
  ┃   ┣ CXPhotoLibraryOperator.swift   // Used to operate the photo library.
  ┃   ┣ CXScreenRecorder.swift         // The recorder that provides the ability to record audio and video of your app.
  ┃   ┣ CXSwiftUtils.swift
  ┃   ┣ CXSwipeInteractor.swift        // Add swipe gesture for the view, and observe its action.
  ┃   ┗ CXTakeScreenshotDetector.swift // The detector for taking screenshot.
  ┃   ┣ AVToolbox
  ┃   ┃   ┣ CXAudioRecorder.swift     // The audio recorder that records audio data to a file.
  ┃   ┃   ┣ CXAudioToolbox.swift      // Used to handle audio format.
  ┃   ┃   ┣ CXAVGlobal.swift          // The global methods for the exported position.
  ┃   ┃   ┣ CXAVToolbox.swift         // Used to handle audio and video mix.
  ┃   ┃   ┗ CXVideoToolbox.swift      // Used to convert mp4 video format.
  ┃   ┣ Camera
  ┃   ┃   ┣ AtomicWrapper.swift       // Used to wrap atomic property.
  ┃   ┃   ┣ CXLiveCameraConfiguration.swift // The configuration for live camera.
  ┃   ┃   ┣ CXLiveCameraFrameCapturer.swift      
  ┃   ┃   ┣ CXLiveCameraFrameRenderer.swift 
  ┃   ┃   ┣ CXLiveCameraPreview.swift        
  ┃   ┃   ┣ CXLiveCameraProtocol.swift         
  ┃   ┃   ┣ CXScanProtocol.swift         
  ┃   ┃   ┣ CXScanResult.swift         
  ┃   ┃   ┗ CXScanWrapper.swift  
  ┃   ┣ CustomOverlayView
  ┃   ┃   ┣ CXOverlayViewControllerWrapable.swift  
  ┃   ┃   ┣ CXOverlayViewEx.swift      
  ┃   ┃   ┗ CXOverlayViewWrapable.swift
  ┃   ┣ DocumentPicker // The document picker for iOS.
  ┃   ┃   ┣ CXDocument.swift
  ┃   ┃   ┣ CXDocumentDelegate.swift
  ┃   ┃   ┣ CXDocumentPicker.swift
  ┃   ┃   ┗ CXDocumentDelegate.swift
  ┃   ┣ LiveGift // Used to show live gifts.
  ┃   ┃   ┣ CXLiveGiftLabel.swift
  ┃   ┃   ┣ CXLiveGiftManager.swift
  ┃   ┃   ┣ CXLiveGiftModel.swift
  ┃   ┃   ┣ CXLiveGiftOperation.swift
  ┃   ┃   ┗ CXLiveGiftView.swift
  ┃   ┣ Permissions 
  ┃   ┃   ┣ CXPermission.swift
  ┃   ┃   ┣ CXPermissionResult.swift
  ┃   ┃   ┣ CXPermissions.swift // Includes photos, camera, microphone, locationAlways, locationInUse, notification, bluetooth, 
  ┃   ┃   ┃ // deviceBiometrics, devicePasscode, contacts, reminder, event, motion, siri, health, media, appTracking.
  ┃   ┃   ┣ CXPermissionStatus.swift
  ┃   ┃   ┣ CXPermissionType.swift
  ┃   ┣ Timer
  ┃   ┃   ┣ CXDispatchTimer.swift
  ┃   ┃   ┗ CXTimer.swift
  ┃   ┣ Transition // Views the demo in CXScalePresentAnimation.swift.
  ┃   ┃   ┣ CXScaleDismissAnimation.swift
  ┃   ┃   ┣ CXScalePresentAnimation.swift
  ┃   ┃   ┗ CXSwipeLeftInteractiveTransition.swift  
  ┃   ┗ Widget
  ┃       ┣ CXCircleProgressButton.swift   // The circle progress button for iOS or tvOS.
  ┃       ┗ CXVerticalSlider.swift         // The vertical slider for iOS or tvOS.
  ┃
  ┣ Extension // Provides some rich extensions
  ┃   ┣ Application+Cx.swift
  ┃   ┣ Array+Cx.swift
  ┃   ┣ AVAsset+Cx.swift
  ┃   ┣ Button+Cx.swift
  ┃   ┣ CALayer+Cx.swift
  ┃   ┣ CGFloat+Cx.swift
  ┃   ┣ Color+Cx.swift
  ┃   ┣ CXAssociatedKey.swift // Includes the associated keys.
  ┃   ┣ CXConstraintMaker.swift  
  ┃   ┣ CXGlobal.swift     // Provides some global methods
  ┃   ┣ CXSwiftBase.swift  // Declares a `CXSwiftBaseCompatible` protocol, etc. You can use `cx` in the app, e.g.: view.cx.right = 10
  ┃   ┣ Date+Cx.swift
  ┃   ┣ Device+Cx.swift
  ┃   ┣ Dictionary+Cx.swift
  ┃   ┣ DispatchQueue+Cx.swift
  ┃   ┣ Double+Cx.swift
  ┃   ┣ Font+Cx.swift
  ┃   ┣ Image+Cx.swift
  ┃   ┣ ImageView+Cx.swift
  ┃   ┣ Int+Cx.swift
  ┃   ┣ Label+Cx.swift 
  ┃   ┣ NSAttributedString+Cx.swift 
  ┃   ┣ NSObject+Cx.swift
  ┃   ┣ Optional+Cx.swift
  ┃   ┣ ScrollView+Cx.swift
  ┃   ┣ String+Cx.swift
  ┃   ┣ TableView+Cx.swift
  ┃   ┣ TextField+Cx.swift
  ┃   ┣ TextView+Cx.swift
  ┃   ┣ URL+Cx.swift
  ┃   ┣ View+Cx.swift
  ┃   ┗ ViewController+Cx.swift
  ┃
  ┣ FileOperation
  ┃   ┣ CXFileToolbox.swift  // The file toolbox.
  ┃   ┣ CXLineReader.swift   // Read text file line by line in efficient way.
  ┃   ┗ CXStreamReader.swift // The file descriptor accesses data associated with files.
  ┃  
  ┣ HandyJSONHelper
  ┃   ┗ HandyJSONHelper.swift // The helper for HandJSON.
  ┃
  ┣ KingfisherWrapper
  ┃    ┣ Button+kfwrapper.swift
  ┃    ┣ CXKingfisherReferer.swift // Anti theft chains for files such as images and videos, and so on.
  ┃    ┗ ImageView+kfwrapper.swift
  ┃
  ┣ SDWebImageWrapper
       ┗ SDWebImageWrapper.swift // The wrapper for SDWebImage.
```

## Recommendation

- [CXDownload](https://github.com/chenxing640/CXDownload) - Realization of breakpoint transmission download with Swift, support Objective-C. Including large file download, background download, killing the process, continuing to download when restarting, setting the number of concurrent downloads, monitoring network changes and so on.
- [MarsUIKit](https://github.com/chenxing640/MarsUIKit) - `MarsUIKit` wraps some commonly used UI components.
- [RxListDataSource](https://github.com/chenxing640/RxListDataSource) - `RxListDataSource` provides data sources for UITableView or UICollectionView.
- [CXNetwork-Moya](https://github.com/chenxing640/CXNetwork-Moya) - `CXNetwork-Moya` encapsulates a network request library with Moya and ObjectMapper.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Teng Fei, hansen981@126.com

## License

CXSwiftKit is available under the MIT license. See the LICENSE file for more info.
