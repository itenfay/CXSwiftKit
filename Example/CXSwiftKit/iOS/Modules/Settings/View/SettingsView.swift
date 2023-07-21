//
//  SettingsView.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit

protocol SettingsViewable: AnyObject {
    
}

class SettingsView: BaseView {
    
    var clearButtonAction: (() -> Void)?
    
    override func setup() {
        buildView()
    }
    
    func buildView() {
        let paddingX: CGFloat = 30
        let paddingY: CGFloat = 50
        
        let clearButton = UIButton(type: .custom)
        clearButton.frame = CGRect(x: paddingX, y: paddingY, width: cxScreenWidth - 2*paddingX, height: 50)
        clearButton.backgroundColor = .gray
        clearButton.setTitle("清除缓存", for: .normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        clearButton.addTarget(self, action: #selector(clearButtonOnClick), for: .touchUpInside)
        clearButton.layer.cornerRadius = 10
        addSubview(clearButton)
    }
    
    @objc func clearButtonOnClick() {
        clearButtonAction?()
    }
    
}
