//
//  HomePresenter.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class HomePresenter: BasePresenter {
    
    private unowned let view: HomeViewable
    private var dataSource: [DataModel] = []
    private let apiClient: ApiClient
    
    init(view: HomeViewable, apiClient: ApiClient) {
        self.view = view
        self.apiClient = apiClient
        super.init()
        self.addNotification()
    }
    
    func addNotification() {
        
    }
    
    override func loadData() {
        let names: [String] = ["Device Info", "Photo Library", "EmptyData Set", "SVGA Animation", "Transition"]
        for name in names {
            let model = DataModel(name: name)
            dataSource.append(model)
        }
        view.refreshView()
    }
    
    private func configure(cell: HomeTableViewCell, at indexPath: IndexPath) {
        let index = indexPath.item
        if index < dataSource.count {
            cell.bind(to: dataSource[index])
        }
    }
    
}

extension HomePresenter: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell")
        if cell == nil {
            cell = HomeTableViewCell(style: .default, reuseIdentifier: "HomeTableViewCell")
        }
        cell!.selectionStyle = .none
        cell!.accessoryType = .disclosureIndicator
        
        configure(cell: cell as! HomeTableViewCell, at: indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let homeController = view as? HomeViewController else {
            return
        }
        var controller: BaseViewController?
        let model = dataSource[indexPath.item]
        switch model.name {
        case "Device Info":
            let deviceInfoController = DeviceInfoViewController()
            controller = deviceInfoController
        case "EmptyData Set":
            let edsController = EmptyDataViewController()
            controller = edsController
        case "SVGA Animation":
            controller = SvgaViewController()
        default: break
        }
        guard let toController = controller else {
            return
        }
        toController.hidesBottomBarWhenPushed = true
        homeController.navigationController?.pushViewController(toController, animated: true)
    }
    
}
