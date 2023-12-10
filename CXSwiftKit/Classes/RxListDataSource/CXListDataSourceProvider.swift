//
//  CXListDataSourceProvider.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#if canImport(RxSwift) && canImport(RxCocoa) && canImport(RxDataSources)
import RxCocoa
import RxSwift
import RxDataSources

public protocol CXCollectionViewDataSourceProvidable {
    associatedtype S: CXSectionEntity
    associatedtype T: CXCellEntity
    
    func provideDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<S, T>>
    func provideAnimatedDataSource() -> RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>>
    func configureCell(cv collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath, item: T)
}

extension CXCollectionViewDataSourceProvidable where Self : UIViewController {
    
    /// Provides dataSource for collection view.
    public func provideDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<S, T>> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<S, T>>(configureCell: { [weak self] (_, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
            self?.configureCell(cv: collectionView, cell: cell, indexPath: indexPath, item: item)
            return cell
        })
        
        dataSource.configureSupplementaryView = { (section, collectionView, kind, indexPath) in
            let sectionEntity = section.sectionModels[indexPath.section].model
            var reuseableView: UICollectionReusableView?
            if kind == UICollectionView.elementKindSectionHeader, let headerEntity = sectionEntity.headerEntity {
                reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerEntity.reuseIdentifier, for: indexPath)
                (reuseableView as? CXCollectionReusableView)?.bind(to: headerEntity)
            } else if kind == UICollectionView.elementKindSectionFooter, let footerEntity = sectionEntity.footerEntity {
                reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerEntity.reuseIdentifier, for: indexPath)
                (reuseableView as? CXCollectionReusableView)?.bind(to: footerEntity)
            }
            if reuseableView == nil {
                reuseableView = UICollectionReusableView()
            }
            return reuseableView!
        }
        
        return dataSource
    }
    
    /// Provides animated dataSource for collection view.
    public func provideAnimatedDataSource() -> RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>> {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>>(configureCell: { [weak self] (_, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
            self?.configureCell(cv: collectionView, cell: cell, indexPath: indexPath, item: item)
            return cell
        })
        
        dataSource.configureSupplementaryView = { (section, collectionView, kind, indexPath) in
            let sectionEntity = section.sectionModels[indexPath.section].model
            var reuseableView: UICollectionReusableView?
            if kind == UICollectionView.elementKindSectionHeader, let headerEntity = sectionEntity.headerEntity {
                reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerEntity.reuseIdentifier, for: indexPath)
                (reuseableView as? CXCollectionReusableView)?.bind(to: headerEntity)
            } else if kind == UICollectionView.elementKindSectionFooter, let footerEntity = sectionEntity.footerEntity {
                reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerEntity.reuseIdentifier, for: indexPath)
                (reuseableView as? CXCollectionReusableView)?.bind(to: footerEntity)
            }
            if reuseableView == nil {
                reuseableView = UICollectionReusableView()
            }
            return reuseableView!
        }
        
        return dataSource
    }
    
    public func configureCell(cv collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath, item: T) {}
    
}

public protocol CXTableViewDataSourceProvidable {
    associatedtype S: CXSectionEntity
    associatedtype T: CXCellEntity
    
    func provideDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<S, T>>
    func provideAnimatedDataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>>
    
    func makeListProvider(transform: @escaping () -> Observable<[SectionModel<S, T>]>) -> Observable<[SectionModel<S, T>]>
    func makeAnimatedListProvider(transform: @escaping () -> Observable<[AnimatableSectionModel<S, T>]>) -> Observable<[AnimatableSectionModel<S, T>]>
    
    func configureCell(tv tableView: UITableView, indexPath: IndexPath, item: T) -> UITableViewCell
}

extension CXTableViewDataSourceProvidable where Self : UIViewController {
    
    /// Provides dataSource for table view.
    public func provideDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<S, T>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<S, T>>(configureCell: { [weak self] (_, tableView, indexPath, item) in
            return self?.configureCell(tv: tableView, indexPath: indexPath, item: item) ?? UITableViewCell()
        })
        return dataSource
    }
    
    /// Provides animated dataSource for table view.
    public func provideAnimatedDataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<S, T>>(configureCell: { [weak self] (_, tableView, indexPath, item) in
            return self?.configureCell(tv: tableView, indexPath: indexPath, item: item) ?? UITableViewCell()
        })
        return dataSource
    }
    
    public func makeListProvider(transform: @escaping () -> Observable<[SectionModel<S, T>]>) -> Observable<[SectionModel<S, T>]> {
        return transform()
    }
    
    public func makeAnimatedListProvider(transform: @escaping () -> Observable<[AnimatableSectionModel<S, T>]>) -> Observable<[AnimatableSectionModel<S, T>]> {
        return transform()
    }
    
    public func configureCell(tv tableView: UITableView, indexPath: IndexPath, item: T) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
}

#endif
#endif
