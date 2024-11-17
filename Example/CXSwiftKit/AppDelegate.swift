//
//  AppDelegate.swift
//  CXSwiftKit
//
//  Created by Tenfay on 11/14/2022.
//  Copyright (c) 2022 Tenfay. All rights reserved.
//

import UIKit
import CXSwiftKit
import SVProgressHUD
import Toaster
import MarsUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        presentInWindow(window!)
        
        setupLibs()
        CXConfig.enableLog = CXAppContext().isDebug
        
        ReachabilityManager.shared.startListening()
        
        DispatchQueue.cx.mainAsyncAfter(2) {
            self.checkApp()
        }
        
        return true
    }
    
    func presentInWindow(_ window: UIWindow) {
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func setupLibs() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setDefaultAnimationType(.flat)
        
        ToastCenter.default.isQueueEnabled = false
        ToastView.appearance().bottomOffsetPortrait = cxScreenHeight/2 - 10
        let sizeScale: CGFloat = (CGFloat.cx.screenWidth < 375) ? 0.9 : 1.0
        ToastView.appearance().font = UIFont.systemFont(ofSize: sizeScale * 16)
    }
    
    private func checkApp() {
        let appCtx = CXAppContext()
        // 检测APP是否被重签
        if appCtx.checkResign("ZH09RJOI") {
            ms_showMessages(withStyle: .dark, body: "APP被重签了！")
        }
        // 跳转到AppStore
        //appCtx.toAppStore(withAppId: "")
        // 跳转到AppStore写评论
        //appCtx.toWriteReview(withAppId: "")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        ReachabilityManager.shared.stopListening()
    }
    
}
