//
//  SvgaViewController.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CXSwiftKit
import MarsUIKit
import SVGAPlayer

class SvgaViewController: BaseViewController {
    
    private var svgaPlayer: SVGAPlayer!
    private let disposeBag = DisposeBag()
    private var firstOps: [MarsSVGAPlayOperation] = []
    private var firstPercentages: [String : CGFloat] = [:]
    private var lastOp: MarsSVGAPlayOperation!
    
    private let items = [
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/EmptyState.svga?raw=true",
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/HamburgerArrow.svga?raw=true",
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/PinJump.svga?raw=true",
        "https://github.com/svga/SVGA-Samples/raw/master/Rocket.svga",
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/TwitterHeart.svga?raw=true",
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/Walkthrough.svga?raw=true",
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/angel.svga?raw=true",
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/halloween.svga?raw=true",
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/kingset.svga?raw=true",
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/posche.svga?raw=true",
        "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/rose.svga?raw=true",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSvgaPlayer()
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
        btnA.setTitle("火箭", for: .normal)
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
        btnB.setTitle("心跳", for: .normal)
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
        btnC.setTitle("Rose", for: .normal)
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
        btnD.setTitle("随机", for: .normal)
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
        
        let btnE = UIButton(type: .custom)
        btnE.backgroundColor = .gray
        btnE.setTitle("优先显示", for: .normal)
        btnE.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnE.layer.cornerRadius = 10
        btnE.showsTouchWhenHighlighted = true
        view.addSubview(btnE)
        btnE.cx.makeConstraints { maker in
            maker.top.equalToAnchor(btnA.bottomAnchor).offset(paddingY)
            maker.leading.equalToAnchor(btnA.leadingAnchor)
            maker.width.equalTo(btnW)
            maker.height.equalTo(btnH)
        }
        btnE.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.play(with: 5)
        }).disposed(by: disposeBag)
        
        svgaPlayer = SVGAPlayer()
        svgaPlayer.contentMode = .bottom
        view.addSubview(svgaPlayer)
        svgaPlayer.cx.makeConstraints { make in
            make.top.equalToAnchor(btnD.bottomAnchor).offset(2*paddingY)
            make.leading.equalTo(paddingX)
            make.trailing.equalTo(-paddingX)
            make.bottom.equalTo(-cxSafeAreaBottom)
        }
    }
    
    private func bindSvgaPlayer() {
        MarsSVGAPlayManager.shared.svgaPlayer = svgaPlayer
    }
    
    func play(with tag: Int) {
        // 震动反馈调用
        UIDevice.current.cx.makeImpactFeedback(style: .heavy)
        //UIDevice.current.cx.makeSelectionFeedback()
        //UIDevice.current.cx.makeNotificationFeedback(type: .success)
        
        let svgaPlayManager = MarsSVGAPlayManager.shared
        if tag == 1 {
            svgaPlayManager.play(named: "Rocket")
        } else if tag == 2 {
            svgaPlayManager.play(named: "heartbeat")
        } else if tag == 3 {
            svgaPlayManager.play(named: "rose_2.0.0")
        } else if tag == 4 {
            let i = Int(arc4random_uniform(UInt32(items.count)))
            let url = items[i < items.count ? i : 0]
            svgaPlayManager.play(url: url)
        } else if tag == 5 {
            CXHaptics.strongBoom()
            //CXHaptics.weakBoom()
            //CXHaptics.threeWeakBooms()
            // Extracts the specified operation.
            svgaPlayManager.play(url: "https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/posche.svga?raw=true")
            
            let ops = svgaPlayManager.operations
            ops.forEach { op in
                CXLog.info("op: \(op), \(String(describing: op.svgaUrl)) or \(String(describing: op.svgaName))")
            }
            
            // 获取最后一个任务和第一个任务，更改最后一个任务的优先级，让最后一个先执行。
            if let lastOp = ops.last, let firstOp = ops.first, lastOp !== firstOp {
                if !firstOps.contains(firstOp) {
                    firstOp.queuePriority = .normal
                    firstOps.append(firstOp)
                }
                self.lastOp = lastOp
                svgaPlayManager.onSvgaAnimatedToPercentageHandler = { percentage in
                    let manager = MarsSVGAPlayManager.shared
                    if let currOp = manager.currOp {
                        self.firstPercentages["\(currOp.hash)"] = percentage
                    }
                }
                svgaPlayManager.onFinishAnimationHandler = {
                    let manager = MarsSVGAPlayManager.shared
                    if let currOp = manager.currOp {
                        self.executeOperations()
                        self.firstPercentages.removeValue(forKey: "\(currOp.hash)")
                        if currOp === self.lastOp {
                            self.lastOp = nil
                        }
                    }
                }
                
                self.lastOp.queuePriority = .veryHigh
                //if ops.count > 2 {
                //    let secondOp = ops[1]
                //    // 添加依赖存在问题，在执行的任务没有任何效果
                //    secondOp.addDependency(lastOp)
                //}
                svgaPlayManager.finishAnimating()
            }
            
            // 取消所有任务
            //svgaPlayManager.opQueue.cancelAllOperations()
        }
    }
    
    private func executeOperations() {
        if self.firstOps.isEmpty { return }
        let manager = MarsSVGAPlayManager.shared
        let firstOp = self.firstOps.removeFirst()
        
        if let url = firstOp.svgaUrl {
            manager.play(url: url)
        } else if let name = firstOp.svgaName {
            manager.play(named: name, inBundle: firstOp.inBundle)
        }
        
        manager.operations.last?.queuePriority = .high
        let percentage = self.firstPercentages["\(firstOp.hash)"] ?? 0.0
        manager.step(toPercentage: percentage, andPlay: true)
    }
    
}
