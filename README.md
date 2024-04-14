**中文版** | [English Version](README-en.md)

# CXSwiftKit

[![Version](https://img.shields.io/cocoapods/v/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![License](https://img.shields.io/cocoapods/l/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![Platform](https://img.shields.io/cocoapods/p/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)

`CXSwiftKit`提供了Swift语言实用工具和丰富的扩展，并大多数支持了Objective-C。

## 示例

要运行示例项目，首先克隆repo，并从示例目录运行“pod install”。

## 要求

* Xcode 14.0+
* iOS 10.0, tvOS 10.0, macOS 11.0, watchOS 5.0

## 安装

CXSwiftKit可通过[CocoaPods](https://cocoapods.org)获得。安装只需将下面一行添加到您的Podfile中:

```ruby
pod 'CXSwiftKit', '~> 2.0.0'
```

* ApplePay
```
pod 'CXSwiftKit/ApplePay', '~> 2.0.0'
```

<!--* AR-->
<!--```-->
<!--pod 'CXSwiftKit/AR', '~> 2.0.0'-->
<!--```-->

<!--* NetWork-->
<!--```-->
<!--pod 'CXSwiftKit/NetWork', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* EmptyDataSet-->
<!--```-->
<!--pod 'CXSwiftKit/EmptyDataSet', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* HandyJSONHelper-->
<!--```-->
<!--pod 'CXSwiftKit/HandyJSONHelper', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* KingfisherWrapper-->
<!--```-->
<!--pod 'CXSwiftKit/KingfisherWrapper', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* OverlayView-->
<!--```-->
<!--pod 'CXSwiftKit/OverlayView', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* RxButton-->
<!--```-->
<!--pod 'CXSwiftKit/RxButton', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* RxEmptyDataSet-->
<!--```-->
<!--pod 'CXSwiftKit/RxEmptyDataSet', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* RxKafkaRefresh-->
<!--```-->
<!--pod 'CXSwiftKit/RxKafkaRefresh', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* RxKingfisher-->
<!--```-->
<!--pod 'CXSwiftKit/RxKingfisher', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* RxListDataSource-->
<!--```-->
<!--pod 'CXSwiftKit/RxListDataSource', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* RxMJRefresh-->
<!--```-->
<!--pod 'CXSwiftKit/RxMJRefresh', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* SDWebImageWrapper-->
<!--```-->
<!--pod 'CXSwiftKit/SDWebImageWrapper', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* SvgaPlay-->
<!--```-->
<!--pod 'CXSwiftKit/SvgaPlay', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* SVProgressHUDEx-->
<!--```-->
<!--pod 'CXSwiftKit/SVProgressHUDEx', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* SwiftMessagesEx-->
<!--```-->
<!--pod 'CXSwiftKit/SwiftMessagesEx', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* ToasterEx-->
<!--```-->
<!--pod 'CXSwiftKit/ToasterEx', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* ToastSwiftEx-->
<!--```-->
<!--pod 'CXSwiftKit/ToastSwiftEx', '~> 2.0.0'-->
<!--```-->
<!---->
<!--* WebSocket-->
<!--```-->
<!--pod 'CXSwiftKit/WebSocket', '~> 2.0.0'-->
<!--```-->

## 预览

**更多内容需要你来探索。**

<div align=left>
&emsp; <img src="https://github.com/chenxing640/CXSwiftKit/raw/master/IMG_0716.gif" width="50%" />
</div>

## 树结构说明

```
CXSwiftKit
  ┣ ApplePay
  ┃   ┗ CXApplePayContext.swift     // The implementation for Apple payment.
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
      ┣ CXFileToolbox.swift  // The file toolbox.
      ┣ CXLineReader.swift   // Read text file line by line in efficient way.
      ┗ CXStreamReader.swift // The file descriptor accesses data associated with files.
```

```
Other
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

- [CXDownload](https://github.com/chenxing640/CXDownload) - 实现Swift断点续传下载，支持Objective-C。包含大文件下载，后台下载，杀死进程，重新启动时继续下载，设置下载并发数，监听网络改变等。

## 处理错误

如果在`SVGAPlayer`库中报以下错误：

```
Conflicting types for 'OSAtomicCompareAndSwapPtrBarrier'
Implicit declaration of function 'OSAtomicCompareAndSwapPtrBarrier' is invalid in C99
```

> if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
>    [worker release];
> }

那么在`Svga.pbobjc.h`或者`Svga.pbobjc.m`文件中添加以下头文件。

```
#import <libkern/OSAtomic.h>
```

## 作者

chenxing, chenxing640@foxmail.com

## 许可

CXSwiftKit is available under the MIT license. See the LICENSE file for more info.
