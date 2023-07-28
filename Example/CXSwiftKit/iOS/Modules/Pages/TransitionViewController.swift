//
//  TransitionViewController.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit
import RxSwift
import RxCocoa
import RxDataSources

class TransitionViewController: CXSKCollectionViewController<BaseSectionModel, BaseCellModel> {
    
    private var collectionView: UICollectionView!
    private var disposeBag = DisposeBag()
    
    private var dataList = BehaviorRelay<[SectionModel<BaseSectionModel, BaseCellModel>]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        loadData()
    }
    
    override func configure() {
        
    }
    
    override func makeUI() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        view.cx.add(subviews: collectionView)
        collectionView.cx.makeConstraints { [self] maker in
            maker.top.equalToAnchor(view.cx.safeTopAnchor).offset(10)
            maker.leading.equalToAnchor(view.leadingAnchor)
            maker.trailing.equalToAnchor(view.trailingAnchor)
            maker.bottom.equalToAnchor(view.cx.safeBottomAnchor).offset(0)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (cxScreenWidth - 30)/2, height: 100)
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(UINib(nibName: "TransitionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TransitionCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func loadData() {
        cx_showProgressHUD(withStatus: "正在加载数据...")
        cxDelayToDispatch(0.5) {
            self.fillInData()
            self.cx_dismissProgressHUD()
        }
    }
    
    private func fillInData() {
        var list: [SectionModel<BaseSectionModel, BaseCellModel>] = []
        let section = BaseSectionModel()
        var items: [BaseCellModel] = []
        for i in 0..<50 {
            CXLog.info("i=\(i)")
            let item = BaseCellModel()
            item.reuseIdentifier = "TransitionCollectionViewCell"
            items.append(item)
        }
        list.append(SectionModel(model: section, items: items))
        dataList.accept(list)
    }
    
    func bind() {
        dataList.bind(to: collectionView.rx.items(dataSource: makeDataSource())).disposed(by: disposeBag)
        collectionView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            self?.didSelectItem(at: indexPath)
        }).disposed(by: disposeBag)
    }
    
    override func configureCell(
        cv collectionView: UICollectionView,
        cell: UICollectionViewCell,
        indexPath: IndexPath,
        item: BaseCellModel)
    {
        if let transitionCell = cell as? TransitionCollectionViewCell {
            transitionCell.stackView.backgroundColor = UIColor.cx.randomColor
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let edViewController = EmptyDataViewController()
        edViewController.transitioningDelegate = edViewController
        edViewController.swipeLeftInteractiveTransition.wireTo(viewController: edViewController)
        edViewController.scalePresentAnimation.updateRect(with: collectionView, indexPath: indexPath, inView: view)
        edViewController.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .currentContext
        self.present(edViewController, animated: true, completion: nil)
    }
    
}
