[中文版](README.md) | **English Version**

# CXSwiftKit

[![Version](https://img.shields.io/cocoapods/v/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![License](https://img.shields.io/cocoapods/l/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![Platform](https://img.shields.io/cocoapods/p/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)

`CXSwiftKit` provides the utilities and rich extensions of Swift language, and most of them supported Objective-C.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* Xcode 14.0+
* iOS 10.0, tvOS 10.0, macOS 11.0, watchOS 5.0

## Installation

CXSwiftKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CXSwiftKit', '~> 2.0.0'
```

* ApplePay
```
pod 'CXSwiftKit/ApplePay', '~> 2.0.0'
```

* AR
```
pod 'CXSwiftKit/AR', '~> 2.0.0'
```

* NetWork
```
pod 'CXSwiftKit/NetWork', '~> 2.0.0'
```

* EmptyDataSet
```
pod 'CXSwiftKit/EmptyDataSet', '~> 2.0.0'
```

* HandyJSONHelper
```
pod 'CXSwiftKit/HandyJSONHelper', '~> 2.0.0'
```

* KingfisherWrapper
```
pod 'CXSwiftKit/KingfisherWrapper', '~> 2.0.0'
```

* OverlayView
```
pod 'CXSwiftKit/OverlayView', '~> 2.0.0'
```

* RxButton
```
pod 'CXSwiftKit/RxButton', '~> 2.0.0'
```

* RxEmptyDataSet
```
pod 'CXSwiftKit/RxEmptyDataSet', '~> 2.0.0'
```

* RxKafkaRefresh
```
pod 'CXSwiftKit/RxKafkaRefresh', '~> 2.0.0'
```

* RxKingfisher
```
pod 'CXSwiftKit/RxKingfisher', '~> 2.0.0'
```

* RxListDataSource
```
pod 'CXSwiftKit/RxListDataSource', '~> 2.0.0'
```

* RxMJRefresh
```
pod 'CXSwiftKit/RxMJRefresh', '~> 2.0.0'
```

* SDWebImageWrapper
```
pod 'CXSwiftKit/SDWebImageWrapper', '~> 2.0.0'
```

* SvgaPlay
```
pod 'CXSwiftKit/SvgaPlay', '~> 2.0.0'
```

* SVProgressHUDEx
```
pod 'CXSwiftKit/SVProgressHUDEx', '~> 2.0.0'
```

* SwiftMessagesEx
```
pod 'CXSwiftKit/SwiftMessagesEx', '~> 2.0.0'
```

* ToasterEx
```
pod 'CXSwiftKit/ToasterEx', '~> 2.0.0'
```

* ToastSwiftEx
```
pod 'CXSwiftKit/ToastSwiftEx', '~> 2.0.0'
```

* WebSocket
```
pod 'CXSwiftKit/WebSocket', '~> 2.0.0'
```

## Preview

**More content needs you to explore.**

<div align=left>
&emsp; <img src="https://github.com/chenxing640/CXSwiftKit/raw/master/IMG_0716.gif" width="50%" />
</div>

## Tree Structure Description

```
CXSwiftKit
  ┣ ApplePay
  ┃   ┗ CXApplePayContext.swift // The implementation for Apple payment.
  ┃
  ┣ AR
  ┃   ┣ ARSCNView+Cx.swift          // Used to supply extensions of ARSCNView.
  ┃   ┣ CXMetalVideoRecorder.swift  // Used to handle metal video recording.
  ┃   ┣ CXSCNLinePainter.swift      // Draws line in augmented reality scene.
  ┃   ┣ CXSCNTextPainter.swift      // Draws text in augmented reality scene.
  ┃   ┣ float4x4+Cx.swift           // Used to supply extensions of float4x4.
  ┃   ┣ SCNSceneRenderer+Cx.swift   // Used to supply extensions of SCNSceneRenderer.
  ┃   ┗ SCNVector3+Cx.swift         // Used to supply extensions of SCNVector3.
  ┃
  ┣ Base
  ┃   ┣ CXAssociatedKey.swift
  ┃   ┣ CXConfig.swift              // The configuration of this kit.
  ┃   ┣ CXConstraintMaker.swift  
  ┃   ┣ CXGlobal.swift              // Provides some global methods
  ┃   ┣ CXLock.swift                // Includes multi-thread locks(`CXUnfairLock, CXMutex, CXRecursiveMutex, CXSpin, CXConditionLock`).
  ┃   ┣ CXLogger.swift              // Outputs logs to the console.
  ┃   ┗ CXSwiftBase.swift           // Declares a `CXSwiftBaseCompatible` protocol, etc. You can use `cx` in the app, e.g.: view.cx.right = 10
  ┃
  ┣ Core
  ┃   ┣ Atomic
  ┃   ┃   ┗ AtomicWrapper.swift       // Used to wrap atomic property.
  ┃   ┣ AVToolbox
  ┃   ┃   ┣ CXAudioRecorder.swift     // The audio recorder that records audio data to a file.
  ┃   ┃   ┣ CXAudioToolbox.swift      // Used to handle audio format.
  ┃   ┃   ┣ CXAVGlobal.swift          // The global methods for the exported position.
  ┃   ┃   ┣ CXAVToolbox.swift         // Used to handle audio and video mix.
  ┃   ┃   ┗ CXVideoToolbox.swift      // Used to convert mp4 video format.
  ┃   ┣ Camera
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
  ┃   ┣ CXAppContext.swift
  ┃   ┣ CXDevice.swift                 // Used to provide some device informations.
  ┃   ┣ CXDeviceScreenMonitor.swift    // Used to observe some changes of device screen.
  ┃   ┣ CXHaptics.swift                // Some haptic feedback that works on iPhone 6 and up.
  ┃   ┣ CXPhotoLibraryOperator.swift   // Used to operate the photo library.
  ┃   ┣ CXScreenRecorder.swift         // The recorder that provides the ability to record audio and video of your app.
  ┃   ┣ CXSwiftUtils.swift
  ┃   ┣ CXSwipeInteractor.swift        // Add swipe gesture for the view, and observe its action.
  ┃   ┣ CXTakeScreenshotDetector.swift // The detector for taking screenshot.
  ┃   ┣ DocumentPicker // The document picker for iOS.
  ┃   ┃   ┣ CXDocument.swift
  ┃   ┃   ┣ CXDocumentDelegate.swift
  ┃   ┃   ┣ CXDocumentPicker.swift
  ┃   ┃   ┗ CXDocumentDelegate.swift
  ┃   ┣ Extension // Provides some rich extensions
  ┃   ┃   ┣ Application+Cx.swift
  ┃   ┃   ┣ Array+Cx.swift
  ┃   ┃   ┣ AVAsset+Cx.swift
  ┃   ┃   ┣ Button+Cx.swift
  ┃   ┃   ┣ CALayer+Cx.swift
  ┃   ┃   ┣ CGFloat+Cx.swift
  ┃   ┃   ┣ Color+Cx.swift
  ┃   ┃   ┣ Date+Cx.swift
  ┃   ┃   ┣ Device+Cx.swift
  ┃   ┃   ┣ Dictionary+Cx.swift
  ┃   ┃   ┣ DispatchQueue+Cx.swift
  ┃   ┃   ┣ Double+Cx.swift
  ┃   ┃   ┣ Font+Cx.swift
  ┃   ┃   ┣ Image+Cx.swift
  ┃   ┃   ┣ ImageView+Cx.swift
  ┃   ┃   ┣ Int+Cx.swift
  ┃   ┃   ┣ Label+Cx.swift 
  ┃   ┃   ┣ NSAttributedString+Cx.swift 
  ┃   ┃   ┣ NSObject+Cx.swift
  ┃   ┃   ┣ Optional+Cx.swift
  ┃   ┃   ┣ ScrollView+Cx.swift
  ┃   ┃   ┣ String+Cx.swift
  ┃   ┃   ┣ TableView+Cx.swift
  ┃   ┃   ┣ TextField+Cx.swift
  ┃   ┃   ┣ TextView+Cx.swift
  ┃   ┃   ┣ URL+Cx.swift
  ┃   ┃   ┣ View+Cx.swift
  ┃   ┃   ┗ ViewController+Cx.swift
  ┃   ┣ FileOperation
  ┃   ┃   ┣ CXFileToolbox.swift  // The file toolbox.
  ┃   ┃   ┣ CXLineReader.swift   // Read text file line by line in efficient way.
  ┃   ┃   ┗ CXStreamReader.swift // The file descriptor accesses data associated with files.
  ┃   ┣ ImageBuffer // Used to process image buffer.
  ┃   ┃   ┗ CXImageBufferProcessor.swift 
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
  ┃       ┣ CXCircleProgressButton.swift                 // The circle progress button for iOS or tvOS.
  ┃       ┗ CXVerticalSlider.swift                       // The vertical slider for iOS or tvOS.
  ┃
  ┣ EmptyDataSet
  ┃   ┣ CXEmptyDataSetDecorator.swift
  ┃   ┗ CXEmptyDataSetStyle.swift
  ┃
  ┣ HandyJSONHelper
  ┃   ┗ HandyJSONHelper.swift
  ┃
  ┣ KingfisherWrapper
  ┃   ┣ Button+kfwrapper.swift
  ┃   ┣ CXKingfisherReferer.swift // Used to set the referer of image.
  ┃   ┗ ImageView+kfwrapper.swift
  ┃
  ┣ NetWork // Moya + HandyJSON
  ┃   ┣ CXNetWorkManager.swift  // CXNetWorkManager.shared.request(api: StreamAPI(downloadURL: URL(string: "imgurl")!, toDirectory: "Images")) { result in }
  ┃   ┣ CXRequest.swift
  ┃   ┣ CXRequestProtocol.swift // DataResponse<User>.request(api: APIType, response: { result in })
  ┃   ┣ CXResponse.swift        // DataResponse<T>, ListResponse<T>, DataSetResponse<T>, MessageResponse
  ┃   ┗ CXResponseResult.swift
  ┃
  ┣ OverlayView
  ┃   ┗ OverlayView+Cx.swift
  ┃
  ┣ RxButton
  ┃   ┗ RxButton+Cx.swift
  ┃
  ┣ RxEmptyDataSet
  ┃   ┗ RxEmptyDataSet+Cx.swift
  ┃
  ┣ RxKafkaRefresh
  ┃   ┗ RxKafkaRefresh+Cx.swift
  ┃
  ┣ RxKingfisher
  ┃   ┗ RxKingfisher+Cx.swift
  ┃
  ┣ RxListDataSource
  ┃   ┣ CXCollectionReusableView.swift
  ┃   ┣ CXListDataSourceProvider.swift
  ┃   ┗ CXListEntity.swift
  ┃
  ┣ RxMJRefresh
  ┃   ┗ RxMJRefresh+Cx.swift
  ┃
  ┣ SDWebImageWrapper
  ┃   ┗ SDWebImageWrapper.swift
  ┃
  ┣ SvgaPlay
  ┃   ┣ CXSvgaPlayManager
  ┃   ┗ CXSvgaPlayOperation.swift
  ┃
  ┣ SVProgressHUDEx
  ┃   ┗ SVProgressHUD+Cx.swift
  ┃
  ┣ SwiftMessagesEx
  ┃   ┗ SwiftMessages+Cx.swift
  ┃
  ┣ ToasterEx
  ┃   ┗ Toaster+Cx.swift
  ┃
  ┣ ToastSwiftEx
  ┃   ┗ ToastSwift+Cx.swift
  ┃
  ┣ WebSocket
      ┗ CXWebSocket.swift // Uses `Starscream` to wraps the web socket.
```

## 推荐

- [CXDownload](https://github.com/chenxing640/CXDownload) - Realization of breakpoint transmission download with Swift, support Objective-C. Including large file download, background download, killing the process, continuing to download when restarting, setting the number of concurrent downloads, monitoring network changes and so on.

## Handling Error

if `SVGAPlayer` library occurs this error：

```
Conflicting types for 'OSAtomicCompareAndSwapPtrBarrier'
Implicit declaration of function 'OSAtomicCompareAndSwapPtrBarrier' is invalid in C99
```

> if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
>    [worker release];
> }

Add the header in `Svga.pbobjc.h` or `Svga.pbobjc.m`.

```
#import <libkern/OSAtomic.h>
```

## Author

chenxing, chenxing640@foxmail.com

## License

CXSwiftKit is available under the MIT license. See the LICENSE file for more info.
