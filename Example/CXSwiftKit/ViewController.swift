//
//  ViewController.swift
//  CXSwiftKit
//
//  Created by dyf on 11/14/2022.
//  Copyright (c) 2022 dyf. All rights reserved.
//

import UIKit
import CXSwiftKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://www.baidu.com/432432/afdfsf.jpg") {
            let fileName = CXFileToolbox.fileName(withURL: url)
            let filePath = CXFileToolbox.filePath(withURL: url, atDirectory: "cx.swkit.dir")
            CXLogger.log(level: .info, message: "fileName=\(fileName), filePath=\(filePath)")
            CXFileToolbox.write(data: Data(contentsOf: url), toPath: filePath)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
