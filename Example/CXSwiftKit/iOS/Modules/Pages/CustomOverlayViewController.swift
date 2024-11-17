//
//  CustomOverlayViewController.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/7.
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
        let btnW = (cxScreenWidth - 4*paddingX) / 3
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
            maker.top.equalToAnchor(btnA.bottomAnchor).offset(paddingY)
            maker.leading.equalToAnchor(btnA.leadingAnchor)
            maker.width.equalTo(btnW)
            maker.height.equalTo(btnH)
        }
        btnD.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.onClick(with: 4)
        }).disposed(by: disposeBag)
        
        let btnE = UIButton(type: .custom)
        btnE.backgroundColor = .gray
        btnE.setTitle("FromCenter", for: .normal)
        btnE.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnE.layer.cornerRadius = 10
        btnE.showsTouchWhenHighlighted = true
        view.addSubview(btnE)
        btnE.cx.makeConstraints { maker in
            maker.top.equalToAnchor(btnD.topAnchor)
            maker.leading.equalToAnchor(btnD.trailingAnchor).offset(paddingX)
            maker.width.equalTo(btnW)
            maker.height.equalTo(btnH)
        }
        btnE.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.onClick(with: 5)
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
        var fromCenter: Bool = false
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
        } else if tag == 5 {
            fromCenter = true
        }
        
        let r = arc4random_uniform(3)
        if r == 0 || r == 1 {
            if r == 0 {
                makeNavigationBarHidden(true)
            }
            emptyDataVC.useViewPresented = true
            if fromCenter {
                emptyDataVC.isPresentedFromCenter = true
                emptyDataVC.view.cx.width = CGFloat.cx_screenWidth - 60
                emptyDataVC.view.cx_height = 400
                emptyDataVC.view.cx.cornerRadius = 10
                if r == 0 {
                    self.view.cx.presentFromCenter(emptyDataVC.view) {
                        CXLogger.log(level: .info, message: "[V] present from center")
                    } dismiss: { [weak self] in
                        self?.makeNavigationBarHidden(false)
                        self?.emptyDataVC = nil
                    }
                } else {
                    UIApplication.shared.cx_keyWindow?.cx.presentFromCenter(emptyDataVC.view) {
                        CXLogger.log(level: .info, message: "[Window] present from center");
                    } dismiss: { [weak self] in
                        self?.emptyDataVC = nil
                    }
                }
                fromCenter = false
                return
            }
            emptyDataVC.isPresentedFromCenter = false
            if r == 0 {
                self.view.cx.present(emptyDataVC.view, overlayRatio: overlayRatio, overlayDirection: overlayDirection) {
                    CXLogger.log(level: .info, message: "[V] present")
                } dismiss: { [weak self] in
                    self?.emptyDataVC = nil
                }
            } else {
                UIApplication.shared.cx.keyWindow?.cx.present(emptyDataVC.view, overlayRatio: overlayRatio, overlayDirection: overlayDirection) {
                    CXLogger.log(level: .info, message: "[Window] present");
                } dismiss: { [weak self] in
                    self?.emptyDataVC = nil
                }
            }
        } else {
            makeNavigationBarHidden(true)
            emptyDataVC.useViewPresented = false
            if fromCenter {
                emptyDataVC.isPresentedFromCenter = true
                emptyDataVC.view.cx.width = CGFloat.cx_screenWidth - 50
                emptyDataVC.view.cx_height = 500
                emptyDataVC.view.cx.cornerRadius = 10
                self.cx.presentFromCenter(emptyDataVC) {
                    CXLogger.log(level: .info, message: "[VC] present from center")
                } dismiss: { [weak self] in
                    self?.makeNavigationBarHidden(false)
                    self?.emptyDataVC = nil
                }
                fromCenter = false
                return
            }
            emptyDataVC.isPresentedFromCenter = false
            self.cx.present(emptyDataVC, overlayRatio: overlayRatio, overlayDirection: overlayDirection) {
                CXLogger.log(level: .info, message: "[VC] present")
            } dismiss: { [weak self] in
                self?.makeNavigationBarHidden(false)
                self?.emptyDataVC = nil
            }
        }
    }
    
}
