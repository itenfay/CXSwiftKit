//
//  CustomOverlayViewController.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CXSwiftKit

class CustomOverlayViewController: BaseViewController {
    
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
        let btnW = (cxScreenWidth - 5*paddingX) / 4
        let btnH: CGFloat = 40
        
        let btnA = UIButton(type: .custom)
        btnA.backgroundColor = .gray
        btnA.setTitle("FromTop", for: .normal)
        btnA.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnA.layer.cornerRadius = 10
        btnA.showsTouchWhenHighlighted = true
        view.addSubview(btnA)
        btnA.cx.makeConstraints { maker in
            maker.top.equalToAnchor(self.view.cx.safeTopAnchor).offset(paddingY)
            maker.leading.equalTo(paddingX)
            maker.width.equalTo(btnW)
            maker.height.equalTo(btnH)
        }
        btnA.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.onClick(with: 1)
        }).disposed(by: disposeBag)
        
        let btnB = UIButton(type: .custom)
        btnB.backgroundColor = .gray
        btnB.setTitle("FromBottom", for: .normal)
        btnB.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnB.layer.cornerRadius = 10
        btnB.showsTouchWhenHighlighted = true
        view.addSubview(btnB)
        btnB.cx.makeConstraints { maker in
            maker.top.equalToAnchor(btnA.topAnchor).offset(0)
            maker.leading.equalToAnchor(btnA.trailingAnchor).offset(paddingX)
            maker.width.equalToDimension(btnA.widthAnchor)
            maker.height.equalToDimension(btnA.heightAnchor)
        }
        btnB.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.onClick(with: 2)
        }).disposed(by: disposeBag)
        
        let btnC = UIButton(type: .custom)
        btnC.backgroundColor = .gray
        btnC.setTitle("FromLeft", for: .normal)
        btnC.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnC.layer.cornerRadius = 10
        btnC.showsTouchWhenHighlighted = true
        view.addSubview(btnC)
        btnC.cx.makeConstraints { maker in
            maker.top.equalToAnchor(btnB.topAnchor)
            maker.leading.equalToAnchor(btnB.trailingAnchor).offset(paddingX)
            maker.width.equalToDimension(btnB.widthAnchor).offset(0)
            maker.height.equalToDimension(btnB.heightAnchor).offset(0)
        }
        btnC.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.onClick(with: 3)
        }).disposed(by: disposeBag)
        
        let btnD = UIButton(type: .custom)
        btnD.backgroundColor = .gray
        btnD.setTitle("FromRight", for: .normal)
        btnD.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnD.layer.cornerRadius = 10
        btnD.showsTouchWhenHighlighted = true
        view.addSubview(btnD)
        btnD.cx.makeConstraints { maker in
            maker.top.equalToAnchor(btnC.topAnchor)
            maker.leading.equalToAnchor(btnC.trailingAnchor).offset(paddingX)
            maker.width.equalTo(btnW)
            maker.height.equalTo(btnH)
        }
        btnD.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.onClick(with: 4)
        }).disposed(by: disposeBag)
    }
    
    func onClick(with tag: Int) {
        UIDevice.current.cx.makeImpactFeedback(style: .heavy)
        emptyDataVC = EmptyDataViewController()
        emptyDataVC.view.frame = CGRect(x: 0, y: 0, width: cxScreenWidth, height: cxScreenHeight)
        emptyDataVC.customOverlay = true
        emptyDataVC.onOverlayDismiss = { [weak self] in
            self?.makeNavigationBarHidden(false)
            self?.emptyDataVC = nil
        }
        var overlayRatio = 0.8
        var overlayDirection: CXOverlayDirection = .bottom
        if tag == 1 {
            overlayRatio = 0.6
            overlayDirection = .top
        } else if tag == 2 {
            overlayRatio = 0.7
            overlayDirection = .bottom
        } else if tag == 3 {
            overlayRatio = 0.5
            overlayDirection = .left
        } else if tag == 4 {
            overlayRatio = 0.6
            overlayDirection = .right
        }
        makeNavigationBarHidden(true)
        let r = arc4random_uniform(2)
        if r == 0 {
            emptyDataVC.useViewPresented = true
            self.view.cx.present(emptyDataVC.view, overlayRatio: overlayRatio, overlayDirection: overlayDirection) {
                CXLogger.log(level: .info, message: "present")
            }
        } else {
            emptyDataVC.useViewPresented = false
            self.cx.present(emptyDataVC, overlayRatio: overlayRatio, overlayDirection: overlayDirection) {
                CXLogger.log(level: .info, message: "present")
            }
        }
    }
    
}
