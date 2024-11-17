//
//  MinePresenter.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

protocol IMinePresenter: AnyObject {
    func settingsButtonPressed()
}

class MinePresenter: BasePresenter, IMinePresenter {
    
    private unowned let view: MineViewable
    private let apiClient: ApiClient
    
    init(view: MineViewable, apiClient: ApiClient) {
        self.view = view
        self.apiClient = apiClient
    }
    
    func settingsButtonPressed() {
        gotoSettingsScene()
    }
    
    func gotoSettingsScene() {
        guard let mineVC = view as? MineViewController else {
            return
        }
        let settingsVC = SettingsViewController()
        settingsVC.hidesBottomBarWhenPushed = true
        mineVC.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
}
