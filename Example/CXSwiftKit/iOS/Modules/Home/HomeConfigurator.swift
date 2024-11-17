//
//  HomeConfigurator.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class HomeConfigurator: Configurator {
    
    typealias C = HomeViewController
    
    func configure(controller: HomeViewController) {
        let apiClient = DLApiClient(urlSession: DefaultURLSession())
        
        let presenter = HomePresenter(view: controller, apiClient: apiClient)
        controller.presenter = presenter
    }
    
}
