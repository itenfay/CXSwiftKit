//
//  SettingsPresenter.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit
import MarsUIKit

protocol ISettingsPresenter: AnyObject {
    func clearButtonPressed()
}

class SettingsPresenter: BasePresenter, ISettingsPresenter {
    
    private unowned let view: SettingsViewable
    private let apiClient: ApiClient
    
    init(view: SettingsViewable, apiClient: ApiClient) {
        self.view = view
        self.apiClient = apiClient
    }
    
    func clearButtonPressed() {
        guard let vc = view as? SettingsViewController else { return }
        
        cxShowAlert(in: vc, title: "是否清空所有缓存？", message: nil, sureTitle: "确定", cancelTitle: "取消", sureHandler: { action in
            self.clearLocalCaches()
        }, cancelHandler: nil, warningHandler: nil)
    }
    
    private func clearLocalCaches() {
        ms_showProgressHUD(withStatus: "正在清理中")
        cxClearKingfisherCache {
            self.ms_dismissProgressHUD()
            self.ms_showMessages(withStyle: .dark, body: "清理完成")
        }
    }
    
}
