中文 | [English](README-en.md)

# CXSwiftKit

[![CI Status](https://img.shields.io/travis/chenxing640/CXSwiftKit.svg?style=flat)](https://travis-ci.org/chenxing640/CXSwiftKit)
[![Version](https://img.shields.io/cocoapods/v/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![License](https://img.shields.io/cocoapods/l/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![Platform](https://img.shields.io/cocoapods/p/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)

`CXSwiftKit`提供了swift语言的丰富扩展，也支持Objective-C。

## 示例

要运行示例项目，首先克隆repo，并从示例目录运行“pod install”。

## 要求

Xcode 14.0+, iOS 10.0, tvOS 10.0, macOS 11.0, watchOS 5.0

## 安装

CXSwiftKit可通过[CocoaPods](https://cocoapods.org)获得。安装只需将下面一行添加到您的Podfile中:

```ruby
pod 'CXSwiftKit'
```

## 目录结构说明

```
|- Base
|   |- CXConfig.swift    // The configuration of this kit.
|   |- CXLock.swift      // Includes multi-thread locks(`CXUnfairLock, CXMutex, CXRecursiveMutex, CXSpin, CXConditionLock`).
|   |- CXLogger.swift    // Outputs logs to the console.
|   |- CXSwiftBase.swift // Declares a `CXSwiftBaseCompatible` protocol, etc. You can use `cx` in the app, e.g.: view.cx.right = 10
|
|- ApplePay
|   |- CXApplePayContext.swift // The implementation for Apple payment.
|
|- Core
|   |- AVToolbox
|       |- CXAudioRecorder.swift     // The audio recorder that records audio data to a file.
|       |- CXAudioToolbox.swift      // Used to handle audio format.
|       |- CXAVExportConfig.swift    // The configuration for exporting avasset.
|       |- CXAVToolbox.swift         // Used to handle audio and video mix.
|       |- CXVideoToolbox.swift      // Used to convert mp4 video format.
|   |- CXAppContext.swift
|   |- CXDevice.swift                 // Used to provide some device informations.
|   |- CXDeviceScreenContext.swift    // Used to observe some changes of device screen.
|   |- CXHaptics.swift                // Some haptic feedback that works on iPhone 6 and up.
|   |- CXKingfisherReferer.swift      // Used to set the referer of image.
|   |- CXMetalVideoRecorder.swift     
|   |- CXPhotoLibraryOperator.swift   // Used to operate the photo library.
|   |- CXScreenRecorder.swift         // The recorder that provides the ability to record audio and video of your app.
|   |- CXSwiftUtils.swift
|   |- CXSwipeContext.swift           // Add swipe gesture for the view, and observe its action.
|   |- CXTakeScreenshotDetector.swift // The detector for taking screenshot.
|   |- DocumentPicker // The document picker for iOS.
|       |- CXDocument.swift
|       |- CXDocumentDelegate.swift
|       |- CXDocumentPicker.swift
|       |- CXDocumentDelegate.swift
|   |- EmptyDataSet // Used to set empty data for list view.
|       |- CXEmptyDataSetMediator.swift 
|       |- CXEmptyDataSetStyle.swift
|   |- Permissions 
|       |- CXPermission.swift
|       |- CXPermissionResult.swift
|       |- CXPermissions.swift // Includes photos, camera, microphone, locationAlways, locationInUse, notification, bluetooth, 
|       // deviceBiometrics, devicePasscode, contacts, reminder, event, motion, siri, health, media, appTracking.
|       |- CXPermissionStatus.swift
|       |- CXPermissionType.swift
|   |- svga // Used to show animation of the svga file in iOS.
|       |- CXSvgaPlayManager.swift
|       |- CXSvgaPlayOperation.swift
|   |- Timer
|       |- CXDispatchTimer.swift
|       |- CXTimer.swift
|   |- Transition // Views the demo in CXScalePresentAnimation.swift.
|       |- CXScaleDismissAnimation.swift
|       |- CXScalePresentAnimation.swift
|       |- CXSwipeLeftInteractiveTransition.swift
|   |- WebSocket
|       |- CXWebSocket.swift                            // Uses `Starscream` to wraps the web socket.
|   |- Widget
|       |- CXCircleProgressButton.swift                 // The circle progress button for iOS or tvOS.
|       |- CXVerticalSlider.swift                       // The vertical slider for iOS or tvOS.
|
|- Extension // Provides some rich extensions
|   |- Application+Cx.swift
|   |- Array+Cx.swift
|   |- AVAsset+Cx.swift
|   |- Button+Cx.swift
|   |- CALayer+Cx.swift
|   |- CGFloat+Cx.swift
|   |- Color+Cx.swift
|   |- CXGlobal.swift           // Provides some global methods.
|   |- Date+Cx.swift
|   |- Device+Cx.swift
|   |- Dictionary+Cx.swift
|   |- DispatchQueue+Cx.swift
|   |- Double+Cx.swift
|   |- Font+Cx.swift
|   |- Image+Cx.swift
|   |- ImageView+Cx.swift
|   |- Int+Cx.swift
|   |- Label+Cx.swift 
|   |- NSAttributedString+Cx.swift 
|   |- NSObject+Cx.swift
|   |- Optional+Cx.swift
|   |- ScrollView+Cx.swift
|   |- String+Cx.swift
|   |- TableView+Cx.swift
|   |- TextField+Cx.swift
|   |- TextView+Cx.swift
|   |- URL+Cx.swift
|   |- View+Cx.swift
|   |- ViewController+Cx.swift
|
|- FileOperation
|   |- CXFileToolbox.swift  // The file toolbox.
|   |- CXLineReader.swift   // Read text file line by line in efficient way.
|   |- CXStreamReader.swift // The file descriptor accesses data associated with files.
|
|- LiveGift // Used to show live gifts.
|   |- CXLiveGiftLabel.swift
|   |- CXLiveGiftManager.swift
|   |- CXLiveGiftModel.swift
|   |- CXLiveGiftOperation.swift
|   |- CXLiveGiftView.swift
|
|- NetWork // Moya + HandyJSON
|   |- CXNetWorkManager.swift    // CXNetWorkManager.shared.request(api: StreamAPI(downloadURL: URL(string: "imgurl")!, toDirectory: "Images")) { result in }
|   |- CXRequest.swift
|   |- CXRequestProtocol.swift   // DataResponse<User>.request(api: APIType, response: { result in })
|   |- CXResponse.swift          // DataResponse<T>, ListResponse<T>, DataSetResponse<T>, MessageResponse
|   |- CXResponseResult.swift
|
|- Protocol
|   |- CXCommonWrapable.swift         // Abstracts common calls for `SVProgressHUD, SwiftMessages, Toaster`
|   |- CXViewControllerWrapable.swift // Used to present or dismiss view.
|   |- CXViewWrapable.swift           // Used to present or dismiss view, abstracts common calls for `Toast_Swift`
|
|- Rx
|   |- Button+RxCx.swift        // Used to show indicator
|   |- EmptyDataSet+RxCx.swift  // Used to bind empty data set for list view.
|   |- KafkaRefresh+RxCx.swift  // Used to set refresh control for list view.
|   |- Kingfisher+RxCx.swift    // Used to set remote image for image view.
|   |- MJRefresh+RxCx.swift     // Used to set refresh control for list view.
```

## 作者

chenxing, chenxing640@foxmail.com

## 许可

CXSwiftKit is available under the MIT license. See the LICENSE file for more info.
