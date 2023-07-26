//
//  CXSKListViewController.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CXSKCollectionViewController<S, T>: BaseViewController where S : BaseSectionModel, T : BaseCellModel {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Make dataSource for collection view.
    func makeDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<S, T>> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<S, T>>(configureCell: { [weak self] (_, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
            self?.configureCell(cv: collectionView, cell: cell, indexPath: indexPath, item: item)
            return cell
        })
        
        dataSource.configureSupplementaryView = { (section, collectionView, kind, indexPath) in
            let sectionModel = section.sectionModels[indexPath.section].model
            var reuseableView: UICollectionReusableView?
            if kind == UICollectionView.elementKindSectionHeader, let headerModel = sectionModel.headerModel {
                reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerModel.reuseIdentifier, for: indexPath)
                (reuseableView as? BaseReusableView)?.bind(to: headerModel)
            } else if kind == UICollectionView.elementKindSectionFooter, let footerModel = sectionModel.footerModel {
                reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerModel.reuseIdentifier, for: indexPath)
                (reuseableView as? BaseReusableView)?.bind(to: footerModel)
            }
            if reuseableView == nil {
                reuseableView = UICollectionReusableView()
            }
            return reuseableView!
        }
        
        return dataSource
    }
    
    /// Make animated dataSource for collection view.
    func makeAnimatedDataSource() -> RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>> {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>>(configureCell: { [weak self] (_, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
            self?.configureCell(cv: collectionView, cell: cell, indexPath: indexPath, item: item)
            return cell
        })
        
        dataSource.configureSupplementaryView = { (section, collectionView, kind, indexPath) in
            let sectionModel = section.sectionModels[indexPath.section].model
            var reuseableView: UICollectionReusableView?
            if kind == UICollectionView.elementKindSectionHeader, let headerModel = sectionModel.headerModel {
                reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerModel.reuseIdentifier, for: indexPath)
                (reuseableView as? BaseReusableView)?.bind(to: headerModel)
            } else if kind == UICollectionView.elementKindSectionFooter, let footerModel = sectionModel.footerModel {
                reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerModel.reuseIdentifier, for: indexPath)
                (reuseableView as? BaseReusableView)?.bind(to: footerModel)
            }
            if reuseableView == nil {
                reuseableView = UICollectionReusableView()
            }
            return reuseableView!
        }
        
        return dataSource
    }
    
    func configureCell(cv collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath, item: T) {
        
    }
    
}

class CXSKTableViewController<S, T>: BaseViewController where S : BaseSectionModel, T : BaseCellModel {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Make dataSource for table view.
    func makeDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<S, T>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<S, T>>(configureCell: { [weak self] (_, tableView, indexPath, item) in
            return self?.configureCell(tv: tableView, indexPath: indexPath, item: item) ?? UITableViewCell()
        })
        return dataSource
    }
    
    /// Make animated dataSource for table view.
    func makeAnimatedDataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>>(configureCell: { [weak self] (_, tableView, indexPath, item) in
            return self?.configureCell(tv: tableView, indexPath: indexPath, item: item) ?? UITableViewCell()
        })
        return dataSource
    }
    
    func makeListProvider(transform: @escaping () -> Observable<[SectionModel<S, T>]>) -> Observable<[SectionModel<S, T>]> {
        return transform()
    }
    
    func makeAnimatedListProvider(transform: @escaping () -> Observable<[AnimatableSectionModel<S, T>]>) -> Observable<[AnimatableSectionModel<S, T>]> {
        return transform()
    }
    
    func configureCell(tv tableView: UITableView, indexPath: IndexPath, item: T) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
}
