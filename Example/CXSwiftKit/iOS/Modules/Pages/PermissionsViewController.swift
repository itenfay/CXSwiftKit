//
//  PermissionsViewController.swift
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
import RxListDataSource
import MarsUIKit

class PermissionsViewController: BaseViewController, CXTableViewDataSourceProvidable {
    typealias S = ListSectionEntity
    typealias T = PermissionModel
    
    private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    private var items = BehaviorRelay<[AnimatableSectionModel<ListSectionEntity, PermissionModel>]>(value: [])
    private var permissions: [CXPermission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        initData()
    }
    
    func initData() {
        let sectionModel = ListSectionEntity()
        var items = [PermissionModel]()
        
        let photosPermission = CXPhotosPermission()
        let photosModel = PermissionModel()
        photosModel.type.accept(.photos)
        photosModel.status.accept(photosPermission.status)
        items.append(photosModel)
        permissions.append(photosPermission)
        
        let cameraPermission = CXCameraPermission()
        let cameraModel = PermissionModel()
        cameraModel.type.accept(.camera)
        cameraModel.status.accept(cameraPermission.status)
        items.append(cameraModel)
        permissions.append(cameraPermission)
        
        let microphonePermission = CXMicrophonePermission()
        let microphoneModel = PermissionModel()
        microphoneModel.type.accept(.microphone)
        microphoneModel.status.accept(microphonePermission.status)
        items.append(microphoneModel)
        permissions.append(microphonePermission)
        
        let locationAlwaysPermission = CXLocationAlwaysPermission()
        let locationAlwaysModel = PermissionModel()
        locationAlwaysModel.type.accept(.locationAlways)
        locationAlwaysModel.status.accept(locationAlwaysPermission.status)
        items.append(locationAlwaysModel)
        permissions.append(locationAlwaysPermission)
        
        let locationInUsePermission = CXLocationInUsePermission()
        let locationWhenInUseModel = PermissionModel()
        locationWhenInUseModel.type.accept(.locationInUse)
        locationWhenInUseModel.status.accept(locationInUsePermission.status)
        items.append(locationWhenInUseModel)
        permissions.append(locationInUsePermission)
        
        let deviceBiometricsPermission = CXDeviceBiometricsPermission(localizedReason: "Biometrics Authentication")
        let deviceBiometricsModel = PermissionModel()
        deviceBiometricsModel.type.accept(.deviceBiometrics)
        deviceBiometricsModel.status.accept(deviceBiometricsPermission.status)
        items.append(deviceBiometricsModel)
        permissions.append(deviceBiometricsPermission)
        
        let devicePasscodePermission = CXDevicePasscodePermission()
        let devicePasscodeModel = PermissionModel()
        devicePasscodeModel.type.accept(.devicePasscode)
        deviceBiometricsModel.status.accept(devicePasscodePermission.status)
        items.append(devicePasscodeModel)
        permissions.append(devicePasscodePermission)
        
        let bluetoothPermission = CXBluetoothPermission()
        let bluetoothModel = PermissionModel()
        bluetoothModel.type.accept(.bluetooth)
        bluetoothModel.status.accept(bluetoothPermission.status)
        items.append(bluetoothModel)
        permissions.append(bluetoothPermission)
        
        let speechPermission = CXSpeechPermission()
        let speechModel = PermissionModel()
        speechModel.type.accept(.speech)
        speechModel.status.accept(speechPermission.status)
        items.append(speechModel)
        permissions.append(speechPermission)
        
        // reason: 'Use of the class <INPreferences: 0x6000029560e0> from an app requires the entitlement com.apple.developer.siri.
        //let siriPermission = CXSiriPermission()
        //let siriModel = PermissionModel()
        //siriModel.type.accept(.intents)
        //siriModel.status.accept(siriPermission.status)
        //items.append(siriModel)
        //permissions.append(siriPermission)
        
        let contactsPermission = CXContactsPermission()
        let contactsModel = PermissionModel()
        contactsModel.type.accept(.contacts)
        contactsModel.status.accept(contactsPermission.status)
        items.append(contactsModel)
        permissions.append(contactsPermission)
        
        let reminderPermission = CXReminderPermission()
        let reminderModel = PermissionModel()
        reminderModel.type.accept(.reminder)
        reminderModel.status.accept(reminderPermission.status)
        items.append(reminderModel)
        permissions.append(reminderPermission)
        
        let calendarPermission = CXCalendarPermission()
        let calendarModel = PermissionModel()
        calendarModel.type.accept(.event)
        calendarModel.status.accept(calendarPermission.status)
        items.append(calendarModel)
        permissions.append(calendarPermission)
        
        //let list = makeAnimatedListProvider {
        //    Observable.just([AnimatableSectionModel(model: sectionModel, items: items)])
        //}
        self.items.accept([AnimatableSectionModel(model: sectionModel, items: items)])
    }
    
    override func configure() {
        
    }
    
    override func makeUI() {
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white //UIColor.cx.color(withHexString: "0x333333", alpha: 0.5)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.cx.cornerRadius = 10
        tableView.cx.masksToBounds = true
        view.addSubview(tableView)
        tableView.cx.makeConstraints { maker in
            maker.top.equalToAnchor(self.view.cx.safeTopAnchor).offset(10)
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
    
    func configureCell(tv tableView: UITableView, indexPath: IndexPath, item: PermissionModel) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "PermissionCell")
        if cell == nil {
            cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: "PermissionCell")
        }
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator
        
        item.type.map({"权限--" + $0.description + ": "}).bind(to: cell!.textLabel!.rx.text).disposed(by: disposeBag)
        cell?.textLabel?.font = UIFont.cx.semiboldPingFang(ofSize: 16)
        cell?.textLabel?.textColor = UIColor.cx.color(withHexString: "0x333333")
        
        item.status.map({"授权状态: " + $0.description}).bind(to: cell!.detailTextLabel!.rx.text).disposed(by: disposeBag)
        cell?.detailTextLabel?.font = UIFont.cx.regularPingFang(ofSize: 15)
        cell?.detailTextLabel?.textColor = UIColor.cx.color(withHexString: "0x666666")
        
        return cell!
    }
    
    func itemDidSelect(at indexPath: IndexPath) {
        CXLog.info("row-\(indexPath.row): did click!")
        let permission = permissions[indexPath.row]
        if !permission.authorized {
            if permission is CXDeviceBiometricsPermission {
                let pm = permission as! CXDeviceBiometricsPermission
                CXLog.info("localizedReason=\(pm.localizedReason)")
            }
            permission.requestAccess { [weak self] result in
                self?.handlePermissionResult(result, with: indexPath)
            }
        } else {
            ms.makeToast(text: "\(permission.type.description) 已授权！")
        }
    }
    
    func handlePermissionResult(_ result: CXPermissionResult, with indexPath: IndexPath) {
        let model = items.value[indexPath.section].items[indexPath.row]
        model.type.accept(result.type)
        model.status.accept(result.status)
    }
    
}
