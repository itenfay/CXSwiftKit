//
//  DocumentPickerController.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import CXSwiftKit
import MarsUIKit
import RxListDataSource

class DocumentPickerController: BaseViewController, CXTableViewDataSourceProvidable {
    typealias S = ListSectionEntity
    typealias T = DocumentModel
    
    private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var documentPicker: CXDocumentPicker!
    private var items = BehaviorRelay<[AnimatableSectionModel<ListSectionEntity, DocumentModel>]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configure() {
        documentPicker = CXDocumentPicker(controller: self, delegate: self)
        documentPicker.actionSheetTitle = "选择"
        documentPicker.actionSheetFileTitle = "文件"
        documentPicker.actionSheetFolderTitle = "文件夹"
        documentPicker.actionSheetCancelTitle = "取消"
        documentPicker.fullScreenEnabled = true
    }
    
    override func makeUI() {
        let paddingX: CGFloat = 15
        let paddingY: CGFloat = 10
        let btnH: CGFloat = 40
        
        let btnA = UIButton(type: .custom)
        btnA.backgroundColor = .gray
        btnA.setTitle("Open Document Picker", for: .normal)
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
            self?.documentPicker.present()
        }).disposed(by: disposeBag)
        
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = UIColor.cx.color(withHexString: "0x333333", alpha: 0.5)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.cx.cornerRadius = 10
        tableView.cx.masksToBounds = true
        view.addSubview(tableView)
        tableView.cx.makeConstraints { maker in
            maker.top.equalToAnchor(btnA.bottomAnchor).offset(10)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-cxSafeAreaBottom)
        }
    }
    
    private func bind() {
        items.bind(to: tableView.rx.items(dataSource: provideAnimatedDataSource())).disposed(by: disposeBag)
        tableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            self?.itemDidSelect(at: indexPath)
        }).disposed(by: disposeBag)
    }
    
    func configureCell(tv tableView: UITableView, indexPath: IndexPath, item: DocumentModel) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DocumentPickerCell")
        if cell == nil {
            cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: "DocumentPickerCell")
        }
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator
        
        cell?.textLabel?.text = CXFileToolbox.fileName(withURL: item.fileURL)
        cell?.textLabel?.font = UIFont.cx.semiboldPingFang(ofSize: 16)
        cell?.textLabel?.textColor = UIColor.cx.color(withHexString: "0x333333")
        
        cell?.detailTextLabel?.text = item.fileURL.absoluteString
        cell?.detailTextLabel?.font = UIFont.cx.regularPingFang(ofSize: 15)
        cell?.detailTextLabel?.textColor = UIColor.cx.color(withHexString: "0x666666")
        
        return cell!
    }
    
    func itemDidSelect(at indexPath: IndexPath) {
        CXLog.info("row-\(indexPath.row): did click!")
    }
    
}

extension DocumentPickerController: CXDocumentDelegate {
    
    func cxDidPickDocuments(_ documents: [CXDocument]?) {
        guard let docs = documents else {
            return
        }
        let models = docs.map { DocumentModel(fileURL: $0.fileURL, name: $0.localizedName) }
        let sectionModel = ListSectionEntity()
        //let list = makeAnimatedListProvider {
        //    Observable.just([AnimatableSectionModel(model: sectionModel, items: models)])
        //}
        //list.bind(to: tableView.rx.items(dataSource: makeAnimatedDataSource())).disposed(by: disposeBag)
        items.accept([AnimatableSectionModel(model: sectionModel, items: models)])
    }
    
}
