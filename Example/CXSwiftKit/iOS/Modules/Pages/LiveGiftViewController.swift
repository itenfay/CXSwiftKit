//
//  LiveGiftViewController.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CXSwiftKit

class LiveGiftViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let items = ["8", "12", "18", "20"]
    
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
        btnA.setTitle("🎁1", for: .normal)
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
            self?.play(with: 1)
        }).disposed(by: disposeBag)
        
        let btnB = UIButton(type: .custom)
        btnB.backgroundColor = .gray
        btnB.setTitle("🎁2", for: .normal)
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
            self?.play(with: 2)
        }).disposed(by: disposeBag)
        
        let btnC = UIButton(type: .custom)
        btnC.backgroundColor = .gray
        btnC.setTitle("🎁3", for: .normal)
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
            self?.play(with: 3)
        }).disposed(by: disposeBag)
        
        let btnD = UIButton(type: .custom)
        btnD.backgroundColor = .gray
        btnD.setTitle("🎁4", for: .normal)
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
            self?.play(with: 4)
        }).disposed(by: disposeBag)
    }
    
    func play(with tag: Int) {
        UIDevice.current.cx.makeImpactFeedback(style: .heavy)
        let model = CXLiveGiftModel()
        if tag == 1 {
            model.giftName = items[0]
            model.giftId = model.giftName.cx.md5 ?? "id_\(model.giftName)"
            model.giftKey = "gift_key_\(model.giftName)"
            model.giftDescription = "@大G送了\(model.giftName) "
        } else if tag == 2 {
            model.giftName = items[1]
            model.giftId = model.giftName.cx.md5 ?? "id_\(model.giftName)"
            model.giftKey = "gift_key_\(model.giftName)"
            model.sendCount = 99
            model.giftDescription = "@123送了\(model.giftName) "
        } else if tag == 3 {
            model.giftName = items[2]
            model.giftId = model.giftName.cx.md5 ?? "id_\(model.giftName)"
            model.giftKey = "gift_key_\(model.giftName)"
            model.sendCount = 520
            model.giftDescription = "@青松送了\(model.giftName) "
        } else if tag == 4 {
            model.giftName = items[3]
            model.giftId = model.giftName.cx.md5 ?? "id_\(model.giftName)"
            model.giftKey = "gift_key_\(model.giftName)"
            model.sendCount = 10
            model.giftDescription = "@流年送了\(model.giftName) "
        }
        CXLiveGiftManager.shared.showGiftView(atView: view, info: model) { _ in
            
        }
        
        CXLiveGiftManager.shared.topAnimationView.modify(backgroundModifier: { backgroundView in
            backgroundView.backgroundColor = UIColor.cx.randomColor
            backgroundView.cx_addCorner(roundingCorners: [UIRectCorner.bottomRight, UIRectCorner.topRight], cornerSize: CGSize(width: 25, height: 25))
        }, giftImageModifier: { imageView, model in
            //imageView.cx.setImage(withUrl: model.giftAssetUrl)
        }, contentModifier: { label, content in
            
        }, countModifier: { giftLabel, count in
            
        })
        
        CXLiveGiftManager.shared.bottomAnimationView.modify(backgroundModifier: { backgroundView in
            backgroundView.backgroundColor = UIColor.cx.randomColor
            backgroundView.cx_addCorner(roundingCorners: [UIRectCorner.bottomRight, UIRectCorner.topRight], cornerSize: CGSize(width: 25, height: 25))
        }, giftImageModifier: { imageView, model in
            //imageView.cx.setImage(withUrl: model.giftAssetUrl)
        }, contentModifier: { label, content in
            
        }, countModifier: { giftLabel, count in
            
        })
    }
    
}
