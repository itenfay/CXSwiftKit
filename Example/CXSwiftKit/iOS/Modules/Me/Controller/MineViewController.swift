//
//  MineViewController.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit

class MineViewController: BaseViewController, MineViewable {
    
    private var mineView: MineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "我的"
    }
    
    override func configure() {
        let configurator = MineConfigurator()
        configurator.configure(controller: self)
        self.configurator = configurator
    }
    
    override func makeUI() {
        mineView = MineView(frame: CGRect.init(x: 0,
                                               y: cxNavBarH,
                                               width: view.cx.width,
                                               height: view.cx.height - cxNavBarH - cxTabBarH))
        view.addSubview(mineView)
        
        mineView.settingsButtonOnClick = { [weak self] sender in
            let pt = self?.presenter as? MinePresenter
            pt?.settingsButtonPressed()
        }
    }
    
}
