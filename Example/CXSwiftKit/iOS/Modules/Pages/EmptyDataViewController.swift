//
//  EmptyDataViewController.swift
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

class EmptyDataViewController: BaseViewController {
    
    private var tableView: UITableView!
    
    private lazy var eds: MarsEmptyDataSetDecorator = MarsEmptyDataSetDecorator()
    private let subject = BehaviorSubject<MarsEmptyDataSetType>(value: .emptyData(desc: ""))
    private let disposeBag = DisposeBag()
    private var dataArray: [String] = []
    
    let scalePresentAnimation = CXScalePresentAnimation()
    let scaleDismissAnimation = CXScaleDismissAnimation()
    let swipeLeftInteractiveTransition = CXSwipeLeftInteractiveTransition()
    
    var ovcPresented: Bool = false
    var customOverlay: Bool = false
    var useViewPresented: Bool = false
    var onOverlayDismiss: (() -> Void)?
    var isPresentedFromCenter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        //DispatchQueue.ms.mainAsyncAfter(0.5) {
        //self.bindAction()
        //}
    }
    
    override func configure() {
        eds.style.image = cxLoadImage(named: "img_emptydata")
        eds.style.loadingAnimatedImage = cxLoadImage(named: "loading_imgBlue_40x40")
        eds.onReload = { [weak self] in
            CXLog.info("空数据刷新了")
            self?.ms_makeToast(text: "空数据刷新了")
        }
        subject.bind(to: eds.rx.ms_empty).disposed(by: disposeBag)
    }
    
    override func makeUI() {
        if navigationController == nil {
            let closeBtn = UIButton(type: .custom)
            closeBtn.setTitle("关闭", for: .normal)
            closeBtn.setTitleColor(UIColor.cx.color(withHexString: "0x333333"), for: .normal)
            closeBtn.setTitleColor(UIColor.cx.color(withHexString: "0x999999"), for: .highlighted)
            closeBtn.titleLabel?.font = UIFont.cx.semiboldPingFang(ofSize: 16)
            view.cx.add(subviews: closeBtn)
            closeBtn.cx.makeConstraints { [self] maker in
                maker.top.equalToAnchor(view.cx.safeTopAnchor).offset(10)
                maker.leading.equalToAnchor(view.leadingAnchor).offset(15)
                maker.width.equalTo(40)
                maker.height.equalTo(40)
            }
            closeBtn.rx.tap.asDriver().drive(onNext: { [weak self] in
                self?.dismissController()
            }).disposed(by: disposeBag)
        }
        
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.cx.makeConstraints { maker in
            maker.top.equalTo(cxNavBarH)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-cxSafeAreaBottom)
        }
        
        eds.bindTarget(tableView)
    }
    
    func loadData() {
        ms_showProgressHUD(withStatus: "正在加载数据...")
        cxDelayToDispatch(0.3) {
            self.ms_dismissProgressHUD()
            self.subject.onNext(.emptyData(desc: ""))
        }
    }
    
    private func bindAction() {
        let vcTap = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
        self.cx_overlayMaskView?.addGestureRecognizer(vcTap)
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
        self.view.cx_overlayMaskView?.addGestureRecognizer(viewTap)
    }
    
    @objc func onTapAction() {
        dismissController()
    }
    
    private func dismissController() {
        if ovcPresented {
            view.ms.ovcDismiss()
        } else if customOverlay && !isPresentedFromCenter {
            useViewPresented 
            ? view.cx.dismiss()
            : self.cx.dismiss()
            //onOverlayDismiss?()
        } else if customOverlay && isPresentedFromCenter {
            useViewPresented 
            ? view.cx.dismissFromCenter()
            : self.cx.dismissFromCenter()
            //onOverlayDismiss?()
        } else {
            self.dismiss(animated: true)
        }
    }
    
    deinit {
        CXLogger.log(level: .info, message: "deinit")
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension EmptyDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "EmptyDataCell")
        if cell == nil {
            cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: "EmptyDataCell")
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension EmptyDataViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return scalePresentAnimation
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        scaleDismissAnimation.updateFinalRect(scalePresentAnimation.touchRect)
        return scaleDismissAnimation
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeLeftInteractiveTransition.interacting ? swipeLeftInteractiveTransition : nil
    }
    
}
