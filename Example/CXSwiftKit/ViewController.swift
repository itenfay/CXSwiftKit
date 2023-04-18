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
    
    @IBOutlet weak var vSlider: CXVerticalSlider!
    @IBOutlet weak var progressButton: CXCircleProgressButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        vSlider.cx.cornerRadius = vSlider.cx.width/2
        vSlider.maximumValue = 100
        vSlider.minimumValue = 0
        vSlider.maximumImage = UIColor.white.cx_drawImage()
        vSlider.minimumImage = UIColor.lightGray.cx.drawImage()
        vSlider.thumbImage = UIColor.black.cx.makeImageWithSize(CGSize(width: vSlider.cx.width, height: 20), cornerRadius: 10)
        vSlider.onValueChanged = { (value, ended) in
            print("value=\(value), ended=\(ended)")
        }
        vSlider.setValue(50, animated: true)
        
        progressButton.trackColor = UIColor.gray
        progressButton.progressColor = UIColor.orange
        progressButton.lineWidth = 4.0
        progressButton.animationDuration = 30
        progressButton.trackMargin = 5
        progressButton.reverse = true
        progressButton.onFinish = {
            print("The progress is finished.")
        }
        progressButton.startAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
