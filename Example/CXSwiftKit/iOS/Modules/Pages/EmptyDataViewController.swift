//
//  EmptyDataViewController.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit
import RxSwift
import RxCocoa

class EmptyDataViewController: BaseViewController {
    
    private var tableView: UITableView!
    
    private lazy var eds: CXEmptyDataSetMediator = CXEmptyDataSetMediator()
    private let subject = BehaviorSubject<CXEmptyDataSetType>(value: .emptyData(desc: ""))
    private let disposeBag = DisposeBag()
    private var dataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "空数据设置"
        loadData()
    }
    
    override func configure() {
        eds.style.image = cxLoadImage(named: "img_emptydata")
        eds.style.loadingAnimatedImage = cxLoadImage(named: "loading_imgBlue_40x40")
        eds.onReload = { [weak self] in
            CXLog.info("空数据刷新了")
            self?.cx_makeToast(text: "空数据刷新了")
        }
        subject.bind(to: eds.rx.cx_empty).disposed(by: disposeBag)
    }
    
    override func makeUI() {
        tableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: cxNavBarH),
                                              size: CGSize(width: view.cx.width, height: view.cx.height - cxNavBarH - cxSafeAreaBottom)))
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        
        eds.bindTarget(tableView)
    }
    
    func loadData() {
        cx_showProgressHUD(withStatus: "正在加载数据...")
        cxDelayToDispatch(1.0) {
            self.cx_dismissProgressHUD()
            self.subject.onNext(.emptyData(desc: ""))
        }
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
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "EmptyDataCell")
        }
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
