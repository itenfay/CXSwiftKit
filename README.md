**中文版** | [English Version](README-en.md)

# CXSwiftKit

`CXSwiftKit`提供了Swift语言实用工具和丰富的扩展。

[![Version](https://img.shields.io/cocoapods/v/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![License](https://img.shields.io/cocoapods/l/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)
[![Platform](https://img.shields.io/cocoapods/p/CXSwiftKit.svg?style=flat)](https://cocoapods.org/pods/CXSwiftKit)

## 预览

**更多内容需要你来探索。**

<div align=left>
&emsp; <img src="https://github.com/chenxing640/CXSwiftKit/raw/master/IMG_0716.gif" width="50%" />
</div>

> **如果觉得还行呢，就麻烦顺手给个`star`。**

## 特色

- **ApplePay**`(可选)`：用于苹果支付。
- **AVToolbox**：用于录音、音视频格式转换。
- **Base**：包含配置、定义和日志输出等。
- **Core**：包含APP重签检测、获取设备信息、相册操作、录屏、截屏检测、跳转等。
- **Camera**：用于iOS相机采样数据捕获。
- **DocumentPicker**：用于系统文件操作。
- **Extension**：包含`Array、Dictionary、Int、Double、CGFloat、String、NSAttributedString、CALayer、NSObject、DispatchQueue、UIDevice、UIColor、UIImage、UIImageView、UIView、UIViewController`等扩展。
- **FileOperation**：用于iOS沙盒文件操作。<!--- **HandyJSONHelper**`(可选)`：HandyJSONHelper封装了JSON的转换。-->
- **KingfisherWrapper**`(可选)`：Kingfisher的防盗链设置、UIButton/UIImageView快速设置图片扩展，常用功能封装。
- **LiveGift**：用于展示直播小礼物🎁赠送
- **OverlayView**：用于弹出上下左右各个方向的覆盖视图。
-  **Permissions**：用于iOS的照片库、相机、麦克风、位置、蓝牙、通讯录、提醒、日历、Siri、通知、追踪等各种权限。
- **Timer**：封装了DispatchTimer和Timer。
- **Transition**：用于过渡场景切换。
- **Widget**：自定义控件。
- **SDWebImageWrapper**`(可选)`：SDWebImage的防盗链设置和常用功能封装。

## 要求

* Xcode 14.0+
* iOS 11.0, tvOS 11.0, macOS 10.15, watchOS 5.0

## 安装

CXSwiftKit可通过[CocoaPods](https://cocoapods.org)获得。安装只需将下面一行添加到您的Podfile中:

* CXSwiftKit
```ruby
pod 'CXSwiftKit'
```

* ApplePay
```
pod 'CXSwiftKit/ApplePay'
```

* KingfisherWrapper
```
pod 'CXSwiftKit/KingfisherWrapper'
```

* SDWebImageWrapper
```
pod 'CXSwiftKit/SDWebImageWrapper'
```

## 树结构说明

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
  ┣ KingfisherWrapper
  ┃    ┣ Button+kfwrapper.swift
  ┃    ┣ CXKingfisherReferer.swift // Anti theft chains for files such as images and videos, and so on.
  ┃    ┗ ImageView+kfwrapper.swift
  ┃
  ┗ SDWebImageWrapper
       ┗ SDWebImageWrapper.swift // The wrapper for SDWebImage.
```

## 推荐

- [CXDownload](https://github.com/chenxing640/CXDownload) - 实现Swift断点续传下载，支持Objective-C。包含大文件下载，后台下载，杀死进程，重新启动时继续下载，设置下载并发数，监听网络改变等。
- [MarsUIKit](https://github.com/chenxing640/MarsUIKit) - `MarsUIKit` wraps some commonly used UI components.
- [RxListDataSource](https://github.com/chenxing640/RxListDataSource) - `RxListDataSource` provides data sources for UITableView or UICollectionView.
- [CXNetwork-Moya](https://github.com/chenxing640/CXNetwork-Moya) - `CXNetwork-Moya` encapsulates a network request library with Moya and ObjectMapper.

## 示例

要运行示例项目，首先克隆repo，并从示例目录运行“pod install”。

## 作者

Teng Fei, hansen981@126.com

## 许可

CXSwiftKit is available under the MIT license. See the LICENSE file for more info.
