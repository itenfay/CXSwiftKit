//
//  DeviceInfoViewController.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit

class DeviceInfoViewController: BaseViewController {
    
    private var tableView: UITableView!
    private var dataArray: [String] = []
    private lazy var device: CXDevice = CXDevice()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "设备信息"
        loadData()
    }
    
    override func configure() {
        dataArray.append("System Name:" + device.systemName)
        dataArray.append("System Version:" + device.systemVersion)
        dataArray.append("Device Name:" + device.deviceName)
        dataArray.append("Device Model:" + device.model)
        dataArray.append("Device Localized Model:" + device.localizedModel)
        dataArray.append("IDFV:" + device.idfv)
        // Defines this macro: CXAdTracking
        //dataArray.append("IDFA:" + device.idfa)
        dataArray.append("Device Identifier:" + device.identifier)
        dataArray.append("Generating uuid:" + device.uuid())
        dataArray.append("Model Name:" + device.modelName())
        dataArray.append("IP Address:" + (device.ipAddress() ?? ""))
        dataArray.append("SSID:" + (device.ssid() ?? ""))
        dataArray.append("WiFi Mac:" + (device.wifiMac() ?? ""))
        dataArray.append("Mobile Country Code:" + (device.mobileCountryCode() ?? "None"))
        dataArray.append("Mobile Network Code:" + (device.mobileNetworkCode() ?? "None"))
        dataArray.append("Mobile IMSI:" + (device.imsi()))
        dataArray.append("ISO Country Code:" + (device.isoCountryCode() ?? "None"))
        dataArray.append("Carrier Name:" + (device.carrierName()))
        dataArray.append("Carrier Net Type:" + (device.carrierNetType()))
        dataArray.append("Device Type:" + (device.isSimulator ? "Simulator" : "Device"))
    }
    
    override func makeUI() {
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
            maker.leading.equalTo(0)
            maker.trailing.equalTo(0)
            maker.bottom.equalTo(-cxSafeAreaBottom)
        }
    }
    
    func loadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DeviceInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DeviceInfoCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DeviceInfoCell")
        }
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator
        
        let contents = dataArray[indexPath.item].components(separatedBy: ":")
        cell?.textLabel?.text = contents[0] + ":"
        cell?.textLabel?.font = UIFont.cx.semiboldPingFang(ofSize: 16)
        cell?.textLabel?.textColor = UIColor.cx.color(withHexString: "0x333333")
        
        cell?.detailTextLabel?.text = contents[1]
        cell?.detailTextLabel?.font = UIFont.cx.regularPingFang(ofSize: 15)
        cell?.detailTextLabel?.textColor = UIColor.cx.color(withHexString: "0x666666")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
