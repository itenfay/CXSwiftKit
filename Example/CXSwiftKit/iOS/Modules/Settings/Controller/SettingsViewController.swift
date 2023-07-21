//
//  SettingsViewController.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit

class SettingsViewController: BaseViewController, SettingsViewable {
    
    private var settingsView: SettingsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "设置"
    }
    
    override func configure() {
        let configurator = SettingsConfigurator()
        configurator.configure(controller: self)
        self.configurator = configurator
    }
    
    private func getSettingsPresenter() -> SettingsPresenter? {
        return presenter as? SettingsPresenter
    }
    
    override func makeUI() {
        settingsView = SettingsView(frame: CGRect.init(x: 0,
                                                       y: cxNavBarH,
                                                       width: view.cx.width,
                                                       height: view.cx.height - cxNavBarH - cxTabBarH))
        view.addSubview(settingsView)
        
        settingsView.clearButtonAction = { [weak self] in
            self?.getSettingsPresenter()?.clearButtonPressed()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
