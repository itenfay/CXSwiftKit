//
//  TransitionCollectionViewCell.swift
//  CXSwiftKit_Example
//
//  Created by Teng Fei on 2023/7/25.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit

class TransitionCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var stackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setup() {
        stackView.cx.cornerRadius = 10
    }
    
}
