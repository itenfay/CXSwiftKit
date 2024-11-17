//
//  MineView.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit

protocol MineViewable: AnyObject {
    
}

class MineView: BaseView {
    var settingsButtonOnClick: ((UIButton) -> Void)?
    
    override func setup() {
        buildView()
    }
    
    func buildView() {
        let paddingX: CGFloat = 30
        let paddingY: CGFloat = 50
        
        let settingsButton = UIButton(type: .custom)
        settingsButton.frame = CGRect(x: paddingX, y: paddingY, width: cxScreenWidth - 2*paddingX, height: 50)
        settingsButton.backgroundColor = .gray
        settingsButton.setTitle("设置", for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        settingsButton.addTarget(self, action: #selector(onSettingsBtnClick(_:)), for: .touchUpInside)
        settingsButton.layer.cornerRadius = 10
        addSubview(settingsButton)
    }
    
    @objc func onSettingsBtnClick(_ sender: UIButton) {
        settingsButtonOnClick?(sender)
    }
    
}
