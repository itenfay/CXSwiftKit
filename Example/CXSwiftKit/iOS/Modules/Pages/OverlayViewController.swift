//
//  OverlayViewController.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CXSwiftKit
import MarsUIKit

class OverlayViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private var emptyDataVC: EmptyDataViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        
    }
    
    override func makeUI() {
        let paddingX: CGFloat = 15
        let paddingY: CGFloat = 10
        let btnH: CGFloat = 40
        
        let btnA = UIButton(type: .custom)
        btnA.backgroundColor = .gray
        btnA.setTitle("Present Overlay View", for: .normal)
        btnA.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnA.layer.cornerRadius = 10
        btnA.showsTouchWhenHighlighted = true
        view.addSubview(btnA)
        btnA.cx.makeConstraints { maker in
            maker.top.equalToAnchor(self.view.cx.safeTopAnchor).offset(paddingY)
            maker.leading.equalTo(paddingX)
            maker.trailing.equalTo(-paddingX)
            maker.height.equalTo(btnH)
        }
        
        btnA.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.present()
        }).disposed(by: disposeBag)
    }
    
    private func present() {
        emptyDataVC = EmptyDataViewController()
        emptyDataVC.view.frame = CGRect(x: 0, y: 0, width: cxScreenWidth, height: cxScreenHeight/1.5)
        emptyDataVC.ovcPresented = true
        view.ms.ovcPresent(emptyDataVC.view) { [weak self] in
            self?.emptyDataVC = nil
        }
    }
    
}
